//
//  DDGSetting.m
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import "DDGSetting.h"

static DDGSetting *_DDGSettings = nil;

@implementation DDGSetting

@synthesize userInfo = _userInfo;
@synthesize UUID_MD5 = _UUID_MD5;

- (id)init
{
    self = [super init];
    if (self)
    {
        _accountNeedRefresh = YES;
        _userInfo = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (DDGSetting *)sharedSettings
{
    if (_DDGSettings == nil)
    {
        @synchronized(self)
        {
            if (_DDGSettings == nil){
                _DDGSettings = [[DDGSetting alloc] init];
            }
        }
    }
    return _DDGSettings;
}



#pragma mark -
#pragma mark ===== Costom setter & getter
#pragma mark -
/*!
 @property  NSString currentAreaId
 @brief     当前用户
 */
- (NSString *)uid
{
    NSString *userId = [[NSUserDefaults standardUserDefaults]
                        objectForKey:kCurrentUserIDKey];
    
    return userId ? userId : @"0";
}

- (void)setUid:(NSString *)uid{
    [[NSUserDefaults standardUserDefaults] setObject:uid
                                              forKey:kCurrentUserIDKey];
}


-(NSMutableDictionary *)userInfo{
    return _userInfo;
}

-(void)setUserInfo:(NSMutableDictionary *)userInfo{
    for (NSString *key in [userInfo allKeys]) {
        [_userInfo setObject:[userInfo objectForKey:key] forKey:key];
    }
}

- (NSString *)realName
{
    NSString *realName = [[NSUserDefaults standardUserDefaults]
                        objectForKey:kCurrentRealNameKey];
    return realName;
}

-(void)setRealName:(NSString *)realName
{
    [[NSUserDefaults standardUserDefaults] setObject:realName
                                              forKey:kCurrentRealNameKey];
}

//读取账号
- (NSString *)mobile
{
    NSString *mobile = [[NSUserDefaults standardUserDefaults]
                          objectForKey:kCurrentUserMobile];
    return mobile;
}

//读取密码
- (NSString *)passWord
{
    NSString *passWord = [[NSUserDefaults standardUserDefaults]
                        objectForKey:kCurrentUserPassWord];
    
    return passWord;
}

-(void)setMobile:(NSString *)mobile
{
    [[NSUserDefaults standardUserDefaults] setObject:mobile
                                              forKey:kCurrentUserMobile];
}

-(NSString *)name{
    NSString *name = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    return name; // ? name : @"陈登文";
}

- (void)setName:(NSString *)name
{
    [[NSUserDefaults standardUserDefaults] setObject:name
                                              forKey:@"name"];
}

-(void)setUUID_MD5:(NSString *)UUID_MD5{
    _UUID_MD5 = UUID_MD5;
}

-(NSString *)UUID_MD5{
    if (!_UUID_MD5) {
//        //加密后的
//        _UUID_MD5 = [[[[UIDevice currentDevice].identifierForVendor UUIDString] dataUsingEncoding:NSUTF8StringEncoding] base64EncodedString];
        //没加密的
        _UUID_MD5 = [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    return _UUID_MD5;
}


/*
 * 最后更新定位时间
 */
- (void)setLastLocationDate:(NSDate *)lastLocationDate
{
    [[NSUserDefaults standardUserDefaults] setObject:lastLocationDate forKey:kLastLocationDate];
}

- (NSDate *)lastLocationDate
{
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:kLastLocationDate];
    if (date == nil)
    {
        date = [NSDate dateWithTimeIntervalSince1970:0];
        [[NSUserDefaults standardUserDefaults] setObject:date forKey:kLastLocationDate];
    }
    
    return date;
}

/*!
 @property  NSString currentAreaId
 @brief     当前所在的区域Id
 */
- (NSString *)currentAreaId
{
    NSString *_currentAreaId = [[NSUserDefaults standardUserDefaults]
                                objectForKey:kCurrentAreaIDKey];
    return _currentAreaId;
}

- (void)setCurrentAreaId:(NSString *)currentAreaId
{
    if (![self.currentAreaId isEqualToString:currentAreaId])
    {
        [[NSUserDefaults standardUserDefaults] setObject:currentAreaId
                                                  forKey:kCurrentAreaIDKey];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LocationCityDidChangeNotification object:nil];
        self.currentCityName = nil;
    }
}

- (double)longitude
{
    id longitudeObj = [[NSUserDefaults standardUserDefaults] objectForKey:kLongitude];
    if (!longitudeObj)
        return NSUIntegerMax;
    return [(NSNumber *)longitudeObj doubleValue];
}

- (void)setLongitude:(double)longitude
{
    [[NSUserDefaults standardUserDefaults] setDouble:longitude forKey:kLongitude];
}

- (double)latitude
{
    id latitudeObj = [[NSUserDefaults standardUserDefaults] objectForKey:kLatitude];
    if (!latitudeObj)
        return NSUIntegerMax;
    return [(NSNumber *)latitudeObj doubleValue];
}

- (void)setLatitude:(double)latitude
{
    [[NSUserDefaults standardUserDefaults] setDouble:latitude forKey:kLatitude];
}


@end
