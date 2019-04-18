//
//  ToolsUtlis.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/10.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "ToolsUtlis.h"

#import "Reachability.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <objc/runtime.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>
#include <sys/sockio.h>
#include <net/if.h>
#include <errno.h>
#include <net/if_dl.h>



#define min(a,b) ((a) < (b) ? (a) : (b))
#define max(a,b) ((a) > (b) ? (a) : (b))

static ToolsUtlis *_evtUtils = nil;
static Reachability *_reachablity = nil;
static NetworkStatus _networkStatus = NotReachable;

NSString * const kReachabilityChangedNotification = @"kReachabilityChangedNotification";

///////////////////////////////////////////////////////////////////////////////////////////////////
void DDGSwapInstanceMethods(Class cls, SEL originalSel, SEL newSel)
{
    Method originalMethod = class_getInstanceMethod(cls, originalSel);
    Method newMethod = class_getInstanceMethod(cls, newSel);
    method_exchangeImplementations(originalMethod, newMethod);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
void DDGSwapClassMethods(Class cls, SEL originalSel, SEL newSel)
{
    Method originalMethod = class_getClassMethod(cls, originalSel);
    Method newMethod = class_getClassMethod(cls, newSel);
    method_exchangeImplementations(originalMethod, newMethod);
}

void DDGReplaceRootViewWithController(UIViewController *oldViewController, UIViewController *newViewController)
{
    id delegate = [UIApplication sharedApplication].delegate;
    if ([delegate respondsToSelector:@selector(setRootViewController:)])
        [delegate performSelector:@selector(setRootViewController:) withObject:newViewController];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if ([keyWindow respondsToSelector:@selector(setRootViewController:)])
        keyWindow.rootViewController = newViewController;
    else {
        [oldViewController.view removeFromSuperview];
        [keyWindow addSubview:newViewController.view];
    }
}

@implementation ToolsUtlis

+ (void)initialize
{
    if (_reachablity == nil)
    {
        // 设置网络检测的站点
        //        _reachablity = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        _reachablity = [Reachability reachabilityForInternetConnection];
        [_reachablity startNotifier];  //开始监听,会启动一个run loop
        _networkStatus = [_reachablity currentReachabilityStatus];
        
        _evtUtils = [[ToolsUtlis alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:_evtUtils
                                                 selector:@selector(handleReachabilityDidChangedNotification:)
                                                     name:ReachabilityDidChangedNotification
                                                   object:nil];
    }
}

- (void)handleReachabilityDidChangedNotification:(NSNotification *)notification
{
    NetworkStatus status = [_reachablity currentReachabilityStatus];
    if (_networkStatus != status)
    {
        BOOL isNeedPostNotification = (_networkStatus == NotReachable || status == NotReachable);
        _networkStatus = status;
        if (isNeedPostNotification)
            [[NSNotificationCenter defaultCenter] postNotificationName:kReachabilityChangedNotification object:nil];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReachabilityDidChangedNotification object:nil];
}


+ (BOOL)isRetinaDisplay
{
    return [[self class] scale] == 2.f;
}

+ (CGFloat)scale
{
    static BOOL isScaled;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isScaled = [[UIScreen mainScreen] respondsToSelector:@selector(scale)];
    });
    if (isScaled)
        return [[UIScreen mainScreen] scale];
    else
        return 1.f;
}



+ (BOOL)isIPhone5
{
    static NSInteger isIP5 = -1;
    if (isIP5 < 0)
        isIP5 = CGRectGetHeight([UIScreen mainScreen].bounds) == 568.f;
    return isIP5 > 0;
}

+ (BOOL)isAtLeastIOS_6_0{
    //    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.f;
    return kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_6_0;
}

+ (BOOL)isAtLeastIOS_7_0
{
    return kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0;
}

+ (NSString *)tempPath
{
    return NSTemporaryDirectory();
}


/*!
 @brief     getCurrentIP
 @return    当前设备的IP
 */
