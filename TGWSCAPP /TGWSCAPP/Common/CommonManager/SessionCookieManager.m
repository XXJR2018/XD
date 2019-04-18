//
//  SessionCookieManager.m
//  XXJR
//
//  Created by xxjr02 on 16/1/13.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "SessionCookieManager.h"

@implementation SessionCookieManager

+ (NSMutableArray *)sessionCookies:(NSMutableArray *)session
{
    NSMutableArray *cookiesArray = [NSMutableArray array];
    for (NSHTTPCookie *httpCookie in session)
    {
        [cookiesArray addObject:[SessionCookieManager httpCookie:httpCookie]];
    }
    
    return cookiesArray;
}

+ (NSHTTPCookie *)httpCookie:(NSHTTPCookie *)oldCookie;
{
    if (!oldCookie) return nil;
    
    NSDictionary *propertiesDictionary = [NSDictionary safeDictionaryWithObjectsAndKeys:
                                          oldCookie.domain,NSHTTPCookieDomain,
                                          [NSString stringWithFormat:@"%lu",(unsigned long)oldCookie.version], NSHTTPCookieVersion,
                                          oldCookie.path, NSHTTPCookiePath,  // IMPORTANT!
                                          oldCookie.name, NSHTTPCookieName,
                                          oldCookie.value, NSHTTPCookieValue,
                                          [NSNull null],  NSHTTPCookieExpires,
                                          [NSString stringWithFormat:@"%d",oldCookie.isSecure], NSHTTPCookieSecure,
                                          oldCookie.portList , NSHTTPCookiePort,
                                          oldCookie.comment,NSHTTPCookieComment,
                                          oldCookie.commentURL, NSHTTPCookieCommentURL,
                                          
                                          
                                          nil];
    NSHTTPCookie *aHTTPCookie = [NSHTTPCookie cookieWithProperties:propertiesDictionary];
    
    return aHTTPCookie;
}

+ (void)clearCookies
{
    [DDGAccountManager sharedManager].sessionCookiesArray = nil;
//    [PDHTTPRequest clearSession];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setCookiesForRequest:(NSMutableURLRequest *)request
{
    NSMutableArray *sessionArray = [DDGAccountManager sharedManager].sessionCookiesArray;
    if (sessionArray == nil) return;
    NSMutableArray *cookiesArray = [SessionCookieManager sessionCookies:sessionArray];
    
    if (cookiesArray && cookiesArray.count > 0)
    {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:DDG_url([PDAPI getBaseUrlString])];
        NSDictionary *sheaders = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
        request.allHTTPHeaderFields = sheaders;

//        [request setRequestCookies:cookiesArray];
    }
}


@end
