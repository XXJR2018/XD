//
//  DDGAFRequestManager.m
//  DDGUtils
//
//  Created by Cary on 15/1/5.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import "DDGAFRequestManager.h"

@implementation DDGAFRequestManager

-(void)cancelRequest{
    [self.operationQueue cancelAllOperations];
}


/**
 *  GET请求 (重写)
 *
 *  @param URLString  <#URLString description#>
 *  @param parameters <#parameters description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 *
 *  @return <#return value description#>
 */
- (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(id)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    request.timeoutInterval = self.timeoutInterval ? self.timeoutInterval : 20.f;
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
    
    [self.operationQueue addOperation:operation];
    
    return operation;
}

/**
 *  POST请求 (重写)
 *
 *  @param URLString  <#URLString description#>
 *  @param parameters <#parameters description#>
 *  @param success    <#success description#>
 *  @param failure    <#failure description#>
 *
 *  @return <#return value description#>
 */
//- (AFHTTPRequestOperation *)POST:(NSString *)URLString
//                      parameters:(id)parameters
//                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
//{
//    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
//    request.timeoutInterval = self.timeoutInterval ? self.timeoutInterval : 10.f;
//    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:success failure:failure];
//    
//    [self.operationQueue addOperation:operation];
//    
//    return operation;
//}


@end
