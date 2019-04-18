//
//  BPShare.h
//  BigPlayers
//
//  Created by Cary on 13-7-4.
//  Copyright (c) 2013年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDGQQ.h"
#import "DDGWeChat.h"

extern NSString *const DDGShareType                     ;
extern NSString *const DDGShareTypeWeChat_haoyou        ;
extern NSString *const DDGShareTypeWeChat_pengyouquan   ;
extern NSString *const DDGShareTypeQQ                   ;
extern NSString *const DDGShareTypeQQqzone              ;
extern NSString *const DDGShareTypeCopyUrl              ;

typedef NS_ENUM(NSUInteger, ShareContentType)
{
    ShareContentTypeApp,    //default
    ShareContentTypeNews,
    WeiBoShareTypeOther
};


@protocol DDGShareManagerDelegate <NSObject>

@required

-(void)shareSuccess:(NSMutableDictionary *)result;

-(void)shareFailed:(NSMutableDictionary *)result;

-(void)loginSuccess:(NSMutableDictionary *)result;

-(void)loginFailed:(NSMutableDictionary *)result;


@end

@interface DDGShareManager : NSObject

@property (nonatomic,assign) id delegate;

@property (nonatomic,copy) NSString *lastLoginType;

/**
 *  所在的视图控制器
 */
@property (nonatomic,weak) UIViewController *viewController;

/**
 *  分享的内容
 */
@property (nonatomic,strong) NSDictionary *items;

/**
 *  分享类型s
 */
@property (nonatomic,strong) NSMutableArray *types;

/**
 *  回调
 */
@property (nonatomic,copy) Block_Id block;

/**
 *  新浪通道授权
 */
@property (nonatomic,copy) NSString *accessToken;


+ (DDGShareManager *)shareManager;

//+(void)shareWithItems:(NSDictionary *)items types:(NSArray *)types showIn:(UIViewController *)viewController block:(DDGIdBlock)block;

/**
 *  初始化
 *
 *  @param items 分享的内容
 *  @param types @[DDGShareTypeWeChat_haoyou]
 *
 */
- (void)share:(ShareContentType)contentType items:(NSDictionary *)items types:(NSArray *)types showIn:(UIViewController *)viewController block:(Block_Id)block;

/**
 *  第三方登录 : 先向第三方申请授权提取id，再向后台发起登录请求，后台筛选查到对应id就登录成功，没有对应id就需要做注册操作，注册需要带第三方平台类型和id
 *
 *  @param type  第三方类型 1 － qq ， 2 － wechat
 *  @param block 回调中带有result参数
 *
 */

- (void)loginType:(int)type block:(Block_Id)block view:(UIView *)view;



/**
 *  分享到微信  （分享界面需要自己写）
 *  @param items  分享参数  （可以分享普通URL， 分享图片）
 *  @param scene  0--朋友会话，1-－朋友圈
 *
 */
-(BOOL) weChatShare:(NSDictionary *)items shareScene:(int) scene;



/**
 *  分享小程序到微信  （分享界面需要自己写）
 *  @param items  分享参数（小程序）
 * （只支持分享给朋友）
 *
 */
-(BOOL) weChatShareXCX:(NSDictionary *)items ;

@end
