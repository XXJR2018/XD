//
//  JsonResult.h
//  DDG.Models
//
//  Created by Cary on 13/11/13.
//  Copyright (c) 2013 EVT, Inc. All rights reserved.
//

#import "BaseModel.h"

/*!
 @enum DDGStatus json数据类型,
 0-服务器返回错误,
 1-成功,
 2-未授权,
 3-未登陆或登录超时
 4-需要进一步确认
 5-加密狗验证失败
 99-重复提交
 */
typedef NS_ENUM(NSInteger, DDGStatus)
{
    DDGStatusError           = 0,  // 服务器返回错误
    DDGStatusSuccess         = 1,  // 成功
    DDGStatusUnAuthorized    = 2,  // 未授权
    DDGStatusLoginTimeOut    = 3,  // 未登陆或登录超时
    DDGStatusNeedConfirm     = 4,  // 需要进一步确认
    DDGStatusSoftDogFailed   = 5,  // 加密狗验证失败
    DDGStatusDuplicatePost   = 99, // 重复提交
    
    DDGStatusMoneyTooLittle   = 301, // 充值金额必须大于等于1元
    DDGStatusBankCardError    = 302, // 不支持的银行或者非法输入
    
    DDGStatusLackParameter   = 401, // 请求参数为空或缺少参数
    DDGStatusUserCodeError   = 402, // pam参数解释错误
    DDGStatusDataKeyError    = 403, // sign签名错误
    DDGStatusNoData          = 404, // 查询结果为空或 没有对应的结果
    DDGStatusAPIError        = 405, // 支付密码错误
    DDGStatusUserError       = 406, // 用户不存在 / 或用户名及密码错误
    DDGStatusAccountError    = 407, // 帐户状态异常
    DDGStatusVersionNubError = 408, // 服务版本号异常
    DDGStatusAPIFetchContinuallyError = 409, // 订单提交太频繁,请30秒后再试
    DDGStatusPublicKeyOutData = 410, // 公钥已失效，请重新获取公钥
    DDGStatusPhoneNumError   = 411, // 手机号码格式错误
    DDGStatusPhoneNumOccupied = 412, // 手机号码已被占用
    DDGStatusPhoneCodeInvalid = 413, // 手机验证码无效
    DDGStatusPhoneCodeOutData = 414, // 手机验证码已过期
    DDGStatusPhoneCodeError  = 415, // 手机验证码错误
    DDGStatusInvalidRefer = 416, // 查询不到此推荐人
    DDGStatusUserRealInfoError   = 417, // 身份证与真实姓名不符
    DDGStatusUserIDNumFormatError = 418, // 身份证格式错误
    DDGStatusUserIDNumOccupied = 419, // 身份号码重复
    DDGStatusPWDLessThanSix   = 420, // 密码最少6位
    DDGStatusBankCodeInvalid = 421, // 无效银行卡号
    DDGStatusBankCodeError   = 422, // 不支持的银行或者非法输入
    DDGStatusUserInfoUnconfirmed    = 423, // 没有实名认证
    DDGStatusBankCardInfoIncomplete = 424, // 银行卡信息不正确(没有找到对应到的银行卡ID的数据)
    DDGStatusPlanInvalid     = 425, // 无效的标地
    DDGStatusPlanFinished    = 426, // 标地已结束投标
    DDGStatusPhoneNumUnconfirmed    = 427, // 没有通过手机认证
    DDGStatusUserRealInfoConfirmFail = 428, // 没有通过实名认证
    DDGStatusUserMoneyUnenough    = 429, // 用户余额不足
    DDGStatusUserInvestNoMoney    = 430, // 投标金额必须是大于0数字
    
    
//    DDGStatusUndefined       = 999, // 生成订单号失败
//    DDGStatusCreateLLRechargeOrderFailed  = 9999
    DDGStatusGetTokenFail       = 498, // 令牌生成错误
    DDGStatusTokenOutData       = 499 // 令牌过时或令牌无效，请重新登录
    
    
};

@interface JsonResult : BaseModel

/*!
 @brief     signId
 */
@property (nonatomic, copy) NSString *signId;
/*!
 @brief     errorCode
 */
@property (nonatomic, copy) NSString *errorCode;
/*!
 @brief     forward
 */
@property (nonatomic, copy) NSString *forward;
/*!
 @brief     resMsg
 */
@property (nonatomic, copy) NSString *message;

/*!
 @brief     success 成功标示
 */
@property (nonatomic, assign) int success;
/*!
 @brief     page 分页状态相关数据
 */
@property (nonatomic, strong) NSDictionary *page;
/*!
 @brief     rows  分页list数据
 */
@property (nonatomic, strong) NSArray *rows;

/*!
 @brief     attr  非标准格式数据
 */
@property (nonatomic, strong) NSDictionary *attr;



@end
