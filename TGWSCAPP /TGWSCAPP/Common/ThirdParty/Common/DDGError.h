//
//  DDGError.h
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>

CF_EXPORT NSString *const kDDGErrorDomain;

//错误类型
typedef NS_ENUM(NSUInteger, DDGErrorType)
{
    DDGUnknownErrorType = 0,
    DDGConnectionFailureErrorType = 1,
    DDGRequestTimedOutErrorType = 2,
    DDGAuthenticationErrorType = 3,
    DDGRequestCancelledErrorType = 4,
    DDGUnableToCreateRequestErrorType = 5,
    DDGInternalErrorWhileBuildingRequestType  = 6,
    DDGInternalErrorWhileApplyingCredentialsType  = 7,
    DDGFileManagementError = 8,
    DDGTooMuchRedirectionErrorType = 9,
    DDGUnhandledExceptionError = 10,
    DDGCompressionError = 11,
    DDGASIHTTPError = 12,                 //1-12， 为asihttprequest的错误， 网络错误
    
    DDGUndefinedError = 100,              //未知错误
    DDGNetworkUnreachableError,
    DDGLocationDisabledError,
    DDGLocationFailedError,
    //JSON解析错误
    DDGParseJSONError,
    //获取服务器数据失败
    DDGReturnDataError,
    //未登录或者登录超时
    DDGLoginTimeoutError,
    DDGDBOperationError,
    DDGNeedConfirmError, //需要进一步确认
    
    DDGStatusDuplicatePostError , //重复提交
    
    PDNavigationPopBack = 30008 ,//navigationController pop
    
    
    DDGRequestErrorParamInsufficiency = 40001,  // 参数不全
    DDGRequestErrorParamFormatError = 40002,  // 参数格式不对
    DDGRequestErrorVerifyFailed = 40003,  // 验证失败
    DDGRequestErrorResoureInexistence = 40005,  // 资源不存在
    DDGRequestErrorModuleInvalid = 40006,  // 模块不允许访问
    
    DDGRequestErrorUploadFailed = 40201,  // 提交失败
    
    DDGRequestErrorDataInsertError = 50001,  // 数据插入错误
    DDGRequestErrorDataUpdataError = 50002,  // 数据更新错误
    DDGRequestErrorDataDeleteResoureError = 50003,  // 数据删除错误
    DDGRequestErrorDataOperationError = 50004,  // 数据操作错误
    
    DDGRequestErrorUserInexistence = 60001,  // 用户不存在
    DDGRequestErrorSendNoteFailed = 60002,  // 验证短信发送失败
    DDGRequestErrorVerifyCodeError = 60003,  // 短信验证码错误
    DDGRequestErrorVerifyCodeTimeOut = 60004,  // 短信验证码超时（180秒）
    DDGRequestErrorNotSendVerifyCode = 60005,  // 尚未发送验证码
    DDGRequestErrorSendVerifyCodeTwiceInMinute = 60006,  // 60秒内不能重复发送验证码
    DDGRequestErrorPasswordMismatching = 60007,  // 两次输入的密码不一致
    DDGRequestErrorPasswordMistaken = 60008,  // 密码错误
    DDGRequestErrorPhoneNumNotRegister = 60009,  // 该手机号尚未注册
    DDGRequestErrorPhoneNumHadRegister = 60010,  // 该手机号已经注册
    DDGRequestErrorPasswordLessThan6Letters = 60021,  // 密码长度不能少于6位
    DDGRequestErrorPasswordLongerThan20Letters = 60022,  // 密码长度不能大于20位
    
};


/*!
 @interface PDError
 @brief 用于封装处理/传递程序中各种错误
 */
@interface DDGError : NSError

@property (nonatomic,copy) NSString *button_msg;

/*!
 @brief     返回指定错误类型对应的错误信息
 @param     errorType 错误类型
 @return    错误类型对应的错误信息
 */
+ (NSString *)errorMessageForErrorType:(DDGErrorType)errorType;

/*!
 @brief     根据给定错误类型和信息创建PDError实例
 @param     errorType 错误类型
 @param     errorMessage 错误描述信息
 @return    PDError实例
 */
+ (id)errorWithCode:(NSUInteger)errorType errorMessage:(NSString *)errorMessage;
/*!
 @brief     根据给定错误类型和信息创建PDError实例
 @param     errorType 错误类型
 @param     errorMessage 错误描述信息
 @return    PDError实例
 */
- (id)initWithCode:(NSUInteger)errorType errorMessage:(NSString *)errorMessage  buttonMsg:(NSString *)button_msg;

/*!
 @brief     根据 NSError 的实例生成 PDError
 @param     error NSError 的实例
 @return    PDError实例
 */
+ (id)errorWithError:(NSError *)error;
/*!
 @brief     根据 NSError 的实例生成 PDError
 @param     error NSError 的实例
 @return    PDError实例
 */
- (id)initWithError:(NSError *)error;




@end
