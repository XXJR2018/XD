//
//  BPWeChatSDK.h
//  IWantYou
//
//  Created by Cary on 13-7-4.
//  Copyright (c) 2013年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXApiObject.h"

@class WXPayModel;

@protocol DDGWeChatDelegate <NSObject>
@optional

-(void) weChatShareFinishedWithResult:(NSDictionary *)result; //分享结果

-(void) weChatLoginFinishedWithResult:(NSDictionary *)result; //登录结果

@end

@interface DDGWeChat : NSObject <WXApiDelegate>

@property (nonatomic,assign) id <DDGWeChatDelegate> delegate;

/**
 *  分享返回的结果/错误
 */
@property (nonatomic, strong) NSMutableDictionary *result;

@property (nonatomic,strong) Block_Void block;

// 支付的回调
@property (nonatomic,strong) Block_Id payblock;


+(DDGWeChat *)getSharedWeChat;


- (void)loginBlock:(Block_Void)block;
- (void)logout;


//分享  URL  以及 图片
-(BOOL) share:(NSDictionary *)items shareScene:(int)scene; //0--朋友会话，1-－朋友圈


//分享小程序 （只能分享给朋友）
-(BOOL) shareXCX:(NSDictionary *) strUrl ;


-(NSString *)wxPayWith:(WXPayModel *)wxPayModel;


@end




@interface WXPayModel : BaseModel


/*!
 @property  NSString retcode
 @brief     retcode
 */
@property (nonatomic, copy) NSString *retcode;
/*!
 @property  NSString appid
 @brief     appid
 */
@property (nonatomic, copy) NSString *retmsg;
/*!
 @property  NSString appid
 @brief     appid
 */
@property (nonatomic, copy) NSString *appid;
/*!
 @brief     noncestr
 */
@property (nonatomic, copy) NSString *noncestr;

/*!
 @brief     wx_package
 */
@property (nonatomic, copy) NSString *wx_package;

/*!
 @brief     wx_package
 */
@property (nonatomic, copy) NSString *prepayid;

/*!
 @brief     timestamp
 */
@property (nonatomic, copy) NSString *timestamp;

/*!
 @brief     sign
 */
@property (nonatomic, copy) NSString *sign;

/*!
 @brief     partner
 */
@property (nonatomic, copy) NSString *partnerId;

/*!
 @brief     partner_key
 */
@property (nonatomic, copy) NSString *partner_key;






@end
