//
//  AppDelegate.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/7.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (void)umengTrack {
    [UMConfigure initWithAppkey:UMENG_APPKEY channel:@"App Store"];
    
    [MobClick setScenarioType:E_UM_NORMAL];
  
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
<<<<<<< .merge_file_qu1lPr
    // 启动图片延时: 1秒
    [NSThread sleepForTimeInterval:2];
=======
    
>>>>>>> .merge_file_Wy8nqR
    // 友盟统计
    [self umengTrack];
    
    //初始化控制器
    [self setupMainUserInterface];
    
    return YES;
}

#pragma mark == 从其他APP跳转回自己APP回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    //  此处接收外部信息
<<<<<<< .merge_file_qu1lPr
=======
    
>>>>>>> .merge_file_Wy8nqR
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
    
    [self getStartUpViewController];
}

- (void)getStartUpViewController{
    
    //初始化界面
    self.tabBarRootViewController = [[TabBarViewController alloc] init];
    self.window.rootViewController = self.tabBarRootViewController;
    self.window.backgroundColor = [ResourceManager navgationTitleColor];
    
    [self.window makeKeyAndVisible];
    
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
