//
//  AppDelegate.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/7.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "AppDelegate.h"
#import <AlipaySDK/AlipaySDK.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()<JPUSHRegisterDelegate,UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (void)umengTrack {
    [UMConfigure initWithAppkey:UMENG_APPKEY channel:@"App Store"];
    [MobClick setScenarioType:E_UM_NORMAL];
}

-(void)JPushSet:(NSDictionary *)JPushDic{
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        // Fallback on earlier versions
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Required
     [JPUSHService setupWithOption:JPushDic appKey:JPUSH_APPKEY channel:@"Publish channel" apsForProduction:true advertisingIdentifier:nil];
    
    //JPush 监听登陆成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkDidLogin:)
                                                 name:kJPFNetworkDidLoginNotification
                                               object:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    if (@available(iOS 11.0, *)) {
        //解决iOS11以后tableView顶部状态栏空白问题
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    // 友盟统计
    [self umengTrack];
    
    // 极光推送
    [self JPushSet:launchOptions];
    
    //初始化控制器
    [self setupMainUserInterface];
    
    return YES;
}
/**
 *  登录成功，设置别名，移除监听
 *
 *  @param notification <#notification description#>
 */
- (void)networkDidLogin:(NSNotification *)notification {

    NSLog(@"已登录极光推送");
    if (![[CommonInfo userInfo]objectForKey:@"alias"])
        return;
    
    NSString *alias = [[CommonInfo userInfo] objectForKey:@"alias"];
    
    //极光推送2.9版本后， 设置别名，必须用此新方法
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [JPUSHService setAlias:alias completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
            NSLog(@"code:%ld content:%@ seq:%ld",iResCode,iAlias,seq);
        } seq:0];
    });
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kJPFNetworkDidLoginNotification
                                                  object:nil];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // 极光注册远程通知
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#pragma mark- JPUSHRegisterDelegate
// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

// iOS 10 Support 收到通知就会调用
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support 点击通知弹窗调用
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        //重置脚标(为0)
        [JPUSHService resetBadge];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:DDGPushNotification
                                                                object:nil
                                                              userInfo:userInfo];
        });
    }
    completionHandler();  // 系统要求执行这个方法
}


#pragma mark == 从其他APP跳转回自己APP回调 此处接收外部信息
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {

    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //发送支付宝支付结果消息
            [[NSNotificationCenter defaultCenter] postNotificationName:DDGPayResultNotification object:resultDic];
        }];
    }
    
    NSDictionary *dic = options;
    NSString *soureKey = [dic objectForKey:@"UIApplicationOpenURLOptionsSourceApplicationKey"];
    if ([soureKey isEqualToString:@"com.tencent.xin"]){
        return [WXApi handleOpenURL:url delegate:[DDGWeChat getSharedWeChat]];
    }else if ([soureKey isEqualToString:@"com.tencent.mqq"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QQShareResultNotification" object:url];
        return [TencentOAuth HandleOpenURL:url];
    }else if ([soureKey isEqualToString:@"com.apple.mobilesafari"]){
        return YES;
    }
    
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //去掉推送通知APP显示小红点
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark ==== PrivateMethods ====
#pragma mark -
- (void)setupMainUserInterface{
    //初始化界面
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [ResourceManager navgationTitleColor];
    [self.window makeKeyAndVisible];
    
    self.tabBarRootViewController = [[TabBarViewController alloc] init];
    self.window.rootViewController = self.tabBarRootViewController;
}

#pragma mark ===
-(void)tencentDidNotNetWork{}

-(void)tencentDidNotLogin:(BOOL)cancelled{}

-(void)tencentDidLogin{}

-(void)isOnlineResponse:(NSDictionary *)response{}

#pragma mark ===
-(void)onResp:(QQBaseResp *)resp{}

-(void)onReq:(QQBaseReq *)req{}


@end
