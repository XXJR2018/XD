//
//  RemoteNTFManager.h
//  DDGProject
//
//  Created by Cary on 15/1/21.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  处理推送功能逻辑的管理器
 */
@interface RemoteNTFManager : NSObject

/**
 *  推送消息的alert
 */
@property (nonatomic, copy) NSString *alertString;

@property (nonatomic,assign) BOOL isAPPActive;

/**
 *  单利方法
 *
 *  @return 唯一实例
 */
+ (id)defaultManager;

/**
 *  推送默认设置
 */
+ (void)defaultSettingWithOptions:(NSDictionary *)launchOptions;

/**
 *  处理从苹果APNs返回的设备标识符
 *
 *  @param token 标识符
 *  @param error 错误信息
 */
- (void)receiveDeviceToken:(NSData *)token error:(NSError *)error;


/**
 *  处理推送信息
 *
 *  @param info  推送回来的信息
 *  @param state app状态
 */
- (void)handlePushNotificationWithInfo:(NSDictionary *)info applicationState:(UIApplicationState)state;


@end
