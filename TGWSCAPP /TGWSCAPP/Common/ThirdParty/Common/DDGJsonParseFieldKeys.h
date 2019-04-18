//
//  DDGJsonParseFieldKeys.h
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#ifndef DDGUtils_DDGJsonParseFieldKeys_h
#define DDGUtils_DDGJsonParseFieldKeys_h

#define True                @"true"
#define False               @"false"
#define kSignId             @"signId"
#define kUser_ID            @"uid"
#define kUUID               @"UUID"
#define kStatus             @"status"
#define kUser_ID2           @"user_id"

#define kPage               @"currentPage"
#define kPageSize           @"everyPage"
#define kSign               @"sign"
#define kParam              @"param"

/**
 *  响应 ＝＝＝ common
 */
#define kResult             @"result"   // 数据列表
#define kImei               @"imei"
#define kApple              @"apple"


// app_token、提交平台机型分辨率等
#define APPToken           @"token"
#define kPlatForm          @"platform"
#define kDPI               @"dpi"
#define kOS                @"os"
#define kBrand             @"brand"

// 检查版本更新
#define kVersion           @"version"
#define kSlogan_Text       @"slogan_text"
#define kUpdate_Url        @"update_url"

// 坐标
#define kLatitude           @"Latitude"
#define kLongitude          @"Longitude"

//推送
#define kAction             @"action"
#define kType               @"type"
#define kRemoteTitle        @"title"
#define kRemoteMessage      @"message"
#define kPTag               @"tag"
#define kBadge              @"badge"


//登录--请求
#define kMobile             @"telephone"//手机号，账号
#define kPassword           @"password"//密码
#define kMobile_Code        @"code"
#define kPayPwd             @"payPwd"   // 支付密码

#define kSess_ID            @"sess_id"
#define kSureResetPassword  @"repassword"
#define kLaiyuan_sub        @"laiyuan_sub"
#define kLaiyuan            @"laiyuan"

// 登录－－响应
#define kUser_Info          @"user_info"
#define kAvatar_Url         @"avatar_url"
#define kAvatar             @"avatar"
#define kRealName           @"realName"
#define kIsPay              @"isPay"            // 是否设置支付密码


#endif
