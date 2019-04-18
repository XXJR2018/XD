//
//  DDGConstants.h
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#ifndef DDGUtils_DDGConstants_h
#define DDGUtils_DDGConstants_h


#define DDGDebugLog(format, ...) [[DDGLog sharedDebug] log: kLogLevelDebug \
overrideGlobal:YES \
fileName:__FILE__ \
functionName:__PRETTY_FUNCTION__  \
lineNumber:__LINE__ \
input:(format), ##__VA_ARGS__]

#define PD_date1970         [NSDate dateWithTimeIntervalSince1970:0]
//default date time format string
#define DefaultDateTimeFormatString         @"yyyy-MM-dd HH:mm:ss"
#define DefaultShortDateFormatString        @"yyyy-M-d"
#define DefaultDateFormatString             @"yyyy-MM-dd"
#define ChineseDateFormatString             @"yyyy年M月d日"
#define ChineseHMFormatString               @"HH时mm分"
#define ShortDateFormatString               @"yyyy-MM-dd HH:mm"
#define HMSFormatString                      @"HHmmss"

/*!
 @brief DDGVerboseLog, 用于输出最详细信息， 该信息不需要保存
 */
#define DDGVerboseLog(log, ...)  NSLog((@"%s [Line %d] " log), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)


//简写
#define DDG_marr(...)  [NSMutableArray arrayWithObjects:__VA_ARGS__, nil]
#define DDG_set(...)   [NSSet setWithObjects:__VA_ARGS__, nil]
#define DDG_mset(...)  [NSMutableSet setWithObjects:__VA_ARGS__, nil]
#define DDG_mdict(...) [NSMutableDictionary dictionaryWithObjectsAndKeys:__VA_ARGS__, nil]
#define DDG_str(...)   [NSString stringWithFormat:__VA_ARGS__]
#define DDG_mstr(...)  [NSMutableString stringWithFormat:__VA_ARGS__]


#define DDG_date1970         [NSDate dateWithTimeIntervalSince1970:0]

//URL
#define DDG_url(val)         [NSURL URLWithString:(val)]
#define DDG_urldict(val,dict) [NSURL URLWithString:(val) paramDictionary:(dict)]


//弧度与角度转换
#ifndef degreesToRadian
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#endif

#ifndef radianToDegrees
#define radianToDegrees(x) (180.0 * (x) / M_PI)
#endif


//数据库名称
#define DBNAME              @"data.sqlite"
//日志数据库名称
#define LOGDBNAME           @"log_data.sqlite"

//单例模式头
#define DEFINE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;
//单例模式实现
#define DEFINE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

/*!
 @brief 处理arc环境下调用performSelector:的警告
 */
#define SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING(code)                        \
_Pragma("clang diagnostic push")                                            \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")         \
code;                                                                       \
_Pragma("clang diagnostic pop")                                             \
((void)0)

#endif
