//
//  PDJsonParseManager.m
//  EVTUtils
//
//  Created by paidui-mini on 14-2-26.
//  Copyright (c) 2014年 Paidui, Inc. All rights reserved.
//

#import "DDGJsonParseManager.h"
#import "DDGAFHTTPRequestOperation.h"
#import "DDGError.h"
#import "JSonKit.h"


@implementation DDGJsonParseManager

+ (id)parseJsonObjectWithRequest:(DDGAFHTTPRequestOperation *)operation status:(int *)status error:(DDGError **)error
{
    if (operation == nil) return nil;
    NSString *jsonString = [operation responseString];
    
    if (jsonString == nil || [[jsonString trim] length] == 0)
        return nil;
    
    if (status != NULL)
        *status = 0;
    
    NSError *jsonError = [operation error];
    NSData *jsonData = [operation.responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *parseObjectDictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                          options:NSJSONReadingAllowFragments
                                                                            error:&jsonError];
    NSLog(@"url is %@",operation.request.URL);
//    NSLog(@"parseObjectDictionary is %@",parseObjectDictionary);
    if (jsonError != nil) return nil;
    
    if (![(NSDictionary *)parseObjectDictionary containsKey:kIsSuccess])
        return nil;
    
    if (status != NULL &&
        [[parseObjectDictionary objectForKey:kIsSuccess] isKindOfClass:[NSNumber class]])
        *status = [[parseObjectDictionary objectForKey:kIsSuccess] intValue];
    
    if (status != NULL && *status != 1)
    {
        if (error != NULL)
            *error = [DDGError errorWithCode:DDGReturnDataError
                                errorMessage:[[parseObjectDictionary objectForKey:kMessage] description]];
    }
    
    if ([parseObjectDictionary isKindOfClass:[NSDictionary class]])
    {
		return parseObjectDictionary;
    }
	
	return nil;
}

+ (id)parserJsonDataWithRequest:(DDGAFHTTPRequestOperation *)request status:(int *)status
{
    return [self parseJsonObjectWithRequest:request status:status error:NULL];
}

+ (NSDictionary *)parseJsonObjectWithRequest:(DDGAFHTTPRequestOperation *)request
{
	return [self parseJsonObjectWithRequest:request status:NULL error:NULL];
}

+ (id)parseJsonObjectWithData:(NSData *)data
{
    if (data == nil)  return nil;
    
    NSError *error = nil;
    id parseObject = [NSJSONSerialization JSONObjectWithData:data
                                                     options:NSJSONReadingAllowFragments error:&error];
    if (error != nil)
    {
        return nil;
    }
    
    if ([parseObject isKindOfClass:[NSArray class]]
        || [parseObject isKindOfClass:[NSDictionary class]])
    {
        return parseObject;
    }
    return nil;
}

@end
