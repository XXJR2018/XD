//
//  CommonInfo.h
//  Save
//
//  Created by xxjr03 on 16/2/24.
//  Copyright © 2016年 xxjr03. All rights reserved.
//

#import <Foundation/Foundation.h>


#define  K_Home_TJ_UIData  @"K_Home_TJ_UIData" // 首页-推荐子页面的数据KEY
#define  K_Home_IS_YSXY  @"K_Home_IS_YSXY" // 是否点击过 用户隐私协议
#define  K_XCODE         @"K_XCODE"    // h5页面的 xcode
#define  K_ShopTopImgUrl   @"K_ShopTopImgUrl"    // 商品详情分析页面的顶部图片


@interface CommonInfo : NSObject


//登录状态
+ (BOOL)isLoggedIn;

//signId
+(void)setSignId:(NSString *)signId;

+(NSString *)signId;

//用户信息
+(void)setUserInfo:(NSDictionary *)userInfo;

+(NSDictionary *)userInfo;

//审核状态
+(void)setVerify:(NSString *)Verify;

+(NSString *)Verify;

//退出登录清空全部数据
+(void)AllDeleteInfo;

// 设置字符串为非空
+(NSString*)SetNotNull:(NSString*) strValue;

// 删除NSArray中的NSNull
+ (NSMutableArray *)removeNullFromArray:(NSArray *)arr;

// Dictionary中的NSNull转换成@“”
+ (NSMutableDictionary *)removeNullFromDictionary:(NSDictionary *)dic;

// 根据KEY来设置VALUE (函数内部为此KEY值会加上UID， 每个用户都是唯一的)
+(void)setKey:(NSString *) strkey withValue:(NSString*) strValue;

// 根据KEY来得到VALUE (函数内部为此KEY值会加上UID， 每个用户都是唯一的)
+(NSString*)getKey:(NSString *) strkey;

// 根据KEY来设置VALUE (函数内部为此KEY值会加上UID， 每个用户都是唯一的)
+(void)setKey:(NSString *) strkey withDicValue:(NSDictionary*) dicValue;

// 根据KEY来得到VALUE (函数内部为此KEY值会加上UID， 每个用户都是唯一的)
+(NSDictionary*)getKeyOfDic:(NSString *) strkey;


// 根据KEY来设置VALUE (函数内部为此KEY值会加上UID， 每个用户都是唯一的)
+(void)setKey:(NSString *) strkey withArrayValue:(NSArray*) aryValue;

// 根据KEY来得到VALUE (函数内部为此KEY值会加上UID， 每个用户都是唯一的)
+(NSArray*)getKeyOfArray:(NSString *) strkey;

// 千分符来格式化字符串
+(NSString*) formatString:(NSString*) str;

// 千分符来格式化字符串
+(NSString*) dFormatString:(double) dValue;


@end


@interface NSObject (change)

-(instancetype)change;

@end
