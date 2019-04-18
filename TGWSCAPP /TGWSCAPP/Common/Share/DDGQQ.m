//
//  BPQQSdk.m
//  BigPlayerSDK
//
//  Created by Cary on 13-7-4.
//  Copyright (c) 2013年 Cary. All rights reserved.
//

#import "DDGQQ.h"

@implementation DDGQQ

@synthesize _tencentOAuth;
@synthesize _permissions;
@synthesize delegate = _delegate;

static DDGQQ *qqShare;

+(DDGQQ *) getSharedQQ
{
    @synchronized(qqShare)
    {
        if(qqShare == nil)
        {
            qqShare =[[DDGQQ alloc] init];
        }
        
        return qqShare;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self qqSdkInit];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareResult:) name:@"QQShareResultNotification" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"QQShareResultNotification" object:nil];
}

// // 获取授权
-(void) qqSdkInit
{
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:APPID_QQ andDelegate:self];
    self._permissions = [NSArray arrayWithObjects:
                         kOPEN_PERMISSION_GET_USER_INFO,        // 获取用户信息
                         kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, // 移动端获取用户信息
                         kOPEN_PERMISSION_ADD_TOPIC,            // 发表一条说说到QQ空间 (需要申请权限)
                         kOPEN_PERMISSION_ADD_ONE_BLOG,         // 发表一篇日志到QQ空间 (需要申请权限)
                         kOPEN_PERMISSION_ADD_SHARE,            // 同步分享到QQ空间、腾讯微博
                         nil];

}

#pragma mark == 登录/登出
- (void)loginBlock:(Block_Void)block{
    if (![TencentApiInterface isTencentAppInstall:kIphoneQQ]){
        if (block) block();
    }else{
        isShare = NO;
        [_tencentOAuth authorize:self._permissions inSafari:NO];
    }
}

- (void)logout{
    [_tencentOAuth logout:self];
}

#pragma === 授权登录/登出回调
/**
 * 登录成功后的回调  1
 */
- (void)tencentDidLogin{
    HasLoginSuccess = YES;

    NSString *resultText;
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length]){
        //  记录登录用户的OpenID、Token以及过期时间
        resultText =_tencentOAuth.accessToken;
    }else{
        resultText =@"登录不成功没有获取accesstoken";
    }
    
    if (!isShare) {
        if (_delegate && [_delegate respondsToSelector:@selector(qqLoginFinishedWithResult:)]) {
            NSDictionary *result = @{@"code":@(1),
                                     @"accessToken":_tencentOAuth.accessToken,
                                     @"openId":_tencentOAuth.openId,
                                     @"resultText":resultText};
            [_delegate performSelector:@selector(qqLoginFinishedWithResult:) withObject:result];
        }
    }
}

/**
 * 登录失败后的回调  -1
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
    NSString *resultText;
    if (cancelled)
    {
        resultText =@"用户取消登录";
    }else{
        resultText =@"登录失败";
    }
    if (_delegate && [_delegate respondsToSelector:@selector(qqLoginFinishedWithResult:)]) {
        NSDictionary *result = @{@"code":@(-1),
                                 @"resultText":resultText};
        [_delegate performSelector:@selector(qqLoginFinishedWithResult:) withObject:result];
    }
}

/**
 * 登录时网络有问题的回调  0
 */
- (void)tencentDidNotNetWork{
    if (_delegate && [_delegate respondsToSelector:@selector(qqLoginFinishedWithResult:)]) {
        NSDictionary *result = @{@"code":@(0),
                                 @"resultText":@"无网络连接，请设置网络"};
        [_delegate performSelector:@selector(qqLoginFinishedWithResult:) withObject:result];
    }
}

/**
 * 退出登录的回调
 */
-(void)tencentDidLogout{
    
}

#pragma mark === 获取用户信息
-(void)getUserInfo{
    [_tencentOAuth getUserInfo];
}

-(void)getUserInfoResponse:(APIResponse *)response{
    NSLog(@"respons:%@",response.jsonResponse);
}

#pragma === 分享
- (BOOL)qqShareNewsType:(int)type title:(NSString *)title Content:(NSString *)content ImageUrl:(NSData *)imageData gotoUrl:(NSString *)url other:(id)params{
    isShare = YES;

     NSData *imgData = UIImageJPEGRepresentation([UIImage imageWithData:imageData],1);
    SendMessageToQQReq *req;

    if (title.length == 0 && url.length == 0 && imageData.bytes > 0) {
        //仅分享单张图片
        QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData
                                                   previewImageData:imgData
                                                              title:nil
                                                        description:nil];
        
        req = [SendMessageToQQReq reqWithContent:imgObj];
        
    }else{
        //将内容分享到qq/qzone
        QQApiNewsObject *messge = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url]
                                                           title:title
                                                     description:content
                                                previewImageData:imgData];
        req = [SendMessageToQQReq reqWithContent:messge];
    }
    
    QQApiSendResultCode sent;
    if (type) {
        // 将内容分享到qzone
        sent = [QQApiInterface SendReqToQZone:req];
    }else{
        // 将内容分享到qq
        sent = [QQApiInterface sendReq:req];
    }
    
    if (sent == 0) {
        return YES;
    }else{
        NSLog(@"failed code == %d",sent);
        return NO;
    }
}

#pragma mark ----delegate-------------
/**
 *  分享结果 Called when the add_share has response.
 */
- (void)addShareResponse:(APIResponse*) response {
	if (response.retCode == URLREQUEST_SUCCEED)
	{
        NSLog(@"response is %@",[response.jsonResponse objectForKey:@"msg"]);
         if([_delegate respondsToSelector:@selector(qqShareFinishedWithResult:)])
        {
            [_delegate qqShareFinishedWithResult:[NSDictionary dictionaryWithObjectsAndKeys:@"resp.errStr",@"result",@(YES),@"success", nil]];
        }
	}
	else {
        if([_delegate respondsToSelector:@selector(qqShareFinishedWithResult:)])
        {
            [_delegate qqShareFinishedWithResult:[NSDictionary dictionaryWithObjectsAndKeys:@"resp.errStr",@"result",@(NO),@"success", nil]];
        }
	}
}

+ (void)onResp:(QQBaseResp *)resp
{
    NSLog(@"%@",resp.result);
}

// handleOpenURL:url=QQ0003640E://response_from_qq?source_scheme=mqqapi&source=qq&error=0&version=1
-(void)shareResult:(NSNotification *)notification{
    NSDictionary *infoDic = [self dictionaryFromQuery:[(NSURL *)notification.object absoluteString] usingEncoding:NSUTF8StringEncoding];
    BOOL success = YES;
    if ([[infoDic objectForKey:@"error"] intValue] != 0) success = NO;
    
    if([_delegate respondsToSelector:@selector(qqShareFinishedWithResult:)])
    {
        [_delegate qqShareFinishedWithResult:[NSDictionary dictionaryWithObjectsAndKeys:@"resp.errStr",@"result",@(success),@"success", nil]];
    }
}

- (NSDictionary*)dictionaryFromQuery:(NSString*)query usingEncoding:(NSStringEncoding)encoding {
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:query];
    while (![scanner isAtEnd]) {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2) {
            NSString* key = [[kvPair objectAtIndex:0]
                             stringByReplacingPercentEscapesUsingEncoding:encoding];
            NSString* value = [[kvPair objectAtIndex:1]
                               stringByReplacingPercentEscapesUsingEncoding:encoding];
            [pairs setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}


@end