static NSString *currentIP = nil;
+ (NSString *)getCurrentIP
{
    int  MAXADDRS = 32;
    int BUFFERSIZE = 4000 ;
    char *if_names[MAXADDRS];
    char *ip_names[MAXADDRS];
    unsigned long ip_addrs[MAXADDRS];
    int                 i, len, flags;
    char                buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    struct ifconf       ifc;
    struct ifreq        *ifr, ifrcopy;
    struct sockaddr_in  *sin;
    int nextAddr = 0;
    char temp[80];
    
    if (currentIP != nil) {
        return currentIP;
    }
    int sockfd;
    
    for (i=0; i<MAXADDRS; ++i)
    {
        if_names[i] = ip_names[i] = NULL;
        ip_addrs[i] = 0;
    }
    
    sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    if (sockfd < 0)
    {
        perror("socket failed");
        return nil;
    }
    
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) < 0)
    {
        perror("ioctl error");
        return nil;
    }
    
    lastname[0] = 0;
    
    for (ptr = buffer; ptr < buffer + ifc.ifc_len; )
    {
        ifr = (struct ifreq *)ptr;
        len = max(sizeof(struct sockaddr), ifr->ifr_addr.sa_len);
        ptr += sizeof(ifr->ifr_name) + len;  // for next one in buffer
        
        if (ifr->ifr_addr.sa_family != AF_INET)
        {
            continue;   // ignore if not desired address family
        }
        
        if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL)
        {
            *cptr = 0;      // replace colon will null
        }
        
        if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0)
        {
            continue;   /* already processed this interface */
        }
        
        memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
        
        ifrcopy = *ifr;
        ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
        flags = ifrcopy.ifr_flags;
        if ((flags & IFF_UP) == 0)
        {
            continue;   // ignore if interface not up
        }
        
        if_names[nextAddr] = (char *)malloc(strlen(ifr->ifr_name)+1);
        if (if_names[nextAddr] == NULL)
        {
            for (int j=0; j<nextAddr;j++) {
                free(if_names[j]);
            }
            free(if_names);
            return nil;
        }
        strcpy(if_names[nextAddr], ifr->ifr_name);
        
        sin = (struct sockaddr_in *)&ifr->ifr_addr;
        strcpy(temp, inet_ntoa(sin->sin_addr));
        
        ip_names[nextAddr] = (char *)malloc(strlen(temp)+1);
        if (ip_names[nextAddr] == NULL)
        {
            for (int j=0; j<nextAddr;j++) {
                free(if_names[j]);
            }
            free(if_names);
            
            for (int j=0; j<nextAddr;j++) {
                free(ip_names[j]);
            }
            free(ip_names);
            
            
            return nil;
        }
        strcpy(ip_names[nextAddr], temp);
        
        ip_addrs[nextAddr] = sin->sin_addr.s_addr;
        
        ++nextAddr;
    }
    
    close(sockfd);
    
    currentIP = [NSString stringWithFormat:@"%s", ip_names[1]];
    
    for (int j=0; j<nextAddr;j++) {
        free(if_names[j]);
    }
    
    
    for (int j=0; j<nextAddr;j++) {
        free(ip_names[j]);
    }
    
    return currentIP;
}

+(NSDictionary *)deviceWANIPAdress{
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:@"http://pv.sohu.com/cityjson?ie=utf-8"];
    NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
    //判断返回字符串是否为所需数据
    if ([ip hasPrefix:@"var returnCitySN = "]) {
        //对字符串进行处理，然后进行json解析
        //删除字符串多余字符串
        NSRange range = NSMakeRange(0, 19);
        [ip deleteCharactersInRange:range];
        NSString * nowIp =[ip substringToIndex:ip.length-1];
        //将字符串转换成二进制进行Json解析
        NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        return dict[@"cip"];
    }
    return nil;
}

