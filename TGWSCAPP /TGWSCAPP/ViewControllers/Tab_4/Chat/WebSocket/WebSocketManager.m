//
//  WebSocketManager.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/2/21.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "WebSocketManager.h"
#import "SocketRocket/SRWebSocket.h"



@interface WebSocketManager ()<SRWebSocketDelegate>
{
    
    BOOL socketHost;  //是否获取了服务器端口
    BOOL longSocket;  //是否连接正常
    NSString *Host;
    NSInteger Port;
    NSInteger errCount;      //重连次数计数器
    
    BOOL  activeDisconnection;  // 是否主动断开
}

// websocket
@property(nonatomic,strong)SRWebSocket *webSocket;

// 长连接计时器
@property(nonatomic,strong)NSTimer *connectTimer;

@end

@implementation WebSocketManager


- (id)init {
    if (self=[super init]) {
        // Initialize self.
        //        Host = @"127.0.0.1";
        //        Port = 1234;
        errCount = 0;
        Host = @"192.168.10.131";
        Port = 6406;
        
        activeDisconnection = FALSE;
        //  http://192.168.10.208/mallKefu/custSocket/
    }
    return self;
}




//初始化Socket并发起连接
- (void)socketConnectHost{
    if (_webSocket)
     {
        _webSocket=nil;
     }
    
    NSString *strSerURL = [NSString stringWithFormat:@"%@mallKefu/custSocket/%@",[PDAPI getBaseUrlString],[CommonInfo signId]];
    //strSerURL = @"http://192.168.10.131/mallKefu/custSocket";
    //strSerURL = @"http://192.168.10.208/mallKefu/custSocket";
    
    _webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:strSerURL]];
    _webSocket.delegate = self;
    
    [_webSocket open];
    
    
    
}

-(void) creatConnectTimer
{
    [self stopConnectTimer];
    
    // 每隔20秒向服务器发送心跳包  一般设置30秒发送一次心跳包
    _connectTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
    
    [_connectTimer fire];
    
    // 解决定时器后台 无法运行的BUG
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    
    [[NSRunLoop currentRunLoop] addTimer:_connectTimer forMode:NSRunLoopCommonModes];
}

-(void) stopConnectTimer
{
    if (_connectTimer)
     {
        //取消定时器
        [_connectTimer invalidate];
        _connectTimer = nil;
     }
}

//--------------------------------------
#pragma mark - SRWebSocketDelegate
///--------------------------------------

- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
    
    //连接成功
    longSocket = YES;
    
    // 是否有评价过
    [self performSelector:@selector(sendHasPJ) withObject:nil afterDelay:0.5];// 延迟执行
    
    // 创建心跳包
    [self performSelector:@selector(creatConnectTimer) withObject:nil afterDelay:3.0];// 延迟执行
    
 
}

// 发生错误
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@"Websocket Failed With Error %@", error);
    
    // 发生错误，重连
    [self reConnect];
}

// 连接失败/连接断开
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed  reason:%@",reason);
    
    if (activeDisconnection)
     {
        // 主动断开，不要重连
        return;
     }
    
    [self reConnect];

}


-(void) reConnect
{
    errCount ++;
    //连接失败
    longSocket = NO;
    //取消定时器
    [_connectTimer invalidate];
    _connectTimer = nil;
    
    if (errCount <= 5) {
        [_webSocket close];
        // 延迟执行 ，重连接
        [self performSelector:@selector(socketConnectHost) withObject:nil afterDelay:1.0];// 延迟执行
    }else if(errCount == 6){
        //重新获取服务器端口
        //[self socketURL];
    }
}

// 收到数据
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessageWithString:(nonnull NSString *)string
{
    NSLog(@"Received \"%@\"", string);
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGReciveChatMsgNotification object:@{@"msg":string}];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload;
{
    NSLog(@"WebSocket received pong");
}

#pragma mark ---  发送函数
/*
 命令定义
 
 用户授权：reqType=1, msgData:{ signId：”app123”}
 心跳：reqType=2,
 用户发信息给客服：reqType=3, body:{content=”发送的内容”，type=”text”}
 客服发信息给客户：reqType=4, body:{content=”发送的内容”，type=”text”
 */

