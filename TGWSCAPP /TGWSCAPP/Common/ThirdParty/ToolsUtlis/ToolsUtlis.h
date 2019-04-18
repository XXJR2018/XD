//
//  ToolsUtlis.h
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/10.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef kCFCoreFoundationVersionNumber_iOS_6_0
#define kCFCoreFoundationVersionNumber_iOS_6_0 790.00
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
#define kCFCoreFoundationVersionNumber_iOS_7_0 847.20
#endif

#ifndef kCFCoreFoundationVersionNumber_iOS_7_1
#define kCFCoreFoundationVersionNumber_iOS_7_1 847.24
#endif


/**
 * Swap two class instance method implementations.
 *
 * Use this method when you would like to replace an existing method implementation in a class
 * with your own implementation at runtime. In practice this is often used to replace the
 * implementations of UIKit classes where subclassing isn't an adequate solution.
 *
 * This will only work for methods declared with a -.
 *
 * After calling this method, any calls to originalSel will actually call newSel and vice versa.
 *
 * Uses method_exchangeImplementations to accomplish this.
 */
FOUNDATION_EXPORT void DDGSwapInstanceMethods(Class cls, SEL originalSel, SEL newSel);

/**
 * Swap two class method implementations.
 *
 * Use this method when you would like to replace an existing method implementation in a class
 * with your own implementation at runtime. In practice this is often used to replace the
 * implementations of UIKit classes where subclassing isn't an adequate solution.
 *
 * This will only work for methods declared with a +.
 *
 * After calling this method, any calls to originalSel will actually call newSel and vice versa.
 *
 * Uses method_exchangeImplementations to accomplish this.
 */
FOUNDATION_EXPORT void DDGSwapClassMethods(Class cls, SEL originalSel, SEL newSel);

/**
 *  @brief 用于替换根viewController, ios 3.2的系统未经测试
 */
FOUNDATION_EXPORT void DDGReplaceRootViewWithController(UIViewController *oldViewController, UIViewController *newViewController);
/*!
 @brief 网络状态发生变化的通知
 */
FOUNDATION_EXPORT NSString * const kReachabilityChangedNotification;


#pragma mark -
#pragma mark ==== inlineFunctions ====
#pragma mark -

CF_INLINE CGSize
CGSizeAdd(CGSize s1, CGSize s2)
{
    CGSize size; size.width = s1.width + s2.width; size.height = s1.height + s2.height; return size;
}
CF_INLINE CGSize
CGSizeSubstract(CGSize s1, CGSize s2)
{
    CGSize size; size.width = s1.width - s2.width; size.height = s1.height - s2.height; return size;
}

CF_INLINE CGPoint CGRectGetCenter(CGRect rect)
{
    return CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2);
}

CF_INLINE CGPoint CGPointAdd(CGPoint p1, CGPoint p2)
{
    CGPoint point; point.x = p1.x + p2.x; point.y = p1.y + p2.y; return point;
}
CF_INLINE CGPoint
CGPointSubstract(CGPoint p1, CGPoint p2)
{
    CGPoint point; point.x = p1.x - p2.x; point.y = p1.y - p2.y; return point;
}

CF_INLINE CGFloat
CGPointDistance(CGPoint p1, CGPoint p2)
{
    return sqrtf(powf(p1.x-p2.x, 2)+powf(p1.y-p2.y, 2));
}


#pragma mark -

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom
} VerticalAlignment;


NS_ASSUME_NONNULL_BEGIN

@interface ToolsUtlis : NSObject

/*!
 @brief     是否为高清retina屏
 */
+ (BOOL)isRetinaDisplay;
/*!
 @brief     屏幕缩放比例， iphone4以前都是1.f， 以后目前是2.f
 */
+ (CGFloat)scale;
//判断是否为iPad
+ (BOOL)isIpad;
/*!
 @brief     是否为iphone5设备， 目前根据[uiscreen mainscreen].bounds.size判断， 后续可以再优化
 */
+ (BOOL)isIPhone5;

//判断当前IOS版本至少为6.0
+ (BOOL)isAtLeastIOS_6_0;
//判断当前IOS版本至少为7.0
+ (BOOL)isAtLeastIOS_7_0;

/*!
 @brief     手机类型2.1 iphone, 2.2 ipad, 2.3 ipod touch
 */
+ (NSString *)mobileType;
/*!
 @brief     平台类型, 1网站 2Android 3iphone
 */
+ (NSString *)PlatformType;

/*!
 @brief     移动网络码 手机运营商
 */
+ (NSDictionary *)getMobileNetworkPropertys;

#ifndef PAD_PADCocos2dMacro

/*!
 @brief     getCurrentIP
 @return    当前设备的IP
 */
+ (NSString *)getCurrentIP;
/*!
 @brief     getCurrentIP
 @return    当前设备的外网IP
 */
+(NSDictionary *)deviceWANIPAdress;

#endif

/*!
 @brief     终端标记, UUID, 用于唯一标识, 当前做法是以wifi的mac地址唯一标识. 如果获取不到mac地址, 就创建一个UUID
 */
+ (NSString *)terminalSign;

//替换ipad 3.2上的uiimage imagenamed方法，使其能智能判断~ipad.png结尾的图片资源
+ (void)replaceImageNamedMethodOnIPAD_3_2;

////设置默认字体，主要工作原理即利用运行时替换方法，替换uilabel的部分方法
//+ (void)setDefaultLabelFont;

//判断系统时间制式，是否为12小时制
+ (BOOL) isTwelveHourFormat;

/*!
 @brief     判断网络是否通畅
 */
+ (BOOL)isNetworkReachable;

