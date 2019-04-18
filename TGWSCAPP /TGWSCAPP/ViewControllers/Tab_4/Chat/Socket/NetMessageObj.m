//
//  ReadeMessage.m
//  HealthHome
//
//  Created by szxys_mac on 16/10/27.
//
//

#import "NetMessageObj.h"
#include <arpa/inet.h>

@implementation NetMessageObj



int ToBigEndian(int dwBigEndian)
{
    
    return htonl(dwBigEndian);
    
}

int ToLittleEndian(int dwBigEndian)
{
    
    return ntohl(dwBigEndian);
    
}


// 组建普通命令包 (字段赋值由函数外部传入)
-(NSData *)packCmd
{
    
    /***发送时间,存数字long转为字符号 */
    NSDate *senddate = [NSDate date];
    self.msgTime = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];// 当前时间戳
    
    char szOut[5*1024] = {0};
    int  iCurLen = 0;  // 当前字符串的位置
    
    int iDateLen = (int)self.msgTime.length;
    int iDateLenBig = ToBigEndian(iDateLen);
    
    int iCmdNameLen = (int)self.cmdName.length;
    int iCmdNameLenBig = ToBigEndian(iCmdNameLen);
    
    NSString *nstrDic=@"";
    char * szDic = (char*)"";
    if (self.msgRemark != nil)
    {
       nstrDic = [self.msgRemark JSONString];
       szDic = (char*)[nstrDic UTF8String];
    }

    int iRemarkLen = (int)strlen(szDic);
    int iRemarkLenBig = ToBigEndian(iRemarkLen);
    
    int iCmdMethodLen = (int)self.cmdMethod.length;
    int iCmdMethodLenBig = ToBigEndian(iCmdMethodLen);
    
    int iDataLen = (int)self.msgData.length;
    int iDataLenBig = ToBigEndian(iDataLen);
    
    int iUUidLen = (int)self.deviceId.length;
    int iUUidLenBig = ToBigEndian(iUUidLen);
    
    int iUidLen = (int)self.uid.length;
    int iUidLenBig = ToBigEndian(iUidLen);
    
    int iSuccessLen = (int)self.success.length;
    int iSuccessLenBig = ToBigEndian(iSuccessLen);
    
    int iMessageLen = (int)self.message.length;
    int iMessageLenBig = ToBigEndian(iMessageLen);
    
    
    int iTotalLen = iDateLen + iCmdNameLen + iRemarkLen + iCmdMethodLen + iDataLen + iUUidLen + iUidLen + iSuccessLen + iMessageLen + sizeof(int)* 10;
    int iTotalLenBig = ToBigEndian(iTotalLen);
    
    
    
    // 赋值总长度
    memcpy(szOut+iCurLen, &iTotalLenBig, sizeof(int));
    iCurLen += sizeof(int);
    
    
    // 赋值日期
    memcpy(szOut+iCurLen, &iDateLenBig, sizeof(int));
    iCurLen += sizeof(int);
    memcpy(szOut+iCurLen, [self.msgTime UTF8String], iDateLen);
    iCurLen += iDateLen;
    
    // 赋值命令名称
    memcpy(szOut+iCurLen, &iCmdNameLenBig, sizeof(int));
    iCurLen += sizeof(int);
    memcpy(szOut+iCurLen, [self.cmdName UTF8String], iCmdNameLen);
    iCurLen += iCmdNameLen;
    
    // 赋值命令方法
    memcpy(szOut+iCurLen, &iCmdMethodLenBig, sizeof(int));
    iCurLen += sizeof(int);
    memcpy(szOut+iCurLen, [self.cmdMethod UTF8String], iCmdMethodLen);
    iCurLen += iCmdMethodLen;
    
    // 赋值数据参数
    memcpy(szOut+iCurLen, &iRemarkLenBig, sizeof(int));
    iCurLen += sizeof(int);
    
    memcpy(szOut+iCurLen, [nstrDic UTF8String], iRemarkLen);
    iCurLen += iRemarkLen;
    
    // 赋值其他消息
    memcpy(szOut+iCurLen, &iDataLenBig, sizeof(int));
    iCurLen += sizeof(int);
    memcpy(szOut+iCurLen, [self.msgData bytes], iDataLen);
    iCurLen += iDataLen;
    
    // 用户设备ID
    memcpy(szOut+iCurLen, &iUUidLenBig, sizeof(int));
    iCurLen += sizeof(int);
    memcpy(szOut+iCurLen, [self.deviceId UTF8String], iUUidLen);
    iCurLen += iUUidLen;
    
    // uid
    memcpy(szOut+iCurLen, &iUidLenBig, sizeof(int));
    iCurLen += sizeof(int);
    memcpy(szOut+iCurLen, [self.uid UTF8String], iUidLen);
    iCurLen += iUidLen;
    
    // 返回结果
    memcpy(szOut+iCurLen, &iSuccessLenBig, sizeof(int));
    iCurLen += sizeof(int);
    memcpy(szOut+iCurLen, [self.success UTF8String], iSuccessLen);
    iCurLen += iSuccessLen;
    
    // 返回信息
    memcpy(szOut+iCurLen, &iMessageLenBig, sizeof(int));
    iCurLen += sizeof(int);
    memcpy(szOut+iCurLen, [self.message UTF8String], iMessageLen);
    iCurLen += iMessageLen;
    
    // 返回数据
    NSData *data = [NSData dataWithBytes:szOut length:iCurLen];
    //NSLog(@"组包 data : %@  data1.lenth:%lu", data, (unsigned long)data.length);
    
    return  data;
    
}


