//
//  SocketManager.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/2/20.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "SocketManager.h"
#import "GCD/GCDAsyncSocket.h"
#import "NetMessageObj.h"


@interface SocketManager ()<GCDAsyncSocketDelegate>
{

    BOOL socketHost;  //是否获取了服务器端口
    BOOL longSocket;  //是否连接正常
    NSString *Host;
    NSInteger Port;
    NSInteger errCount;      //重连次数计数器
}

//Socket
@property(nonatomic,strong)GCDAsyncSocket *asyncSocket;

// 长连接计时器
@property(nonatomic,strong)NSTimer *connectTimer;

@end

@implementation SocketManager


- (id)init {
    if (self=[super init]) {
        // Initialize self.
//        Host = @"127.0.0.1";
//        Port = 1234;
        
        Host = @"192.168.10.131";
        Port = 6406;
    }
    return self;
}


//初始化Socket并发起连接
- (void)socketConnectHost{
    if (!_asyncSocket)
     {
        _asyncSocket=nil;
     }
    
    _asyncSocket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    _asyncSocket.delegate = self;
    
    NSError *error = nil;
    [_asyncSocket connectToHost:Host onPort:Port withTimeout:1 error:&error];
    
    if (error!=nil) {
        NSLog(@"发起连接失败：%@",error);
    }else{
        NSLog(@"发起连接 ：HOST=%@ PORT=%ld,", Host,(long)Port);
    }
}


#pragma mark --- GCDAsyncSocketDelegate
//连接失败回调
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    errCount ++;
    //连接失败
    longSocket = NO;
    //取消定时器
    [_connectTimer invalidate];
    _connectTimer = nil;
    if (err) {
        NSLog(@"错误报告：%@ -- 重新连接",err);
    }
    if (errCount <= 5) {
        [_asyncSocket disconnect];
        //重新连接
        [_asyncSocket connectToHost:Host onPort:Port withTimeout:1 error:&err];
    }else if(errCount == 6){
        //重新获取服务器端口
        //[self socketURL];
    }
}

//连接成功回调
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    //连接成功
    NSLog(@"连接成功：%@:%d",host, (int)port);
    
    longSocket = YES;
    // 每隔20秒向服务器发送心跳包  一般设置30秒发送一次心跳包
    _connectTimer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(longConnectToSocket) userInfo:nil repeats:YES];
    [_connectTimer fire];
}



//接收数据
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
    NSLog(@"didReadData:%@", data);
    
    NSString * str  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"didReadData:%@",str);
    
    NetMessageObj *netObj = [[NetMessageObj alloc] init];
    //解码获取的数据包
    //NSDictionary * dic = [netObj parseData:data];
    
    //cmdName非0001状况下获取数据并通知子页面
//    if ([[dic objectForKey:@"cmdName"] isEqualToString:@"0003"] || [[dic objectForKey:@"cmdName"] isEqualToString:@"0002"]) {
//        //发送数据
//        //创建通知
//        NSNotification *notification =[NSNotification notificationWithName:@"socketDataSource" object:nil userInfo:dic];
//        //通过通知中心发送通知
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
//    }
    
    // 进行下一次数据读取
    [sock readDataWithTimeout:-1 tag:0]; // -1 表示一直监听数据接收
    
}

// 发送成功时，会调用此函数
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"didWriteDataWithTag:%ld",tag);
    
    // 发送成功后， 主动读取后台数据
    [_asyncSocket readDataWithTimeout:3 tag:1];
}


#pragma mark ---  发送函数
// 发送心跳包
- (void)longConnectToSocket {
    
    // 根据服务器要求发送固定格式的数据
    NSLog(@"我要发心跳包了");
//    NetMessageObj  *netObj = [[NetMessageObj alloc] init];
//    netObj.deviceId = [DDGSetting sharedSettings].UUID_MD5;
//    netObj.uid = [DDGSetting sharedSettings].uid;
//    netObj.cmdName = @"0001";
//    //    netObj.msgRemark = @{@"deviceId":[DDGSetting sharedSettings].UUID_MD5,@"uid":[DDGSetting sharedSettings].uid};
//    NSData *dataStream =  [netObj packCmd];
//    [_asyncSocket readDataWithTimeout:3 tag:1];
//    [_asyncSocket writeData:dataStream withTimeout:1 tag:1];
    
}

// 发送文本和 简单表情
- (void)sendText:(NSString *) strSend
{
    
    // 根据服务器要求发送固定格式的数据
    NSLog(@"我发送文本信息");
    NetMessageObj  *netObj = [[NetMessageObj alloc] init];
    netObj.deviceId = [DDGSetting sharedSettings].UUID_MD5;
    netObj.uid = [DDGSetting sharedSettings].uid;
    netObj.cmdName = @"0001";
    //    netObj.msgRemark = @{@"deviceId":[DDGSetting sharedSettings].UUID_MD5,@"uid":[DDGSetting sharedSettings].uid};
    NSData *dataStream =  [netObj packCmd];

    

    
    
    [_asyncSocket readDataWithTimeout:3 tag:1];
    //[_asyncSocket writeData:dataStream withTimeout:1 tag:1];
    
    NSMutableDictionary *dicSend = [[NSMutableDictionary alloc] init];
    dicSend[@"toUserId"] = @"258";
    dicSend[@"contentText"] = strSend;
    
    char * szDic = (char*)"";
    NSString  *nstrDic = [dicSend JSONString];
    szDic = (char*)[nstrDic UTF8String];
    int iRemarkLen = (int)strlen(szDic);
    
    NSData *data = [NSData dataWithBytes:szDic  length:iRemarkLen];
    
    [_asyncSocket writeData:data withTimeout:1 tag:1];
    
}



@end
