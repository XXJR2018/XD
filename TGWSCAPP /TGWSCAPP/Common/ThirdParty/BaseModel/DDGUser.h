//
//  DDGUser.h
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDGUser : BaseModel<NSCoding>

/*!
 @property  NSString userIdString
 @brief     userId
 */
@property (nonatomic, copy) NSString *uid;

/*!
 @brief    userName
 */
@property (nonatomic, copy) NSString *realName;

/*!
 @brief    是否为注册状态,用来判断是否弹窗实名
 */
@property (nonatomic, copy) NSString * regist;


/*!
 @brief    mobile
 */
//账号密码
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *passWord;


- (instancetype)initWithDict:(NSDictionary *)dict;


@end
