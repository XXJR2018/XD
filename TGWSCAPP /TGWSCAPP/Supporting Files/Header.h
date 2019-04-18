//
//  Header.h
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/10.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_HEIGHT < 568.0)
#define IS_IPHONE_5_OR_LESS (IS_IPHONE && SCREEN_HEIGHT <= 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_HEIGHT == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_HEIGHT == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_HEIGHT == 736.0)
#define IS_IPHONE_6P_MORE (IS_IPHONE && SCREEN_HEIGHT >= 736.0)
#define IS_IPHONE_X_MORE (IS_IPHONE && SCREEN_HEIGHT >= 812.0)
// > iOS7
#define AtLeast_iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f ? NO : YES)

// iOS7
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f && [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)

// iOS8
#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0f && [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f)

// iOS9
#define iOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0f && [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f)

// iOS11
#define iOS11 ([[[UIDevice currentDevice] systemVersion] floatValue] < 12.0f && [[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0f)

// iOS11以下的系统
#define iOS11Less  ( [[[UIDevice currentDevice] systemVersion] floatValue] < 11.0f)

//状态栏高度
#define StatusBarHeight   [[UIApplication sharedApplication] statusBarFrame].size.height

// 是竖屏
#define SCREEN_IS_LANDSCAPE  UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])


#define kBorder 10
#define ScaleSize SCREEN_WIDTH/375.f
#define FixelScaleSize 375.f/750.f    // 美工切图的标准尺寸是 750*1134

#define NavHeight   (IS_IPHONE_X_MORE ? 88.f : 64.f)
#define TabbarHeight   (IS_IPHONE_X_MORE ? 83.f : 49.f)
#define TableViewEdgeOffset 20.f

#define CellSpaceReserved 10.f
#define CellHeight44 44.f
#define CellTitleFontSize 14.0

#define CornerRadius    4.0
#define LineHeight      0.60

// 设备屏幕的大小
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)



#endif /* Header_h */
