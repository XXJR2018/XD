//
//  NSURL+Additions.m
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import "NSURL+Additions.h"

@implementation NSURL (Additions)

+ (id)URLWithString:(NSString *)urlString paramDictionary:(NSDictionary *)paramDict
{
    return [[[self class] alloc] initWithString:urlString paramDictionary:paramDict];
}

- (id)initWithString:(NSString *)urlString paramDictionary:(NSDictionary *)paramDict
{
    if (urlString == nil) return nil;
    if (paramDict == nil || [paramDict count] == 0) return [self initWithString:urlString];
    ///TODO:加入对URL中#号部分的判断
    NSMutableString *result = [NSMutableString stringWithString:urlString];
    NSString *endString = @"";
    
    //判断是否包含“#”
    if ([result containsString:@"#"])
    {
        NSArray *resultArray = [result componentsSeparatedByString:@"#"];
        
        result = [resultArray safeGetObjectAtIndex:0];
        endString = [NSString stringWithFormat:@"#%@", [resultArray safeGetObjectAtIndex:1]];
    }
    
    [result appendString:[result containsString:@"?"] ? @"&" : @"?"];
    
    NSMutableArray *paramsArray = [[NSMutableArray alloc] initWithCapacity:[paramDict count]];
    NSEnumerator *enumerator = [paramDict keyEnumerator];
    id key;
    while ((key = [enumerator nextObject]))
    {
        [paramsArray addObject:[NSString stringWithFormat:@"%@=%@",
                                [key description],
                                [[[paramDict objectForKey:key] description] stringByUrlEncoding]]];
    }
    [result appendString:[paramsArray componentsJoinedByString:@"&"]];
    [result appendString:endString];
    
    NSLog(@"url string = %@", result);
    return [self initWithString:result];
}

+ (id)URLWithFormat:(NSString *)format, ...
{
    va_list arguments;
    va_start(arguments, format);
    NSString *string = [[NSString alloc] initWithFormat:format arguments:arguments];
    va_end(arguments);
    
    return [NSURL URLWithString:string];
}


@end