-(void)sendLoginInfo
{
    // 根据服务器要求发送固定格式的数据
    NSMutableDictionary *dicMsgData = [[NSMutableDictionary alloc] init];
    dicMsgData[@"signId"] = [CommonInfo signId];
    
    
    NSMutableDictionary *dicSend = [[NSMutableDictionary alloc] init];
    dicSend[@"reqType"] = @"1";
    dicSend[@"body"] = dicMsgData;
    
    NSString  *nstrDic = [dicSend JSONString];
    
    NSLog(@"我发送身份认证信息：%@", nstrDic);
    
    NSError *error = nil;
    BOOL  sendSuccess =  [_webSocket sendString:nstrDic error:&error];
    if (!sendSuccess)
     {
        // 发送失败，重新连接服务器
        [self socketConnectHost];
     }
}

// 获取是否评价过
-(void)sendHasPJ
{
    // 根据服务器要求发送固定格式的数据
    NSMutableDictionary *dicSend = [[NSMutableDictionary alloc] init];
    dicSend[@"reqType"] = @"12";
   
    
    NSString  *nstrDic = [dicSend JSONString];
    
    NSLog(@"我发送是否评论过信息：%@", nstrDic);
    
    NSError *error = nil;
    BOOL  sendSuccess =  [_webSocket sendString:nstrDic error:&error];
    if (!sendSuccess)
     {
        // 发送失败，重新连接服务器
        [self socketConnectHost];
     }
}




// 发送心跳包
- (void)longConnectToSocket
{
    // 根据服务器要求发送固定格式的数据
    
    NSMutableDictionary *dicSend = [[NSMutableDictionary alloc] init];
    dicSend[@"reqType"] = @"2";

    NSString  *nstrDic = [dicSend JSONString];
    
    NSLog(@"我发送心跳包: %@", nstrDic);
    
    NSError *error = nil;
    BOOL  sendSuccess =  [_webSocket sendString:nstrDic error:&error];
    if (!sendSuccess)
     {
        NSLog(@"sendheart err:%@",error);
        // 发送失败，重新连接服务器
        [self socketConnectHost];
     }
    
}

// 发送文本和 简单表情
- (BOOL)sendText:(NSString *) strSend
{
    
    if(!longSocket)
     {
        NSLog(@"网络连接断开，发送失败，即将进行重连");
        
        [self socketConnectHost];
        
        return FALSE;
     }
    
    // 根据服务器要求发送固定格式的数据
    NSMutableDictionary *dicMsgData = [[NSMutableDictionary alloc] init];
    dicMsgData[@"type"] = @"text";
    dicMsgData[@"content"] = strSend;
    
    NSMutableDictionary *dicSend = [[NSMutableDictionary alloc] init];
    dicSend[@"reqType"] = @"3";
    dicSend[@"body"] = dicMsgData;
    
    NSString  *nstrDic = [dicSend JSONString];
    
    NSLog(@"我发送文本信息:  %@" ,nstrDic);
    
    NSError *error = nil;
    BOOL  sendSuccess =  [_webSocket sendString:nstrDic error:&error];
    if (error!=nil)
     {
        NSLog(@"发送<%@>   失败：%@",strSend,error);
     }
    
    return sendSuccess;
}

// 发送组装好的命令
- (BOOL)sendDic:(NSDictionary *) dicSend
{
    if(!longSocket)
     {
        NSLog(@"网络连接断开，发送失败，即将进行重连");
        
        [self socketConnectHost];
        
        return FALSE;
     }
    
    NSString  *nstrDic = [dicSend JSONString];
    
    NSLog(@"我发送文本信息:  %@" ,nstrDic);
    
    NSError *error = nil;
    BOOL  sendSuccess =  [_webSocket sendString:nstrDic error:&error];
    if (error!=nil)
     {
        NSLog(@"发送<%@>   失败：%@",dicSend,error);
     }
    
    return sendSuccess;
}

// 发送断开命令到后台
-(BOOL)sendClose
{
    NSMutableDictionary  *dicSend = [[NSMutableDictionary alloc] init];
    dicSend[@"reqType"] = @(11);
    
    NSString  *nstrDic = [dicSend JSONString];
    
    NSLog(@"我发送文本信息:  %@" ,nstrDic);
    
    NSError *error = nil;
    BOOL  sendSuccess =  [_webSocket sendString:nstrDic error:&error];
    if (error!=nil)
     {
        NSLog(@"发送<%@>   失败：%@",dicSend,error);
     }
    else
     {
        activeDisconnection = TRUE;
     }
    
    return  sendSuccess;
    
}

@end
