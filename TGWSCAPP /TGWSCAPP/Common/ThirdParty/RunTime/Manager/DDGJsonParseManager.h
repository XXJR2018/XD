//
//  PDJsonParseManager.h
//  EVTUtils
//
//  Created by paidui-mini on 14-2-26.
//  Copyright (c) 2014年 Paidui, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONKit.h"

#define kIsSuccess              @"success"
#define kMessage                @"message"

@class DDGAFHTTPRequestOperation;
@class DDGError;

@interface DDGJsonParseManager : NSObject

/*!
 @brief     解析服务器返回的json数据
 @param     request 请求
 @param     status 返回的状态值
 @param     error  网络请求的错误
 @return    json data包含的数据
 */
+ (id)parseJsonObjectWithRequest:(DDGAFHTTPRequestOperation *)operation
                          status:(int *)status
                           error:(DDGError **)error;

/*!
 @brief     解析服务器返回的json数据
 @param     request 请求
 @param     status 返回的状态值
 @return    json data包含的数据
 */
+ (id)parserJsonDataWithRequest:(DDGAFHTTPRequestOperation *)operation status:(int *)status;

/*!
 @brief     解析服务器返回的json数据
 @param     request 请求
 @return    json data包含的数据
 */
+ (NSDictionary *)parseJsonObjectWithRequest:(DDGAFHTTPRequestOperation *)operation;

/*!
 @brief     解析本地的json数据
 @param     data 本地json数据
 @return    json data包含的数据
 */
+ (id)parseJsonObjectWithData:(NSData *)data;


@end
