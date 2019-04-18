//
//  DDGSetting.h
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *  全局变量存储与管理
 **/
@interface DDGSetting : NSObject


/*!
 @property  NSString
 @brief     uid
 */
@property (nonatomic, copy) NSString *uid;

/*!
 @property  NSString
 @brief     signId
 */
@property (nonatomic, copy) NSString *signId;

/**
 *  accountViewNeedRefresh 帐户页面是否需要刷新
 */
@property (nonatomic, assign) BOOL accountNeedRefresh;

/*!
 @property  NSMutableDictionary
 @brief     用户信息
 */
@property (nonatomic, strong) NSMutableDictionary  *userInfo;

/*!
 @property  NSString
 @brief     userName
 */
@property (nonatomic, copy) NSString  *realName;

/*!
 @property  NSString
 @brief     mobile
 */
//账号密码
@property (nonatomic, copy) NSString  *mobile;
@property (nonatomic, copy) NSString  *passWord;


/*!
 @property  NSString name
 @brief     真实姓名
 */
@property (nonatomic, copy) NSString *name;

/*!
 @property  NSString UUID_MD5
 @brief     加密后的UUID
 */
@property (nonatomic, copy) NSString *UUID_MD5;


/*!
 @property  NSUInteger domainSelectedIndex
 @brief     切换环境
 */
@property (nonatomic, assign) NSUInteger domainSelectedIndex;


#pragma mark === 定位相关
/*!
 @property  BOOL locationSucceed
 @brief     启动程序是否定位过
 */
@property (nonatomic, getter = isLocationSucceed) BOOL locationSucceed;

/*!
 @brief     定位时间
 */
@property (nonatomic, retain) NSDate *lastLocationDate;

/*!
 @property  BOOL canLocate
 @brief     是否允许定位
 */
@property (nonatomic, assign) BOOL canLocate;

/*!
 @property  NSString currentAreaId
 @brief     当前所在的区域Id
 */
@property (nonatomic, copy) NSString *currentAreaId;

/*!
 @property  NSString currentCityName
 @brief     当前所在的城市名称
 */
@property (nonatomic, copy) NSString *currentCityName;

/*!
 @property  NSString locationProvinceString
 @brief     定位的省
 */
@property (nonatomic, copy) NSString *locationProvinceString;

/*!
 @property  NSString locationCityString
 @brief     定位的城市
 */
@property (nonatomic, copy) NSString *locationCityString;

/*!
 @property  NSString locationCityCode
 @brief     定位的城市code
 */
@property (nonatomic, copy) NSString *locationCityCode;

/*!
 @property  NSString latitude
 @brief     定位的纬度
 */
@property (nonatomic, assign) double latitude;

/*!
 @property  NSString longitude
 @brief     定位的经度
 */
@property (nonatomic, assign) double longitude;

#pragma mark -
#pragma mark ==== Methods ====
#pragma mark -

/*!
 @brief     PDSettings 共享单例
 @return    PDSettings
 */
+ (DDGSetting *)sharedSettings;




@end
