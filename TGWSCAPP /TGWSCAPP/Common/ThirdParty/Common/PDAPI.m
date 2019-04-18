//
//  PDAPI.m
//  DDGProject
//
//  Created by Cary on 15/2/27.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import "PDAPI.h"

/*!
 @brief 基础API接口地址, 注意后面必须有/
 */

// 接口URL
static NSString *const kBaseURL =   @"https://app.tgwmall.cn/"; //@"https://www.tiangouwo.com/";

#if PMHEnableSwitchURLGesture
/*!
 @brief 存储baseurl的key
 */
static NSString *const kBaseURLinUserDefaultsString     = @"URLinUserDefaultsString";
/*!
 @brief 存储统计url的key
 */
static NSString *const kStatURLinUserDefaultsString     = @"kStatURLinUserDefaultsString";


#endif
// 版本信息
static NSString *const kDDGUserBorrowVersionAPIString= @"appMall/app/version/upgradeInfo";

// 上传材料、头像
static NSString *const kDDGGetSendFileAPIString = @"appMall/upload/uploadImage";

// 查询用户信息
static NSString *const kDDGGetUserBaseInfoAPIString = @"appMall/account/cust/info/getCustInfo";


#pragma mark 登陆

// 验证码登陆
static NSString *const kDDGUserKJLoginAPIString= @"appMall/login/kjLogin";

// 微信登陆
static NSString *const kDDGUserWXLoginAPIString= @"appMall/login/wxLogin";

@implementation PDAPI

// 跳转微信端h5路径
+ (NSString *)WXSysRouteAPI{
#if DEBUG
    return @"https://app.tgwmall.cn/";           //生产环境
//    return @"http://192.168.10.182/";   // 测试环境
    
#else
    return kBaseURL;
#endif
}

//服务器地址
+ (NSString *)getBaseUrlString{
#if DEBUG
//    return @"https://www.tiangouwo.com/";     //生产环境
    return @"http://192.168.10.182/";        //测试环境
//    return  @"http://192.168.10.132:9991/";        //方然青服务器
//    return @"http://192.168.10.129:82/";        //刘利伟服务器
//    return  @"http://192.168.10.130/";     // 邹全洪
//    return  @"http://192.168.10.167:6401/";     // 曾红卫
    return kBaseURL;
    
#else
    return kBaseURL;
#endif
}

+ (NSString *)getBusiUrlString{
#if DEBUG
//    return @"https://www.tiangouwo.com/";     //生产环境
    return @"http://192.168.10.182/";        //测试环境
//    return @"http://192.168.10.129:82/";        //刘利伟服务器
//    return  @"http://192.168.10.130/";     // 邹全洪
    return kBaseURL;
    
#else
    return kBaseURL;
#endif
}

/*!
 @brief     获取完整api的url
 @param     urlString url的名称
 @return    NSString 完全的api
 */
+ (NSString *)getFullApi:(NSString *)urlString
{
#if PMHEnableSwitchURLGesture
    if (kEnableUrlVersion)
        return DDG_str(@"%@v%@/%@", [PDAPI getBaseUrlString], PDVersionString, urlString);
    else
        return DDG_str(@"%@%@", [PDAPI getBaseUrlString], urlString);
#else
    
    return DDG_str(@"%@%@", [PDAPI getBaseUrlString], urlString);
#endif
}

+ (void)setApp_Token:(NSString *)app_Token{
    if (app_Token && app_Token.length > 1) {
        [[NSUserDefaults standardUserDefaults] setObject:app_Token forKey:APPToken];
    }else
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:APPToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getAppToken{
    NSString *app_token = [[NSUserDefaults standardUserDefaults] objectForKey:APPToken];
    if (!app_token) {
        return @"";
    }
    return app_token;
}

+ (NSString *)getAppTokenAdmin{
    NSString *app_token_admin = @"app_token=0&";
    if ([self getAppToken] && [[self getAppToken] length] > 1) {
        app_token_admin = [NSString stringWithFormat:@"app_token=%@/",[self getAppToken]];
    }
    return app_token_admin;
}



#pragma mark === Function
/*!
 @brief    版本检测
 @return    NSString
 */
+ (NSString *)getCheckVersionAPI{
    return [self getFullApi:kDDGUserBorrowVersionAPIString];
}

/*!
 @brief     上传材料/图片
 @return    NSString
 */
+ (NSString *)getSendFileAPI{
    return [self getFullApi:kDDGGetSendFileAPIString];
}

#pragma mark 登陆
/*!
 @brief   验证码登陆
 @return    NSString
 */
+ (NSString *)userKJLoginInfoAPI{
    return [self getFullApi:kDDGUserKJLoginAPIString];
}

/*!
 @brief   微信登陆
 @return    NSString
 */
+ (NSString *)userWXLoginInfoAPI{
    return [self getFullApi:kDDGUserWXLoginAPIString];
}
/*!
 @brief   获取用户信息，需要登录
 @return    NSString
 */
+ (NSString *)getUserBaseInfoAPI{
    return [self getFullApi:kDDGGetUserBaseInfoAPIString];
}








@end
