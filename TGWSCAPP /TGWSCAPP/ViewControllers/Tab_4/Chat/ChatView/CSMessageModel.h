//
//  CSMessageModel.h
//  XMPPChat
//
//  Created by 123 on 2017/12/14.
//  Copyright © 2017年 123. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//原代码地址   https://github.com/huangzhibiao/BGFMDB
#import "BGFMDB.h" //添加该头文件,本类就具有了存储功能.


extern NSString  *bg_chat_tablename;  // 数据库中的表名
extern int MessageFontSize;           // 消息的字体大小

@class CSMessageModel;

/*
 消息类型
 */
typedef NS_OPTIONS(NSUInteger, MessageType) {
    MessageTypeText=1,
    MessageTypeVoice,
    MessageTypeImage,
    MessageTypeQuestion
    
};


/*
 消息发送方
 */
typedef NS_OPTIONS(NSUInteger, MessageSenderType) {
    MessageSenderTypeMe=1,
    MessageSenderTypeOther
    
};



/*
 消息发送状态
 */

typedef NS_OPTIONS(NSUInteger, MessageSentStatus) {
    MessageSentStatusSended=1,//送达
    MessageSentStatusUnSended, //未发送
    MessageSentStatusSending, //正在发送
    
};

/*
 消息接收状态
 */

typedef NS_OPTIONS(NSUInteger, MessageReadStatus) {
    MessageReadStatusRead=1,//消息已读
    MessageReadStatusUnRead //消息未读
    
};


/*
 
 只有当消息送达的时候，才会出现 接收状态，
 消息已读 和未读 仅仅针对自己
 
 
 未送达显示红色，
 发送中显示菊花
 送达状态彼此互斥
 
 
 
 */




@interface CSMessageModel : NSObject


@property (nonatomic, assign) MessageType         messageType;
@property (nonatomic, assign) MessageSenderType   messageSenderType;
@property (nonatomic, assign) MessageSentStatus   messageSentStatus;
@property (nonatomic, assign) MessageReadStatus   messageReadStatus;
/*
 是否显示小时的时间
 */
@property (nonatomic, assign) BOOL   showMessageTime;

/*
消息时间戳
 */
@property (nonatomic, assign) long   lMessageTime;

/*
 消息完整的时间  2017-09-11 11:11:11
 */
@property (nonatomic, retain) NSString   *wholeMessageTime;


/*
 消息显示时间  2017-09-11 11:11:12   或者 12:21:11
 */
@property (nonatomic, retain) NSString    *messageTime;


/*
 发送到Web成功标志
 */

@property (nonatomic, assign) BOOL   sendSuccess;


/*
 图像url
 */
@property (nonatomic, retain) NSString    *logoUrl;

/*
 消息文本内容
 */
@property (nonatomic, retain) NSString    *messageText;


/*
 音频时间
 */

@property (nonatomic, assign) NSInteger   duringTime;
/*
 消息音频url
 */
@property (nonatomic, retain) NSString    *voiceUrl;


/*
 图片文件
 */
@property (nonatomic, retain) NSString    *imageUrl;

/*
 图片文件
 */
@property (nonatomic, retain) UIImage    *imageSmall;


/*
 只显示时间条， 用来显示 （xxx人正在等待加入，请耐心等待。 xxx正在为你服务。）
 */
@property (nonatomic, assign) BOOL   onlyShowTime;




/*
 热门问题标题
 */
@property (nonatomic, retain) NSString    *tiltleQuestion;


/*
 热门问题列表
 */
@property (nonatomic, retain) NSArray    *arrQuestion;




- (CGRect)timeFrame;
- (CGRect)logoFrame;
- (CGRect)messageFrame;
- (CGRect)voiceFrame;
- (CGRect)voiceAnimationFrame;
- (CGRect)bubbleFrame;
- (CGRect)imageFrame;
- (CGRect)questionFrame;
- (CGFloat)cellHeight;


@end