+ (NSString *)terminalSign
{
    NSString *_terminalSign = [[NSUserDefaults standardUserDefaults] objectForKey:DDGTerminalSignKey];
    if (_terminalSign == nil)
    {
        if ([ToolsUtlis isAtLeastIOS_7_0])
        {
            _terminalSign = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        }
        else
        {
            //MAC地址
            _terminalSign = [[UIDevice wifiMacAddressString] stringByReplacingOccurrencesOfString:@":" withString:@""];
        }
        
        //最后再取UUid的值
        if (_terminalSign == nil)
        {
            _terminalSign = [NSString createUUID];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:_terminalSign forKey:DDGTerminalSignKey];
    }
    return _terminalSign;
}

+ (BOOL) isTwelveHourFormat{
    
    //下面的方法应该更简单， 直接返回AM/PM
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    
    [timeFormatter setDateFormat:@"a"];
    NSString *AMPMtext = [timeFormatter stringFromDate:[NSDate date]];
    return !([AMPMtext isEqualToString:@""]);
    
    //    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];    //    [formatter setDateStyle:NSDateFormatterNoStyle];
    //    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    //    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    //    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    //    return !(amRange.location == NSNotFound && pmRange.location == NSNotFound);
}

+ (NSString *)mobileType
{
    if ([ToolsUtlis isIpad])
        return @"2.2";
    if ([[[UIDevice currentDevice] model] rangeOfString:@"iPhone"
                                                options:NSCaseInsensitiveSearch].location!= NSNotFound)
        return @"2.1";
    if ([[[UIDevice currentDevice] model] rangeOfString:@"iPod"
                                                options:NSCaseInsensitiveSearch].location != NSNotFound)
        return @"2.3";
    //apple tv, etc
    return @"2.0";
}


#pragma mark ===
#pragma mark === 文件路径方法
// 判断路径存在
+ (BOOL)fileExistsAtPath:(NSString *)path{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    
    if(fileExists){
        return YES;
    }else{
        return NO;
    }
}


// 按路径删除文件
+ (void)deleteFileAtPath:(NSString *)path{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    
    if(fileExists){
        
        [fileManager removeItemAtPath:path error:nil];
    }else{
        
        
    }
}


+ (NSString *)documentPath{
    static NSString* path= nil;
    if (nil == path) {
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask,
                                                            YES);
        path = [dirs objectAtIndex:0];
    }
    return path;
}

+ (NSString *)libraryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

// 缓存路径
+ (NSString *)cachePath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

/**
 * Caches/global
 **/

