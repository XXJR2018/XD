//
//  WebSocketManager.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/2/21.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebSocketManager : NSObject

- (id)init;

- (void) stopConnectTimer; // 停止心跳包定时器


//初始化Socket并发起连接
- (void)socketConnectHost;

// 发送断开命令到后台
-(BOOL)sendClose;


// 发送文本和简单表情
- (BOOL)sendText:(NSString *) strSend;


// 发送组装好的命令
- (BOOL)sendDic:(NSDictionary *) dicSend;



@end

NS_ASSUME_NONNULL_END
