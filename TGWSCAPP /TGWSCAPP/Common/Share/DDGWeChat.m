//
//  BPWeChatSDK.m
//  IWantYou
//
//  Created by Cary on 13-7-4.
//  Copyright (c) 2013年 Cary. All rights reserved.
//

#import "DDGWeChat.h"

@implementation DDGWeChat

static DDGWeChat *weChatShare;

+(DDGWeChat *)getSharedWeChat{
    @synchronized(weChatShare)
    {
        if(weChatShare == nil){
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                weChatShare =[[DDGWeChat alloc] init];
            });
        }
        
        return weChatShare;
    }
}

-(id)init
{
    if(self = [super init]){
        //向微信注册
        [WXApi registerApp:APPID_WC];
    }
    return self;
}

#pragma mark == 登录/登出
- (void)loginBlock:(Block_Void)block{
    _block = block;
    if (![WXApi isWXAppInstalled]){
        if (block) _block();
    }else
        [self sendAuthRequest];
}

-(void)sendAuthRequest{
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"wechat_TGWSC" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

- (void)logout{

}

#pragma mark === 分享
//分享  0--朋友会话，1-－朋友圈
-(BOOL) share:(NSDictionary *)items shareScene:(int)scene{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    WXMediaMessage *message = [WXMediaMessage message];
    
    if (items.count == 1 && [items objectForKey:@"image"]) {
        //分享纯图片
        WXImageObject *imageObject = [WXImageObject object];
        // 发送的原图， 分享后，分享的人可以看到
        imageObject.imageData = [items objectForKey:@"image"];
        message.mediaObject = imageObject;
         UIImage* image = [UIImage imageWithData:[items objectForKey:@"image"]];
        // 发送的压缩图片，在分享前，用户自己可以看到
        image = [UIImage imageWithData:[self imageWithImage:image scaledToSize:CGSizeMake(200,  200 * image.size.height/image.size.width)]];
        [message setThumbImage:image];
    }else{
        //分享webPage
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = [items objectForKey:@"url"];
        message.mediaObject = webObj;
        message.title = [items objectForKey:@"title"];
        message.description = [items objectForKey:@"subTitle"];
        [message setThumbImage:[UIImage imageWithData:[items objectForKey:@"image"]]];
    }

    req.message = message;
    req.scene = scene;
    
    if(![WXApi sendReq:req]){
        [[[MBProgressHUD alloc] init] toShowErrorWithStatus:@"请先安装微信APP"];
        return NO;
    }
    return YES;
}


//分享  0--朋友会话
-(BOOL) shareXCX:(NSDictionary *) items  {
    //商品详情页 /pages/product/product
    //参数 goodsCode  goodsName
    
    NSString *strImgUrl = items[@"strImgUrl"];
    UIImage *image = [ToolsUtlis getImgFromStr:strImgUrl];;//[ResourceManager logo];
    NSData *data=  UIImageJPEGRepresentation(image,0.1);
    
    WXMiniProgramObject *object = [WXMiniProgramObject object];
    object.webpageUrl = @"https://j.youzan.com/RDmlV9";  // 兼容低版本的网页链接
    object.userName = @"gh_b9ba1ea2fafd"; // 小程序ID
    object.path = items[@"strUrl"];  // 小程序的页面路径
    object.hdImageData = data;  // 小程序新版本的预览图二进制数据
    //object.withShareTicket = withShareTicket;  // 是否使用带shareTicket的分享
    object.miniProgramType = WXMiniProgramTypeRelease;  // 小程序的类型  正式版: WXMiniProgramTypeRelease 测试版: WXMiniProgramTypeTest;体验版: WXMiniProgramTypePreview;
    
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = items[@"strName"];//@"天狗窝商城";
    message.description = items[@"strDesc"];
    message.thumbData = data;;  //兼容旧版本节点的图片，小于32KB，新版本优先
                              //使用WXMiniProgramObject的hdImageData属性
    message.mediaObject = object;
    
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;  //目前只支持会话
    
    if(![WXApi sendReq:req]){
        [[[MBProgressHUD alloc] init] toShowErrorWithStatus:@"请先安装微信APP"];
        return NO;
    }
    return YES;
}


- (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, 0.8);
}


