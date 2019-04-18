//
//  DDGAccountManager.h
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "DDGUser.h"


@interface DDGAccountManager : BaseModel

/*
 当前登陆的帐户
 */
/*!
 @property  PMHAccountManager sharedManager
 @brief  单例帐户管理器
 */
+ (DDGAccountManager *)sharedManager;

/*!
 @property  PMHUser user
 @brief     用户
 */
@property (nonatomic,strong) DDGUser *user;

/*!
 @property  PMHUser user
 @brief     用户头像
 */
@property (nonatomic,strong) UIImage *userLogo;

/*!
 @property  NSMutableArray sessionCookiesArray
 @brief     请求的 session
 */
@property (nonatomic,copy) NSMutableArray *sessionCookiesArray;

/*!
 @property  NSDictionary userInfo
 @brief     缓存的用户信息
 */
@property (nonatomic,strong) NSMutableDictionary *userInfo;


/*!
 @brief     是否已登录
 @return    BOOL
 */
- (BOOL)isLoggedIn;

/*!
 @brief     是否已完善资料
 @return    BOOL
 */
-(BOOL)isInfoFinished;


/*!
 @brief     设置用户数据
 @param     dictionary 用户数据字典
 @return    void
 */
- (void)setUserInfoWithDictionary:(NSDictionary *)dictionary;

/*!
 @brief     保存用户数据
 @return    void
 */
- (void)saveUserData;

/*!
 @brief     删除用户数据(缓存与内存)
 */
- (void)deleteUserData;

/*!
 @brief     获取登录用户信息并保存在缓存
 */
+ (void)getUserInfo:(Block_Void)block;


@end