// 全局根文件 .../Caches/global
+ (NSString *)cachesGlobalRootPath{
    
    NSString * path = [[self cachePath]stringByAppendingPathComponent:@"global"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    
    if(fileExists){
        
    }else{
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return path;
}


// 全局根文件 .../Caches/global + folder
+ (NSString *)cachesGlobalWithFolder:(NSString *)name{
    
    NSString * path = [[self cachesGlobalRootPath] stringByAppendingPathComponent:name];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    
    if(fileExists){
        
    }else{
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return path;
}

// 用户根文件 .../Caches/user
+ (NSString *)cachesUserRootPath{
    
    NSString * path = [[self cachePath]stringByAppendingPathComponent:@"user"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    
    if(fileExists){
        
    }else{
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return path;
}

// 用户关联id文件 .../Caches/user/user_id
+ (NSString *)cachesUserPath:(NSString *)userID{
    
    NSString * path = [[self cachesUserRootPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"user_%@",userID]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    
    if(fileExists){
        
    }else{
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}


// 用户头像路径 ...(Caches/user/userIcon)
+ (NSString *)userIconPath{
    
    NSString * path = [[self cachesUserRootPath] stringByAppendingPathComponent:@"userIcon"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:path];
    
    if(fileExists){
        
    }else{
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}


+ (NSString *)pathForResource:(NSString *)relativePath InBundle:(NSBundle *)bundle{
    return [[(bundle == nil ? [NSBundle mainBundle] : bundle) resourcePath]
            stringByAppendingPathComponent:relativePath];
}

+ (NSString *)pathForResrouceInDocuments:(NSString *)relativePath{
    
    return [[ToolsUtlis documentPath] stringByAppendingPathComponent:relativePath];
}

+ (void)setUILabel:(UILabel *)myLabel withMaxFrame:(CGRect)maxFrame
          withText:(NSString *)theText usingVerticalAlign: (VerticalAlignment) vertAlign
{
    CGSize stringSize = [theText sizeWithFont:myLabel.font
                            constrainedToSize:maxFrame.size
                                lineBreakMode:myLabel.lineBreakMode];
    
    switch (vertAlign) {
        case VerticalAlignmentTop: // vertical align = top
            myLabel.frame = CGRectMake(myLabel.frame.origin.x,
                                       myLabel.frame.origin.y,
                                       myLabel.frame.size.width,
                                       stringSize.height
                                       );
            break;
            
        case VerticalAlignmentMiddle: // vertical align = middle
            // don't do anything, lines will be placed in vertical middle by default
            break;
            
        case VerticalAlignmentBottom: // vertical align = bottom
            myLabel.frame = CGRectMake(myLabel.frame.origin.x,
                                       (myLabel.frame.origin.y + myLabel.frame.size.height) - stringSize.height,
                                       myLabel.frame.size.width,
                                       stringSize.height
                                       );
            break;
        default:
            break;
    }
    
    myLabel.text = theText;
}

+ (void)setUILabel:(UILabel *)label fontSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGFloat fontSize = [font pointSize];
    CGFloat height = [label.text sizeWithFont:font
                            constrainedToSize:CGSizeMake(size.width, FLT_MAX)
                                lineBreakMode:NSLineBreakByCharWrapping].height;
    UIFont *newFont = font;
    
    //Reduce font size while too large, break if no height (empty string)
    while (height > size.height && height != 0) {
        fontSize--;
        newFont = [UIFont fontWithName:font.fontName size:fontSize];
        height = [label.text sizeWithFont:newFont
                        constrainedToSize:CGSizeMake(size.width, FLT_MAX)
                            lineBreakMode:NSLineBreakByWordWrapping].height;
    };
    
    // Loop through words in string and resize to fit
    //    for (NSString *word in [label.text componentsSeparatedByString:@""])
    //    {
    //        CGFloat width = [word sizeWithFont:newFont].width;
    //        while (width > size.width && width != 0) {
    //            fontSize--;
    //            newFont = [UIFont fontWithName:font.fontName size:fontSize];
    //            width = [word sizeWithFont:newFont].width;
    //        }
    //    }
    [label setFont:[UIFont systemFontOfSize:fontSize]];
}

+ (BOOL)isNetworkReachable
{
    return _networkStatus != NotReachable;
}

+ (BOOL)isNetworkReachableViaWiFi
{
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == ReachableViaWiFi);
}

/*!
 @brief     判断网络是否是2G/3G
 */
+ (BOOL)isNetworkReachableVia2G3G
{
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableVia2G ||
            [[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableVia3G);
}

+ (void)startNetworkNotifier
{
    [_reachablity startNotifier];
    
}

+ (BOOL)isAppFirstLoadTab:(NSInteger)index{
    NSString *firstLoadView = nil;
    
    switch (index) {
        case 1:
            firstLoadView = [[NSUserDefaults standardUserDefaults] stringForKey:FirstLoadView1];
            break;
        case 2:
            firstLoadView = [[NSUserDefaults standardUserDefaults] stringForKey:FirstLoadView2];
            break;
        case 3:
            firstLoadView = [[NSUserDefaults standardUserDefaults] stringForKey:FirstLoadView3];
            break;
        case 4:
            firstLoadView = [[NSUserDefaults standardUserDefaults] stringForKey:FirstLoadView4];
            break;
        default:
            break;
    }
    
    if (firstLoadView != nil) {
        return NO;
    }
    return YES;
}

+ (BOOL)isAppFirstLoaded
{
    NSString *savedVersionString = [[NSUserDefaults standardUserDefaults] stringForKey:DDGBundleVersionKey];
    if (savedVersionString == nil) return YES;
    // 比较是否第一次进入当前这个版本
    NSString *appVersionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    return ![savedVersionString isEqualToString:appVersionString];
}

+ (void)saveBundleVersion
{
    [[NSUserDefaults standardUserDefaults] setObject:[[[NSBundle mainBundle] infoDictionary]
                                                      objectForKey:(NSString *)kCFBundleVersionKey]
                                              forKey:DDGBundleVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)createNewSessionId
{
    return [NSString createUUID];
}
+ (NSString *)mobileResolution
{
    CGSize pixelBufferSize = [[[UIScreen mainScreen] currentMode] size];
    return [NSString stringWithFormat:@"%.0f*%.0f",pixelBufferSize.height,pixelBufferSize.width];
}

+ (NSDictionary *)getMobileNetworkPropertys
{
    NSMutableDictionary *returnDictionary = [[NSMutableDictionary alloc]init];
    CTTelephonyNetworkInfo *tni = [[CTTelephonyNetworkInfo alloc] init];
    [returnDictionary setValue:tni.subscriberCellularProvider.carrierName forKey:@"carrierName"];
    [returnDictionary setValue:tni.subscriberCellularProvider.mobileCountryCode forKey:@"mobileCountryCode"];
    
    return returnDictionary;
}

#pragma mark -
#pragma mark ==== 空对象处理函数 ====
#pragma mark -

+ (NSString *)replaceNilStringWithEmptyString:(id)stringIfNil
{
    static NSString *const emptyString = @"";
    return (stringIfNil == nil || stringIfNil == [NSNull null]) ? emptyString : stringIfNil;
}

+ (NSString *)replaceNilString:(id)stringIfNil withString:(NSString *)replaceString
{
    return (stringIfNil == nil || stringIfNil == [NSNull null]) ? replaceString : stringIfNil;
}


+ (id)replaceNilObjectWithNullObject:(id)objectIfNil
{
    return objectIfNil == nil ? [NSNull null] : objectIfNil;
}

+ (id)replaceNilObject:(id)objectIfNil withObject:(id)replaceObject
{
    return objectIfNil == nil ? replaceObject : objectIfNil;
}


// 从网络URL或者本地加载图片
+(UIImage*) getImgFromStr:(NSString*) strImg
{
    UIImage *img = nil;
    
    if (![ToolsUtlis isNetworkReachable]) {
        //[MBProgressHUD showErrorWithStatus:@"请检查网络" toView:self.view];
        return  img;
    }
    
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:strImg]];
    if (imgData)
     {
        // 从URL 加载图片
        img = [UIImage imageWithData:imgData];// 拿到image
     }
    else
     {
        // 从本地加载
        img = [UIImage imageNamed:strImg];
     }
    
    return  img;
}


// 计算字符长度和高度，根据frame 和 font
+  (CGSize) getSizeWithString:(NSString*) string withFrame:(CGRect) rect withFontSize:(int)fontSize
{
    CGSize titleSize = [string boundingRectWithSize:rect.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
    return titleSize;
}


#pragma mark ==== 画虚线 (宽度为1， 长度为任意)
+(UIImage *)imageWithLineWithImageView:(UIImageView *)imageView{
    CGFloat width = imageView.frame.size.width;
    CGFloat height = imageView.frame.size.height;
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, width, height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    int iWidht = 3;
    CGFloat lengths[] = {iWidht,5};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, [UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1.0].CGColor);
    CGContextSetLineDash(line, 0, lengths, 1);
    CGContextMoveToPoint(line, 0, 1);
    CGContextAddLineToPoint(line, width-iWidht, 1);
    CGContextStrokePath(line);
    return  UIGraphicsGetImageFromCurrentImageContext();
}

#pragma mark ==== 解决floalt类型，转换字符串时，丢失精度的问题. 转化为保留2位小数
+ (NSString *)getnumber:(id)numberId
{
    NSString *str = [NSString stringWithFormat:@"%@",numberId];
    if([str rangeOfString:@"."].length>0)
        
     {
        //return [NSString stringWithFormat:@"%g",str.floatValue];
        return [NSString stringWithFormat:@"%.2f",str.floatValue];
     }else
         
      {
         return str;
      }
}

@end