/*!
 @brief     判断网络是否WiFi
 */
+ (BOOL)isNetworkReachableViaWiFi;
/*!
 @brief     判断网络是否是2G/3G
 */
+ (BOOL)isNetworkReachableVia2G3G;

/*!
 @brief     开启网络通知
 */
+ (void)startNetworkNotifier;
/*!
 @brief     判断界面是否第一次显示
 */
+ (BOOL)isAppFirstLoadTab:(NSInteger)index;
/*!
 @brief     判断程序是否第一次启动或者升级后第一次启动
 */
+ (BOOL)isAppFirstLoaded;
/*!
 @brief     保存bundle version, 用于解除第一次启动引导页
 */
+ (void)saveBundleVersion;

// 判断路径存在
+ (BOOL)fileExistsAtPath:(NSString *)path;

// 按路径删除文件
+ (void)deleteFileAtPath:(NSString *)path;

//文档路径
+ (NSString *)documentPath;

/*!
 @brief     app的temp目录, app_path/tmp
 @return    app的temp目录
 */
+ (NSString *)tempPath;

+ (NSString *)libraryPath;
/*!
 @brief     app的cache目录, app_path/Library/Caches
 @return    app的cache目录
 */
+ (NSString *)cachePath;

/**
 * Caches/global
 **/
// 全局根文件 .../Caches/global
+ (NSString *)cachesGlobalRootPath;
// 全局根文件 .../Caches/global + folder
+ (NSString *)cachesGlobalWithFolder:(NSString *)name;

// 用户关联id文件 .../Caches/user/user_id
+ (NSString *)cachesUserPath:(NSString *)userID;

// 用户头像路径 ...(Caches/user/userIcon)
+ (NSString *)userIconPath;

//bundle中资源路径
+ (NSString *)pathForResource:(NSString *)relativePath InBundle:(NSBundle *)bundle;
//文档中资源路径
+ (NSString *)pathForResrouceInDocuments:(NSString *)relativePath;

/*!
 @brief     手机分辨率
 */
+ (NSString *)mobileResolution;
///*!
// @brief     在指定的view中创建不可见的mpvolumeview，主要用于隐藏音量增减指示的view
// @param     view 需要插入mpvolumeview的view
// */
//+ (void)hideVolumeIncrementIndicatorInView:(UIView *)view;
/*!
 @brief     创建新的SessionId
 */
+ (NSString *)createNewSessionId;
/*!
 @method     setUILabel:withMaxFrame:withText:usingVerticalAlign:
 @abstract   设置UILabel的文字分行并切可以缩小字体
 @discussion 设置UILabel的文字的竖排方式
 @param      font 需要设置的字体
 @param      label 需要设置的UILabel
 @param      size UILabel的最大size
 */
+ (void)setUILabel:(UILabel *)label fontSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
/*!
 @method     setUILabel:withMaxFrame:withText:usingVerticalAlign:
 @abstract   设置UILabel的文字的竖排方式
 @discussion 设置UILabel的文字的竖排方式
 @param      myLabel 需要设置的UILabel
 @param      maxFrame UILabel的最大Frame
 @param      theText 要设置的文字
 @param      vertAlign 竖排方式
 */
+ (void)setUILabel:(UILabel *)myLabel
      withMaxFrame:(CGRect)maxFrame
          withText:(NSString *)theText
usingVerticalAlign: (VerticalAlignment) vertAlign;

#pragma mark -
#pragma mark ==== 空对象处理函数 ====
#pragma mark -

/*!
 @brief     将nil的字符串替换为空字符串"". 多用于界面展示时, 空数据不直接变为nil/null显示出来, 字符串不为nil时不做改动
 @param     stringIfNil 可能为空的字符串
 @return    字符串为nil时, 返回空字符串, 否则返回原字符串
 */
+ (NSString *)replaceNilStringWithEmptyString:(NSString *)stringIfNil;
/*!
 @brief     将nil的字符串替换为指定的字符串
 @param     stringIfNil 可能为空的字符串
 @param     replaceString 替换字符串
 @return    字符串为nil时, 返回替换后的字符串, 否则返回原字符串
 */
+ (NSString *)replaceNilString:(NSString *)stringIfNil withString:(NSString *)replaceString;
/*!
 @brief     将nil的对象替换为null对象. 多用于数据库操作, 将nil的对象替换为[NSNull null]
 @param     objectIfNil 可能为nil的对象
 @return    对象为nil时, 返回null对象, 否则返回原对象
 */
+ (id)replaceNilObjectWithNullObject:(id)objectIfNil;
/*!
 @brief     将nil的对象替换为指定的对象
 @param     objectIfNil 可能为nil的对象
 @param     replaceObject 替换的新对象
 @return    对象为nil时, 返回替换后的对象, 否则返回原对象
 */
+ (id)replaceNilObject:(id)objectIfNil withObject:(id)replaceObject;



#pragma mark ==== 获取图片  =====
// 从网络URL或者本地加载图片
+(UIImage*) getImgFromStr:(NSString*) strImg;


#pragma mark ==== 计算字符长度和高度，根据frame 和 font====
+  (CGSize) getSizeWithString:(NSString*) string withFrame:(CGRect) rect withFontSize:(int)fontSize;


#pragma mark ==== 画虚线 (宽度为1， 长度为任意)
+(UIImage *)imageWithLineWithImageView:(UIImageView *)imageView;


#pragma mark ==== 解决floalt类型，转换字符串时，丢失精度的问题. 转化为保留2位小数
+ (NSString *)getnumber:(id)numberId;

@end

NS_ASSUME_NONNULL_END