// 组建心跳包 (字段赋值由函数内部写入)
-(NSData *)packHeart
{
    
    /***发送时间,存数字long转为字符号 */
    NSDate *senddate = [NSDate date];
    self.msgTime = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];// 当前时间戳
    
    /***命令名称 */
    self.cmdName = @"0001";
    
    /***命令方法 */
    self.cmdMethod = @"test";
    
    /**数据参数，Map<String,Object> JSON.toString()用于转参 */
    self.msgRemark = @{@"deviceId":@"21",@"uid":@"1",@"shuCount":@"232",@"configId":@"2"};
    
    
    /**其他消息内容*/
    NSString *str = @"随便写的什么呢？";
    self.msgData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    /***设备ID */
    self.deviceId = [DDGSetting sharedSettings].UUID_MD5;
    
    /*** 用户UID */
    self.uid = [DDGSetting sharedSettings].uid;
 
    /***返回结果 */
    self.success = @"ture";
    
    /**返回信息 */
    self.message = @"errorMessage";
    
    
    
    char szOut[5*1024] = {0};
    int  iCurLen = 0;  // 当前字符串的位置
    
    
    int iDateLen = (int)self.msgTime.length;
    int iDateLenBig = ToBigEndian(iDateLen);
    
    int iCmdNameLen = (int)self.cmdName.length;
    int iCmdNameLenBig = ToBigEndian(iCmdNameLen);
    
    NSString *nstrDic = [self.msgRemark JSONString];
    int iRemarkLen = (int)nstrDic.length;
    int iRemarkLenBig = ToBigEndian(iRemarkLen);
    
    int iCmdMethodLen = (int)self.cmdMethod.length;
    int iCmdMethodLenBig = ToBigEndian(iCmdMethodLen);
    
    int iDataLen = (int)self.msgData.length;
    int iDataLenBig = ToBigEndian(iDataLen);
    
    int iUUidLen = (int)self.deviceId.length;
    int iUUidLenBig = ToBigEndian(iUUidLen);
    
    int iUidLen = (int)self.uid.length;
    int iUidLenBig = ToBigEndian(iUidLen);

    int iSuccessLen = (int)self.success.length;
    int iSuccessLenBig = ToBigEndian(iSuccessLen);
    
    int iMessageLen = (int)self.message.length;
    int iMessageLenBig = ToBigEndian(iMessageLen);
    
    
    int iTotalLen = iDateLen + iCmdNameLen + iRemarkLen + iCmdMethodLen + iDataLen + iUUidLen + iUidLen + iSuccessLen + iMessageLen + sizeof(int)* 10;
    int iTotalLenBig = ToBigEndian(iTotalLen);
    

    
    // 赋值总长度
    memcpy(szOut+iCurLen, &iTotalLenBig, sizeof(int));
    iCurLen += sizeof(int);
    
    
    // 赋值日期
    memcpy(szOut+iCurLen, &iDateLenBig, sizeof(int));
    iCurLen += sizeof(int);
    memcpy(szOut+iCurLen, [self.msgTime UTF8String], iDateLen);
    iCurLen += iDateLen;
    
    // 赋值命令名称
    memcpy(szOut+iCurLen, &iCmdNameLenBig, sizeof(int));
    iCurLen += sizeof(int);
    memcpy(szOut+iCurLen, [self.cmdName UTF8String], iCmdNameLen);
    iCurLen += iCmdNameLen;
    
    // 赋值命令方法
    memcpy(szOut+iCurLen, &iCmdMethodLenBig, sizeof(int));
    iCurLen += sizeof(int);
    memcpy(szOut+iCurLen, [self.cmdMethod UTF8String], iCmdMethodLen);
    iCurLen += iCmdMethodLen;
    
    // 赋值数据参数
    memcpy(szOut+iCurLen, &iRemarkLenBig, sizeof(int));
    iCurLen += sizeof(int);
    memcpy(szOut+iCurLen, [nstrDic UTF8String], iRemarkLen);
    iCurLen += iRemarkLen;
    
    
    // 赋值其他消息
    memcpy(szOut+iCurLen, &iDataLenBig, sizeof(int));
    iCurLen += sizeof(int);
    memcpy(szOut+iCurLen, [self.msgData bytes], iDataLen);
    iCurLen += iDataLen;
    
    // 用户设备ID
    memcpy(szOut+iCurLen, &iUUidLenBig, sizeof(int));
    iCurLen += sizeof(int);
    memcpy(szOut+iCurLen, [self.deviceId UTF8String], iUUidLen);
    iCurLen += iUUidLen;
    
    // uid
    memcpy(szOut+iCurLen, &iUidLenBig, sizeof(int));
    iCurLen += sizeof(int);
    memcpy(szOut+iCurLen, [self.uid UTF8String], iUidLen);
    iCurLen += iUidLen;
    
    // 返回结果
    memcpy(szOut+iCurLen, &iSuccessLenBig, sizeof(int));
    iCurLen += sizeof(int);
    memcpy(szOut+iCurLen, [self.success UTF8String], iSuccessLen);
    iCurLen += iSuccessLen;
    
    // 返回信息
    memcpy(szOut+iCurLen, &iMessageLenBig, sizeof(int));
    iCurLen += sizeof(int);
    memcpy(szOut+iCurLen, [self.message UTF8String], iMessageLen);
    iCurLen += iMessageLen;
    
    // 返回数据
    NSData *data = [NSData dataWithBytes:szOut length:iCurLen];
    
    
    NSLog(@"data1 : %@  data1.lenth:%lu", data, (unsigned long)data.length);
    
    return  data;

    
}


