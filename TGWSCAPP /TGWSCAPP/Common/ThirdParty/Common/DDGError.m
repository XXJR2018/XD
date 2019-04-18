//
//  DDGError.m
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import "DDGError.h"

NSString *const kPDErrorDomain = @"";

@implementation DDGError

+ (NSString *)errorMessageForErrorType:(DDGErrorType)errorType
{
    switch (errorType)
    {
        case DDGUnknownErrorType:
            break;
        default:
            break;
    }
    return nil;
}

+ (id)errorWithCode:(NSUInteger)errorType errorMessage:(NSString *)errorMessage
{
    NSString *errorMessage_ = errorMessage;
    NSString *button_msg = @"no button msg";
//    if ([errorMessage isKindOfClass:[NSDictionary class]] && [(NSDictionary *)errorMessage objectForKey:@"msg"]) {
//        errorMessage_ = [(NSDictionary *)errorMessage objectForKey:@"msg"];
//    }
//    if ([errorMessage isKindOfClass:[NSDictionary class]] && [(NSDictionary *)errorMessage objectForKey:@"button_msg"]) {
//        button_msg = [(NSDictionary *)errorMessage objectForKey:@"button_msg"];
//    }
    
    return [[self alloc] initWithCode:errorType errorMessage:errorMessage_  buttonMsg:button_msg];
}

- (id)initWithCode:(NSUInteger)errorType errorMessage:(NSString *)errorMessage buttonMsg:(NSString *)button_msg
{
    return [self initWithDomain:kPDErrorDomain
                           code:errorType
                       userInfo:(errorMessage != nil
                                 ? [NSDictionary dictionaryWithObjectsAndKeys:
                                    [errorMessage description], NSLocalizedDescriptionKey,[button_msg description], NSLocalizedRecoverySuggestionErrorKey, nil]
                                 : nil)];
}

+ (id)errorWithError:(NSError *)error
{
    return [[self alloc] initWithCode:error.code errorMessage:[error localizedDescription] buttonMsg:[error localizedRecoverySuggestion]];
}

- (id)initWithError:(NSError *)error
{
    return [self initWithCode:error.code errorMessage:[error localizedDescription] buttonMsg:[error localizedRecoverySuggestion]];
}


@end
