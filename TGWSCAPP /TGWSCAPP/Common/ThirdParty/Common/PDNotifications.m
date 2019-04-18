//
//  PDNotifications.m
//  PMH.Common
//
//  Created by well xeon on 9/10/12.
//  Copyright (c) 2012 Paidui, Inc. All rights reserved.
//

#import "PDNotifications.h"

/**
 *  推送通知
 */
/*!
 @brief 通知
 */
NSString *const DDGPushNotification = @"DDGPushNotification";

/*!
 @brief 登陆成功通知
 */
 NSString *const DDGAccountEngineDidLoginNotification = @"DDGAccountEngineDidLoginNotification";

/*!
 @brief 退出登陆成功通知
 */
 NSString *const DDGAccountEngineDidLogoutNotification = @"DDGAccountEngineDidLogoutNotification";

/*!
 @brief token过期通知  signId过期通知
 */
NSString *const DDGUserTokenOutOfDataNotification = @"DDGUserTokenOutOfDataNotification";


/*!
 @brief 设置通知
 */
NSString *const DDGPushNotificationSetting = @"DDGPushNotificationSetting";

/*!
 @brief userInfo需要更新通知
 */
NSString *const DDGNotificationAccountNeedRefresh = @"DDGNotificationAccountNeedRefresh";


/*!
 @brief 账号类型切换的通知
 */
NSString *const DDGSwitchAccountTypeNotification = @"DDGSwitchAccountTypeNotification";

/*!
 @brief 首页跳转到其它tab的通知
 */
NSString *const DDGSwitchTabNotification = @"DDGSwitchTabNotification";

/*!
 @brief GPS未打开通知
 */
NSString *const LocationGPSNotOnNotification = @"LocationGPSNotOnNotification";

/*!
 @brief
 */
NSString *const LocationCityDidChangeNotification = @"LocationCityDidChangeNotification";

/*!
 @brief 标签变化通知
 */
NSString *const DDGMarksChangedNotification = @"DDGMarksChangedNotification";

/*!
 @brief 支付密码设置或者修改通知
 */
NSString *const DDGPayPassWordNotification = @"DDGPayPassWordNotification";


/*!
 @brief 支付宝支付结果通知
 */
NSString *const DDGPayResultNotification = @"DDGPayResultNotification";


/*!
 @brief 购物车需要计算的通知
 */
NSString *const DDGCartNeedCountNotification = @"DDGCartNeedCountNotification";


/*!
 @brief 购物车下标更新的通知
 */
NSString *const DDGCartUpdateNotification = @"DDGCartUpdateNotification";


/*!
 @brief 收到聊天消息的通知
 */
NSString *const DDGReciveChatMsgNotification = @"DDGReciveChatMsgNotification";



/*!
 @brief 滚到详情页面的通知
 */
NSString *const DDGGotoInfoNotification = @"DDGGotoInfoNotification";





