//
//  DDGAccountManager.m
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import "DDGAccountManager.h"
#import "DDGSetting.h"

#define AccountFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.data"]


/**
 *	保存在UserDefaults中的Session key
 */
static NSString *const kSessionCookiesKey = @"kSessionCookiesKey";
static DDGAccountManager *_sharedManager = nil;

@implementation DDGAccountManager
@synthesize userLogo = _userLogo , sessionCookiesArray = _sessionCookiesArray;

+ (DDGAccountManager *)sharedManager
{
    if (_sharedManager == nil)
    {
        @synchronized(self)
        {
            if (_sharedManager == nil)
                _sharedManager = [[DDGAccountManager alloc] init];
        }
    }
    return _sharedManager;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.user.uid = [DDGSetting sharedSettings].uid;
        if (self.user.uid)
        {
            [self loadUserData];
        }
    }
    return self;
}


- (void)setUserInfoWithDictionary:(NSDictionary *)dictionary;
{
//    if (![[dictionary objectForKey:kUser_ID] isKindOfClass:[NSString class]]) {
//        self.user.uid = [NSString stringWithFormat:@"%d",[[dictionary objectForKey:kUser_ID] intValue]];
//    }else if([dictionary objectForKey:kUser_ID] != nil){
//        self.user.uid = [dictionary objectForKey:kUser_ID];
//    }
    
    if (dictionary[kRealName]) {
        self.user.realName = dictionary[kRealName];
    }
    if (dictionary[kPassword]) {
        self.user.passWord = dictionary[kPassword];
    }
    if (dictionary[kMobile]) {
        self.user.mobile = dictionary[kMobile];
    }
}

//保存数据
- (void)saveUserData
{
//    [DDGSetting sharedSettings].uid = self.user.uid;
    //账号，密码
    [DDGSetting sharedSettings].mobile = self.user.mobile;
    [DDGSetting sharedSettings].passWord = self.user.passWord;
    
    [DDGSetting sharedSettings].realName = self.user.realName;
    if (self.user.mobile)
    {
        [NSKeyedArchiver archiveRootObject:self.user toFile:AccountFile];
    }    
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:DDG_url([PDAPI getBaseUrlString])];
    self.sessionCookiesArray = [NSMutableArray arrayWithArray:cookies];
}

- (void)deleteUserData{
    //删除数据
    [NSKeyedArchiver archiveRootObject:nil toFile:AccountFile];
    [self deleteMemoryData];
    
    [CommonInfo setUserInfo:nil];

}

- (void)deleteMemoryData{
    self.user = nil;
    self.sessionCookiesArray = nil;
//    [DDGSetting sharedSettings].uid = nil;
    [DDGSetting sharedSettings].realName = nil;
    [DDGSetting sharedSettings].mobile = nil;
    [DDGSetting sharedSettings].passWord = nil;
    [DDGSetting sharedSettings].name = nil;
    [DDGSetting sharedSettings].accountNeedRefresh = YES;
    [DDGAccountManager sharedManager].userInfo = nil;
}

- (void)loadUserData
{
//    DBUserController *controller = [DBUserController dbController];
//    self.user = [controller getUserByUserId:[self.user.user_id integerValue]];
}

- (BOOL)isLoggedIn{
    return [CommonInfo isLoggedIn];
}

-(BOOL)isInfoFinished{
    if ([self.user.mobile isKindOfClass:[NSNull class]] || self.user.mobile == nil || self.user.mobile.length < 11) {
        return NO;
    }else if ([self.user.realName isKindOfClass:[NSNull class]] || self.user.realName == nil){
        for (NSString *key in [DDGSetting sharedSettings].userInfo.allKeys) {
            NSString *value = [NSString stringWithFormat:@"%@",[[DDGSetting sharedSettings].userInfo objectForKey:key]];
            if (!value || [value isEqualToString:@"null"]) {
                return NO;
            }
        }
    }
    
    return YES;
}

/*!
 @brief     获取登录用户信息并保存在缓存
 */
+ (void)getUserInfo:(Block_Void)block{
    if ([[DDGAccountManager sharedManager] isLoggedIn] && _sharedManager.userInfo == nil) {
        DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI getUserBaseInfoAPI]
                                            parameters:nil
                                            HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                            success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithDictionary:operation.jsonResult.rows[0]];
                                                for (NSString *key in dataDic.allKeys) {   //避免NULL字段
                                                    if ([[dataDic objectForKey:key] isEqual:[NSNull null]]) {
                                                        [dataDic setValue:@"" forKey:key];
                                                    }
                                                }
                                                _sharedManager.userInfo = dataDic;
                                                
                                                if (block) {
                                                    block();
                                                }
                                            }
                                            failure:nil];
        [operation start];
    }
}


#pragma mark -
#pragma mark ==== User ====
#pragma mark -
- (DDGUser *)user
{
    if (!_user){
        _user = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountFile];
        
        if (!_user) {
            _user = [[DDGUser alloc] init];
        }
    }
    return _user;
}




#pragma mark -
#pragma mark ==== Session ====
#pragma mark -
- (NSMutableArray *)sessionCookiesArray
{
    if(!_sessionCookiesArray){
        id sessionCookie = [[NSUserDefaults standardUserDefaults] objectForKey:kSessionCookiesKey];
        _sessionCookiesArray = [NSMutableArray arrayWithArray:[NSKeyedUnarchiver unarchiveObjectWithData:sessionCookie]];
    }
    return _sessionCookiesArray;
}


- (void)setSessionCookiesArray:(NSMutableArray *)cookies
{
    if (cookies != nil && cookies.count > 0){
        [[NSUserDefaults standardUserDefaults]
         setObject:[NSKeyedArchiver archivedDataWithRootObject:cookies] forKey:kSessionCookiesKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    [[NSUserDefaults standardUserDefaults]
     setObject:nil forKey:kSessionCookiesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isSessionVaild
{
    return (self.sessionCookiesArray && [self.sessionCookiesArray count] > 0 && [self.sessionCookiesArray safeGetObjectAtIndex:0]);
}




@end


