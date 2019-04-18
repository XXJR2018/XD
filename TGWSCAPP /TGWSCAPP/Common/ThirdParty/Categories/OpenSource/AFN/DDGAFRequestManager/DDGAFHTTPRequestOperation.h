//
//  DDGAFHTTPRequestOperation.h
//  DDGUtils
//
//  Created by Cary on 15/1/5.
//  Copyright (c) 2015年 Cary. All rights reserved.
//


/*!
 @enum DDGAPIDataType API返回的数据类型,
 0-未定义，
 1-JSON，
 2-HTML
 */
typedef NS_ENUM(NSUInteger, DDGAPIDataType)
{
    DDGAPIDataTypeUndefined = 0,      //返回的数据没有定义
    DDGAPIDataTypeJSON = 1,           //返回的数据是JSON
    DDGAPIDataTypeHTML = 2,            //返回的数据是HTML
    DDGAPIDataTypeDATA = 3           //返回数据类型为data
};

#import "AFHTTPRequestOperation.h"
#import "JsonResult.h"

#import "DDGError.h"
#import "DDG_Blocks.h"

@protocol BLDelegate;


@interface DDGAFHTTPRequestOperation : AFHTTPRequestOperation

/*!
 @property  id delegate
 @brief     逻辑控制器回调事件接收者, 需要实现 BLDelegate 协议
 */
@property (nonatomic, assign) id<BLDelegate> delegate;


/**
 *  超时时间
 */
@property(nonatomic,strong) JsonResult *jsonResult;

/**
 *  超时时间
 */
@property NSTimeInterval timeoutInterval;

/*!
 @property  NSInteger tag
 @brief     用户自定义信息:tag
 */
@property (nonatomic, assign) NSInteger tag;

/*!
 @property  PADAPIDataType apiDataType
 @brief     API返回的数据类型
 */
@property (nonatomic, assign) DDGAPIDataType apiDataType;

/*!
 @property  DDGError error
 @brief     错误信息
 */
@property (nonatomic, strong) DDGError *errorDDG;


@property (nonatomic, assign) NSInteger failPassWord;

#if NS_BLOCKS_AVAILABLE
/*!
 @property  DDGvoidBlock completionBlock
 @brief     业务逻辑执行成功之后调用的block
 */
@property (nonatomic, strong) Block_Void completionBlock;

/*!
 @property  DDGvoidBlock failureBlock
 @brief     业务逻辑执行失败之后调用的block
 */
@property (nonatomic, strong) Block_Void failureBlock;

#endif



/**
 *  序列化控制器
 */
@property (nonatomic, strong) AFHTTPRequestSerializer <AFURLRequestSerialization> * requestSerializer;

@property (nonatomic, strong) NSURL *URL;



/*!
 @brief     解析请求返回的data数据，一般用于处理返回的图片数据
 @param     data 请求返回的数据
 */
- (void)parseData:(NSData *)data;

/*!
 @brief    解析JSON数据中的data数据,该方法为abstract类型， 继承类需要重载此方法来实现数据的解析
 */
- (void)parseJsonData:(JsonResult *)jsonResult;

/*!
 @brief     将业务http返回的数据转换为json实体
 @param     request 业务操作的请求
 @return    JsonResult的实例
 */
+ (JsonResult *)jsonResultWithRequest:(DDGAFHTTPRequestOperation *)operation;

/*!
 @brief     将传入的参数，数据转为nsnull。字符串和数字直接转为null， 字典将obj转为null，数组将元素（字典外）转为null。
 该方法用于测试各种数据异常的情况， 可以在单独的接口处调用。基类修改将对所有数据起作用，如下：
 */
- (id)change2NSNull:(id)data;


/**
 *  请求操作
 *
 *  @param url        <#url description#>
 *  @param parameters <#parameters description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 *
 *  @return <#return value description#>
 */
-(DDGAFHTTPRequestOperation *)initWithURL:(NSString *)url parameters:(id)parameters HTTPCookies:(NSArray *)cookies success:(void (^)(DDGAFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(DDGAFHTTPRequestOperation *operation, NSError *error))failure;

@end



@protocol BLDelegate <NSObject>

@optional
/*!
 @brief     业务逻辑执行成功后的回调方法
 @param     blController 处理业务逻辑的控制器对象
 */
- (void)businessLogicDidFinished:(DDGAFHTTPRequestOperation *)operation;

/*!
 @brief     业务逻辑执行成功后的回调方法
 @param     blController 处理业务逻辑的控制器对象
 */
- (void)businessLogicDidFailed:(DDGAFHTTPRequestOperation *)operation;

@end