#pragma mark == 微信开始支付
-(NSString *)wxPayWith:(WXPayModel *)wxPayModel{
    
    PayReq *request = [[PayReq alloc] init];
    
    if ([wxPayModel.partnerId isKindOfClass:[NSString class]]) {
        request.partnerId = wxPayModel.partnerId;
    }else{
        request.partnerId = [NSString stringWithFormat:@"%d",[wxPayModel.partnerId intValue]];
    }
    
    if ([wxPayModel.prepayid isKindOfClass:[NSString class]]) {
        request.prepayId= wxPayModel.prepayid;
    }else{
        request.prepayId = [NSString stringWithFormat:@"%d",[wxPayModel.prepayid intValue]];
    }
    request.package = @"Sign=WXPay";
    
    if ([wxPayModel.noncestr isKindOfClass:[NSString class]]) {
        request.nonceStr= wxPayModel.noncestr;
    }else{
        request.nonceStr = [NSString stringWithFormat:@"%lld",[wxPayModel.noncestr longLongValue]];
    }
    
    if (wxPayModel.timestamp) {
        request.timeStamp = [wxPayModel.timestamp intValue];
    }
    
    if ([wxPayModel.sign isKindOfClass:[NSString class]]) {
        request.sign= wxPayModel.sign;
    }else{
        request.sign = [NSString stringWithFormat:@"%lld",[wxPayModel.sign longLongValue]];
    }
    
    if ([WXApi sendReq:request]) {
        return @"";
    }else{
        return @"发起支付失败";
    }
}


//收到微信消息
-(void) onReq:(BaseReq*)req{
  
}

//从微信回
-(void) onResp:(BaseResp*)resp{
    if(resp.errCode == 0){
        // 分享
        if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
            if([_delegate respondsToSelector:@selector(weChatShareFinishedWithResult:)]){
                [_delegate weChatShareFinishedWithResult:[NSDictionary dictionaryWithObjectsAndKeys:@"resp.errStr",@"result",@(YES),@"success", nil]];
            }
        }
        // 登录
        else if ([resp isKindOfClass:[SendAuthResp class]]) {
            // 获取access_token
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
             NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",APPID_WC,APPSecret_WC,((SendAuthResp *)resp).code];
            [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *requestTmp = [NSString stringWithString:operation.responseString];
                NSData *resData = [[NSData alloc] initWithData:[requestTmp dataUsingEncoding:NSUTF8StringEncoding]];
                //系统自带JSON解析
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
                if([self.delegate respondsToSelector:@selector(weChatLoginFinishedWithResult:)]) {
                    [self.delegate weChatLoginFinishedWithResult:resultDic];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSDictionary *result = @{@"code":@(-1),
                                         @"resultText":@"微信登录失败"};
                [self.delegate performSelector:@selector(qqLoginFinishedWithResult:) withObject:result];
                NSLog(@"获取access_token时出错 = %@", error);
            }];
        }
        // 支付
        else if ([resp isKindOfClass:[PayResp class]]) {
            //if (self.block) _block();
            if (self.payblock) _payblock(resp);
        }
    }else{
        if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
            if([_delegate respondsToSelector:@selector(weChatShareFinishedWithResult:)])
            {
                [_delegate weChatShareFinishedWithResult:[NSDictionary dictionaryWithObjectsAndKeys:@"resp.errStr",@"result",@(NO),@"success", nil]];
            }
        }else if ([resp isKindOfClass:[SendAuthResp class]]) {
            if([_delegate respondsToSelector:@selector(weChatLoginFinishedWithResult:)])
            {
                [_delegate weChatLoginFinishedWithResult:[NSDictionary dictionaryWithObjectsAndKeys:@"resp.errStr",@"result",@(NO),@"success", nil]];
            }
        } else if ([resp isKindOfClass:[PayResp class]]) {
            //if (self.block) _block();
            if (self.payblock) _payblock(resp);
        }

    }
}


@end


@implementation WXPayModel


@end
