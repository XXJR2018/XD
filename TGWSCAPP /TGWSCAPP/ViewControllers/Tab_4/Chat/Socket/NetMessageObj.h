//
//  ReadeMessage.h
//  HealthHome
//
//  Created by szxys_mac on 16/10/27.
//
//

#import <Foundation/Foundation.h>


// 此类不能写成单例类， 网络通讯时，会有多线程读写数据（单例类会有脏数据的问题）
@interface NetMessageObj : NSObject

@property(nonatomic,copy)NSString   *msgTime;   //发送时间,存数字long转为字符号

@property(nonatomic,copy)NSString   *cmdName;   //命令名称

@property(nonatomic,copy)NSString   *cmdMethod;  //命令方法

@property(nonatomic,copy)NSDictionary   *msgRemark;  //数据参数，Map<String,Object> JSON.toString()用于转参

@property(nonatomic,copy)NSData     *msgData;    //其他消息内容

@property(nonatomic,copy)NSString   *deviceId;  //设备ID

@property(nonatomic,copy)NSString   *uid;         //用户UID

@property(nonatomic,copy)NSString   *success;    //返回结果

@property(nonatomic,copy)NSString   *message;    //返回信息


// 组建普通命令包 (字段赋值由函数外部传入)
-(NSData *)packCmd;

// 组建心跳包 (字段赋值由函数内部写入)
-(NSData *)packHeart;

// 解析数据，赋值各个字段
-(NSDictionary *)parseData:(NSData*)inData;

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;



@end