// 解析数据，赋值各个字段
-(NSDictionary *)parseData:(NSData*)inData
{
    char * szValue = (char*)[inData bytes];
    
    int iCurLen = 0;
    int iTemp = 0;
    const int iBufLen = 1024;
    char  szTemp[iBufLen] = {0};
    
    memcpy(&iTemp,  szValue, sizeof(int));
    iCurLen += sizeof(int);
    //int iTotalLen = ToLittleEndian(iTemp);
    
    memset(szTemp,0,iBufLen);
    memcpy(&iTemp,  szValue+iCurLen, sizeof(int));
    iCurLen += sizeof(int);
    int iTimeLen = ToLittleEndian(iTemp);
    memcpy(szTemp, szValue+iCurLen, iTimeLen);
    iCurLen += iTimeLen;
    self.msgTime = [NSString stringWithCString:szTemp encoding:NSUTF8StringEncoding];
    
    memset(szTemp,0,iBufLen);
    memcpy(&iTemp,  szValue+iCurLen, sizeof(int));
    iCurLen += sizeof(int);
    int iCmdNameLen = ToLittleEndian(iTemp);
    memcpy(szTemp, szValue+iCurLen, iCmdNameLen);
    iCurLen += iCmdNameLen;
    self.cmdName = [NSString stringWithCString:szTemp encoding:NSUTF8StringEncoding];
    
    memset(szTemp,0,iBufLen);
    memcpy(&iTemp,  szValue+iCurLen, sizeof(int));
    iCurLen += sizeof(int);
    int iCmdMethodLen = ToLittleEndian(iTemp);
    memcpy(szTemp, szValue+iCurLen, iCmdMethodLen);
    iCurLen += iCmdMethodLen;
    self.cmdMethod = [NSString stringWithCString:szTemp encoding:NSUTF8StringEncoding];
    
    memset(szTemp,0,iBufLen);
    memcpy(&iTemp,  szValue+iCurLen, sizeof(int));
    iCurLen += sizeof(int);
    int iRemarkLen = ToLittleEndian(iTemp);
    memcpy(szTemp, szValue+iCurLen, iRemarkLen);
    iCurLen += iRemarkLen;
    NSString* strT = [NSString stringWithCString:szTemp encoding:NSUTF8StringEncoding];
    self.msgRemark = [self dictionaryWithJsonString:strT];
    
    memset(szTemp,0,iBufLen);
    memcpy(&iTemp,  szValue+iCurLen, sizeof(int));
    iCurLen += sizeof(int);
    int iDataLen = ToLittleEndian(iTemp);
    memcpy(szTemp, szValue+iCurLen, iDataLen);
    iCurLen += iDataLen;
    self.msgData = [NSData dataWithBytes:szTemp length:strlen(szTemp)];
    
    memset(szTemp,0,iBufLen);
    memcpy(&iTemp,  szValue+iCurLen, sizeof(int));
    iCurLen += sizeof(int);
    int iDeviceIdLen = ToLittleEndian(iTemp);
    memcpy(szTemp, szValue+iCurLen, iDeviceIdLen);
    iCurLen += iDeviceIdLen;
    self.deviceId = [NSString stringWithCString:szTemp encoding:NSUTF8StringEncoding];
    
    memset(szTemp,0,iBufLen);
    memcpy(&iTemp,  szValue+iCurLen, sizeof(int));
    iCurLen += sizeof(int);
    int iuid = ToLittleEndian(iTemp);
    memcpy(szTemp, szValue+iCurLen, iuid);
    iCurLen += iuid;
    self.uid = [NSString stringWithCString:szTemp encoding:NSUTF8StringEncoding];
    
    memset(szTemp,0,iBufLen);
    memcpy(&iTemp,  szValue+iCurLen, sizeof(int));
    iCurLen += sizeof(int);
    int isuccess = ToLittleEndian(iTemp);
    memcpy(szTemp, szValue+iCurLen, isuccess);
    iCurLen += isuccess;
    self.success = [NSString stringWithCString:szTemp encoding:NSUTF8StringEncoding];
    
    memset(szTemp,0,iBufLen);
    memcpy(&iTemp,  szValue+iCurLen, sizeof(int));
    iCurLen += sizeof(int);
    int imessage = ToLittleEndian(iTemp);
    memcpy(szTemp, szValue+iCurLen, imessage);
    iCurLen += imessage;
    self.message = [NSString stringWithCString:szTemp encoding:NSUTF8StringEncoding];
    
    NSDictionary *dic;
    if (self.msgRemark.count > 0 && self.cmdName.length > 0) {
        dic = @{@"cmdName":self.cmdName,@"msgRemark":self.msgRemark,@"success":self.success,@"message":self.message};
    }else{
        
        dic = @{@"success":self.success,@"message":self.message};
    }
    
    return dic;
}


- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        //NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}




@end
