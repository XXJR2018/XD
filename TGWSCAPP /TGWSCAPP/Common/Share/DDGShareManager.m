//
//  BPShare.m
//  BigPlayers
//
//  Created by Cary on 13-7-4.
//  Copyright (c) 2013年 Cary. All rights reserved.
//

#import "DDGShareManager.h"
#import "ShareView.h"

NSString *const DDGShareType                       = @"DDGShareType";
NSString *const DDGShareTypeWeChat_haoyou          = @"DDGShareTypeWeChat_haoyou" ;
NSString *const DDGShareTypeWeChat_pengyouquan     = @"DDGShareTypeWeChat_pengyouquan" ;
NSString *const DDGShareTypeQQ                     = @"DDGShareTypeQQ" ;
NSString *const DDGShareTypeQQqzone                = @"DDGShareTypeQQqzone" ;
NSString *const DDGShareTypeCopyUrl                = @"DDGShareTypeCopyUrl" ;


@interface DDGShareManager ()<DDGQQDelegate,DDGWeChatDelegate>

@property (nonatomic,strong) DDGQQ *tcQQ;

/**
 *  分享弹出的视图
 */
@property (nonatomic,strong) UIView *shareView;

@end

static DDGShareManager *_DDGShareManager = nil;

@implementation DDGShareManager

@synthesize tcQQ =  _tcQQ;

+ (DDGShareManager *)shareManager
{
    if (_DDGShareManager == nil)
    {
        @synchronized(self)
        {
            if (_DDGShareManager == nil){
                _DDGShareManager = [[DDGShareManager alloc] init];
            }
        }
    }
    return _DDGShareManager;
}

- (void)loginType:(int)type block:(Block_Id)block view:(UIView *)view{
    _block = block;
    if (type == 1) {
        [DDGQQ getSharedQQ].delegate = self;
        [[DDGQQ getSharedQQ] loginBlock:^{
            [MBProgressHUD showErrorWithStatus:@"请先安装QQ" toView:view];
        }];
    }else if (type == 2){
        [DDGWeChat getSharedWeChat].delegate = self;
        [[DDGWeChat getSharedWeChat] loginBlock:^{
            [[[MBProgressHUD alloc] init]  toShowErrorWithStatus:@"请先安装微信APP"];
        }];
    }
}

-(NSString *)lastLoginType{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastLoginType"];
}

-(void)setLastLoginType:(NSString *)lastLoginType{
    [[NSUserDefaults standardUserDefaults] setObject:lastLoginType forKey:@"lastLoginType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)share:(ShareContentType)contentType items:(NSDictionary *)items types:(NSArray *)types showIn:(UIViewController *)viewController block:(Block_Id)block{
    _block = block;
    _items = items;
    
    _types = [NSMutableArray arrayWithArray:types];
    _viewController = viewController;
    
    if ([types containsObject:DDGShareTypeWeChat_haoyou] || [types containsObject:DDGShareTypeWeChat_pengyouquan]) {
        [DDGWeChat getSharedWeChat].delegate = self;
    }
    
    if ([types containsObject:DDGShareTypeQQ] || [types containsObject:DDGShareTypeQQqzone]) {
        if (!_tcQQ) {
            _tcQQ = [DDGQQ getSharedQQ];
            _tcQQ.delegate = self;
        }
    }
    
    // 弹出分享按钮
    [ShareView showIn:viewController types:types block:^(int index){
        if ([types[index] isEqualToString:DDGShareTypeWeChat_pengyouquan]) {
            [self weChatShare:items shareScene:1];
        }else if ([types[index] isEqualToString:DDGShareTypeWeChat_haoyou]){
            [self weChatShare:items shareScene:0];
        }else if ([types[index] isEqualToString:DDGShareTypeQQ]){
            [self qqShare:items type:0];
        }else if ([types[index] isEqualToString:DDGShareTypeQQqzone]){
            [self qqShare:items type:1];
        }else if ([types[index] isEqualToString:DDGShareTypeCopyUrl]){
            [self copyUrl:[items objectForKey:@"url"]];
        }
    }];
    
}

#pragma mark === 持久化授权数据
-(NSString *)accessToken{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];
}

-(void)setAccessToken:(NSString *)accessToken{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:accessToken forKey:@"accessToken"];
    [userDefault synchronize];
}

#pragma mark -
#pragma mark - 微信
#pragma mark -
-(void) weChatLoginFinishedWithResult:(NSMutableDictionary *)result{
    _block(result);
}

-(BOOL) weChatShare:(NSDictionary *)items shareScene:(int) scene{
    [DDGWeChat getSharedWeChat].delegate = self;
    if (![WXApi isWXAppInstalled]) {
        [[[MBProgressHUD alloc] init]  toShowErrorWithStatus:@"请先安装微信APP"];
        return NO;
    }
    return [[DDGWeChat getSharedWeChat] share:items shareScene:scene];
}

-(BOOL) weChatShareXCX:(NSDictionary *)items {
    [DDGWeChat getSharedWeChat].delegate = self;
    if (![WXApi isWXAppInstalled]) {
        [[[MBProgressHUD alloc] init]  toShowErrorWithStatus:@"请先安装微信APP"];
        return NO;
    }
    return [[DDGWeChat getSharedWeChat] shareXCX:items];
}

// 回调
-(void) weChatShareFinishedWithResult:(NSMutableDictionary *)result{
    _block(result);
}


#pragma mark -
#pragma mark - 腾讯QQ
#pragma mark -
-(void)qqLoginFinishedWithResult:(NSMutableDictionary *)result{
    _block(result);
}

- (void)qqShare:(NSDictionary *)items type:(int)type{
    if (![TencentApiInterface isTencentAppInstall:kIphoneQQ]){
        [[[MBProgressHUD alloc] init]  toShowErrorWithStatus:@"请先安装QQ"];
        return;
    }
    [_tcQQ qqShareNewsType:type title:items[@"title"] Content:items[@"subTitle"] ImageUrl:items[@"image"] gotoUrl:items[@"url"] other:nil];
}

// 回调  分享结果
-(void)qqShareFinishedWithResult:(NSMutableDictionary *)result{
    _block(result);
}

#pragma mark -
#pragma mark - 复制链接
#pragma mark -
-(void)copyUrl:(NSString *)url{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = url;
    
    if (url)
        [[[MBProgressHUD alloc] init]  toShowErrorWithStatus:@"复制成功"];
}


@end
