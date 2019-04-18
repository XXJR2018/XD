//
//  CommonInfo.m
//  Save
//
//  Created by xxjr03 on 16/2/24.
//  Copyright © 2016年 xxjr03. All rights reserved.
//

#import "CommonInfo.h"



@implementation CommonInfo

//登录状态
+ (BOOL)isLoggedIn{
    if ([CommonInfo signId] && [CommonInfo signId].length > 1) {
        NSString *singId = [NSString stringWithFormat:@"%@",[CommonInfo signId]];
        if([singId rangeOfString:@"noApp"].location !=NSNotFound){
            return NO;
        }else{
            return YES;
        }
        return YES;
    }
    return NO;
}

//signId
+(void)setSignId:(NSString *)signId{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[signId change] forKey:@"signId"];
}

+(NSString *)signId{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"signId"] ?: @"0";
}

//用户信息
+(void)setUserInfo:(NSDictionary *)userInfo{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[userInfo change] forKey:kUser_Info];
    
    
    // 设置 [DDGSetting sharedSettings].uid
    if (userInfo)
     {
        NSString *encryptCustId = userInfo[@"encryptCustId"];
        [DDGSetting sharedSettings].uid = encryptCustId;
     }
}

+(NSDictionary *)userInfo{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kUser_Info];
}

//审核状态
+(void)setVerify:(NSString *)Verify{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[Verify change] forKey:@"Verify"];
}

+(NSString *)Verify{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"Verify"] ?: @"0";
}

//清空全部数据
+(void)AllDeleteInfo{
    [CommonInfo setSignId:nil];
    [CommonInfo setUserInfo:nil];

}


// 根据KEY来设置VALUE (函数内部为此KEY值会加上UID， 每个用户都是唯一的 ,Uid要去掉前面8位的随机数)
+(void)setKey:(NSString *) strkey withValue:(NSString*) strValue
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * strUserKey = [self SetNotNull:strkey];
    NSString * strUid = [DDGSetting sharedSettings].uid;
    if (strUid.length > 8)
     {
        strUid = [strUid substringFromIndex:8];
     }
    strUserKey = [strUserKey stringByAppendingString:strUid];
    [defaults setObject:[self SetNotNull:strValue] forKey:strUserKey];
}

// 根据KEY来得到VALUE (函数内部为此KEY值会加上UID， 每个用户都是唯一的， Uid要去掉前面8位的随机数) ,返回值必定为非空
+(NSString*)getKey:(NSString *) strkey
{
    NSString * strRet = @"";
    NSString * strUserKey = [self SetNotNull:strkey];
    NSString * strUid = [DDGSetting sharedSettings].uid;
    if (strUid.length > 8)
     {
        strUid = [strUid substringFromIndex:8];
     }
    strUserKey = [strUserKey stringByAppendingString:strUid];
    NSString *strValue = [[NSUserDefaults standardUserDefaults]objectForKey:strUserKey];
    strRet = [self SetNotNull:strValue];
    
    return strRet;

}

// 根据KEY来设置VALUE (函数内部为此KEY值会加上UID， 每个用户都是唯一的)
+(void)setKey:(NSString *) strkey withDicValue:(NSDictionary*) strValue
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * strUserKey = [self SetNotNull:strkey];
    NSString * strUid = [DDGSetting sharedSettings].uid;
    if (strUid.length > 8)
    {
        strUid = [strUid substringFromIndex:8];
    }
    strUserKey = [strUserKey stringByAppendingString:strUid];
    [defaults setObject:strValue forKey:strUserKey];
}

// 根据KEY来得到VALUE (函数内部为此KEY值会加上UID， 每个用户都是唯一的)
+(NSDictionary*)getKeyOfDic:(NSString *) strkey
{
    NSDictionary * dicRet = nil;
    NSString * strUserKey = [self SetNotNull:strkey];
    NSString * strUid = [DDGSetting sharedSettings].uid;
    if (strUid.length > 8)
    {
        strUid = [strUid substringFromIndex:8];
    }
    strUserKey = [strUserKey stringByAppendingString:strUid];
    dicRet = [[NSUserDefaults standardUserDefaults]objectForKey:strUserKey];
    
    
    return dicRet;
    
}


