//
//  BPQQSdk.h
//  BigPlayerSDK
//
//  Created by Cary on 13-7-4.
//  Copyright (c) 2013年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>

@protocol DDGQQDelegate <NSObject>

@optional

-(void) qqShareFinishedWithResult:(NSDictionary *)result; //分享结果

-(void) qqLoginFinishedWithResult:(NSMutableDictionary *)result; //登录结果

@end


@interface DDGQQ : NSObject <DDGQQDelegate,TencentSessionDelegate>
{
    NSMutableArray * _permissions;
    TencentOAuth * _tencentOAuth;
    BOOL HasLoginSuccess;
    BOOL isShare;
}

@property (nonatomic,weak) id <DDGQQDelegate> delegate;

@property (nonatomic,retain) NSArray* _permissions;

@property (nonatomic,retain) TencentOAuth* _tencentOAuth;


//@property (nonatomic,strong) DDGVoidBlock block;

/**
 *  分享返回的结果/错误
 */
@property (nonatomic, strong) NSMutableDictionary *result;

+(DDGQQ *) getSharedQQ;


- (void)loginBlock:(Block_Void)block;
/**
 * 退出登录(退出登录后，TecentOAuth失效，需要重新初始化)
 * \param delegate 第三方应用用于接收请求返回结果的委托对象
 */
- (void)logout;

/**
 * 判断登录态是否有效
 * \return 处理结果，YES表示有效，NO表示无效，请用户重新登录授权
 */
//- (BOOL)isSessionValid;


-(void)getUserInfo;


/************************
 //qq分享
 //title: 分享标题 （最多36个中文，必须）
 //content:分享内容 （最多80个中文，非必须）
 //imageUrl：分享图片的url  （必须）
 //gotoUrl: 点击后跳转网页 （必须）
 ************************/
//- (BOOL)qqShareWithTitle:(NSString *)title Content:(NSString *)content ImageUrl:(NSString *)imageUrl gotoUrl:(NSString *)url;

/************************
 //分享新闻
 //type: 0 － qq ， 1 － qqQzone
 //title: 标题 （最多36个中文，必须）
 //content: 描述 （最多80个中文，非必须）
 //url：跳转URL  （必须）
 //params: 扩展用参数 （非必须）
 ************************/
- (BOOL)qqShareNewsType:(int)type title:(NSString *)title Content:(NSString *)content ImageUrl:(NSData *)imageData gotoUrl:(NSString *)url other:(id)params;


@end
