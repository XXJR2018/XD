//
//  RemoteNTFManager.m
//  DDGProject
//
//  Created by Cary on 15/1/21.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import "RemoteNTFManager.h"

@implementation RemoteNTFManager

#pragma mark - Public methods

+ (id)defaultManager
{
    static RemoteNTFManager *singleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    return singleton;
}
    
+ (void)defaultSettingWithOptions:(NSDictionary *)launchOptions
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
    //可以添加自定义categories
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
#else
    //categories 必须为nil
    [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                      UIRemoteNotificationTypeSound |
                                                      UIRemoteNotificationTypeAlert)
                                          categories:nil];
    
#endif
    
//    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//    如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:JPUSH_APPKEY channel:@"Publish channel" apsForProduction:true advertisingIdentifier:nil];
    
}

- (void)receiveDeviceToken:(NSData *)token error:(NSError *)error
{
    if (error) {
        NSLog(@"reister for remote notification error : %@",error);
        return;
    }
    
    if (!token) return;
    
    NSString *devicetokenString = [[[token description]
                                    stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                                   stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"devicetoken : %@",devicetokenString);
    
    if (devicetokenString.length > 0)
    {
        // 获取token，保存
//        [DDGSetting sharedSettings].currtentUserToken = devicetokenString;
       
       // 此处是真正的极光推送的 注册ID
       NSLog(@"JPush registrationID:%@",[JPUSHService registrationID]);
    }
    
}

/*
 
 {
    aps =     {
    alert = "\U60a8\U6709\U4e00\U6761\U65b0\U6d88\U606f";
    badge = 1;
    sound = default;
    };
    f = cdw;
    m = 153001108573258160;
    t = cdw2;
 }
 
 */

- (void)handlePushNotificationWithInfo:(NSDictionary *)info applicationState:(UIApplicationState)state
{
    if (!info) return;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGPushNotification
                                                        object:nil
                                                      userInfo:info];
}


@end