// 根据KEY来设置VALUE (函数内部为此KEY值会加上UID， 每个用户都是唯一的)
+(void)setKey:(NSString *) strkey withArrayValue:(NSArray*) aryValue
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * strUserKey = [self SetNotNull:strkey];
    NSString * strUid = [DDGSetting sharedSettings].uid;
    if (strUid.length > 8)
     {
        strUid = [strUid substringFromIndex:8];
     }
    strUserKey = [strUserKey stringByAppendingString:strUid];
    [defaults setObject:aryValue forKey:strUserKey];
}

// 根据KEY来得到VALUE (函数内部为此KEY值会加上UID， 每个用户都是唯一的)
+(NSArray*)getKeyOfArray:(NSString *) strkey
{
    NSArray * arrayRet = nil;
    NSString * strUserKey = [self SetNotNull:strkey];
    NSString * strUid = [DDGSetting sharedSettings].uid;
    if (strUid.length > 8)
     {
        strUid = [strUid substringFromIndex:8];
     }
    strUserKey = [strUserKey stringByAppendingString:strUid];
    arrayRet = [[NSUserDefaults standardUserDefaults]objectForKey:strUserKey];
    
    
    return arrayRet;
}


// 设置字符串为非空
+(NSString*) SetNotNull:(NSString*) strValue
{
    
    if ( !strValue || strValue == nil ||strValue == NULL || ([strValue isKindOfClass:[NSNull class]])){
        return @"";
    }
    return strValue;
}

// 删除NSArray中的NSNull
+ (NSMutableArray *)removeNullFromArray:(NSArray *)arr
{
    NSMutableArray *marr = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        NSValue *value = arr[i];
        // 删除NSDictionary中的NSNull，再添加进数组
        if ([value isKindOfClass:NSDictionary.class]) {
            [marr addObject:[self removeNullFromDictionary:(NSDictionary *)value]];
        }
        // 删除NSArray中的NSNull，再添加进数组
        else if ([value isKindOfClass:NSArray.class]) {
            [marr addObject:[self removeNullFromArray:(NSArray *)value]];
        }
        // 剩余的非NSNull类型的数据添加进数组
        else if (![value isKindOfClass:NSNull.class]) {
            [marr addObject:value];
        }
    }
    return marr;
}

// Dictionary中的NSNull转换成@“”
+ (NSMutableDictionary *)removeNullFromDictionary:(NSDictionary *)dic
{
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    for (NSString *strKey in dic.allKeys) {
        NSValue *value = dic[strKey];
        // 删除NSDictionary中的NSNull，再保存进字典
        if ([value isKindOfClass:NSDictionary.class]) {
            mdic[strKey] = [self removeNullFromDictionary:(NSDictionary *)value];
        }
        // 删除NSArray中的NSNull，再保存进字典
        else if ([value isKindOfClass:NSArray.class]) {
            mdic[strKey] = [self removeNullFromArray:(NSArray *)value];
        }
        // 剩余的非NSNull类型的数据保存进字典
        else if (![value isKindOfClass:NSNull.class]) {
            mdic[strKey] = dic[strKey];
        }
        // NSNull类型的数据转换成@“”保存进字典
        else if ([value isKindOfClass:NSNull.class]) {
            mdic[strKey] = @"";
        }
    }
    return mdic;
}

// 千分符来格式化字符串
+(NSString*) formatString:(NSString*) str
{
    NSString * strRetrun = str;
    if (str)
     {
        double dAmount = [str doubleValue];
        strRetrun  = [NSNumberFormatter localizedStringFromNumber:@(dAmount) numberStyle:NSNumberFormatterDecimalStyle];
     }
    return strRetrun;
}


// 千分符来格式化字符串
+(NSString*) dFormatString:(double) dValue
{
    NSString * strRetrun = @"";
    strRetrun  = [NSNumberFormatter localizedStringFromNumber:@(dValue) numberStyle:NSNumberFormatterDecimalStyle];
    
    return strRetrun;
}

@end

@implementation NSObject(change)
-(instancetype)change
{
    if ( !self || self == nil ||self == NULL || ([self isKindOfClass:[NSNull class]])){
        return @"";
    }
    if ([self isKindOfClass:[NSNumber class]]) //可能还有NSValue,待观察
    {
        return [NSString stringWithFormat:@"%@",self];
    }
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)self];
        for (NSString *key in dic.allKeys) {
            if (dic[key] == [NSNull null] || dic[key] == nil) {
                [dic setObject:@"" forKey:key];
            }
        }
        return dic;
    }
    
    return self;
    
}



@end
