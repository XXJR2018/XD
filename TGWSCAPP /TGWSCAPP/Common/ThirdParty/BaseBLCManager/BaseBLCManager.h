//
//  BaseBLCManager.h
//  DDGUtils
//
//  Created by Cary on 15/1/3.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface BaseBLCManager : AFHTTPRequestOperationManager

/*!
 @brief    异步GET请求
 */
- (void)startAsynchronousHTTPRequestWithAPI:(NSString *)api
                            paramDictionary:(NSDictionary *)paramDictionary;

/*!
 @brief    异步POST请求
 */
- (void)startAsynchronousHTTPPostRequestWithAPI:(NSString *)apiString
                                paramDictionary:(NSDictionary *)paramDictionary;



@end
