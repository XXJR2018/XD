//
//  PDNotifications.h
//  PMH.Common
//
//  Created by well xeon on 9/10/12.
//  Copyright (c) 2012 Paidui, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>



#pragma mark -
#pragma mark ==== Notifications ====
#pragma mark -


/**
 *  推送通知
 */
/*!
 @brief 通知
 */
FOUNDATION_EXPORT NSString *const DDGPushNotification;

/*!
 @brief 登陆成功通知
 */
FOUNDATION_EXPORT NSString *const DDGAccountEngineDidLoginNotification;

/*!
 @brief 退出登陆成功通知
 */
FOUNDATION_EXPORT NSString *const DDGAccountEngineDidLogoutNotification;

/*!
 @brief token过期通知 signid过期通知
 */
FOUNDATION_EXPORT NSString *const DDGUserTokenOutOfDataNotification;


/*!
 @brief 设置通知
 */
FOUNDATION_EXPORT NSString *const DDGPushNotificationSetting;

/*!
 @brief userInfo需要更新通知
 */
FOUNDATION_EXPORT NSString *const DDGNotificationAccountNeedRefresh;



/*!
 @brief 完善银行卡信息成功
 */
FOUNDATION_EXPORT NSString *const DDGImproveBankCardInforSuccessNotification;

/*!
 @brief 账号类型切换的通知
 */
FOUNDATION_EXPORT NSString *const DDGSwitchAccountTypeNotification;

/*!
 @brief 首页跳转到其它tab的通知
 */
FOUNDATION_EXPORT NSString *const DDGSwitchTabNotification;


/*!
 @brief
 */
FOUNDATION_EXPORT NSString *const LocationGPSNotOnNotification;

/*!
 @brief
 */
FOUNDATION_EXPORT NSString *const LocationCityDidChangeNotification;

/*!
 @brief 标签变化通知
 */
FOUNDATION_EXPORT NSString *const DDGMarksChangedNotification;

/*!
 @brief 支付密码设置或者修改通知
 */
FOUNDATION_EXPORT NSString *const DDGPayPassWordNotification;

/*!
 @brief 支付宝支付结果通知
 */
FOUNDATION_EXPORT NSString *const DDGPayResultNotification;


/*!
 @brief 购物车需要计算的通知
 */
FOUNDATION_EXPORT NSString *const DDGCartNeedCountNotification;


/*!
 @brief 购物车下标更新的通知
 */
FOUNDATION_EXPORT NSString *const DDGCartUpdateNotification;

/*!
 @brief 收到聊天消息的通知
 */
FOUNDATION_EXPORT NSString *const DDGReciveChatMsgNotification;


/*!
 @brief 滚到详情页面的通知
 */
FOUNDATION_EXPORT NSString *const DDGGotoInfoNotification;


