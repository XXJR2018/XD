//
//  CCWebViewController.h
//  WebViewDemo
//
//  Created by dangxy on 16/9/6.
//  Copyright © 2016年 xproinfo.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebviewProgressLine.h"
@interface CCWebViewController : CommonViewController

@property (strong, nonatomic) NSURL *homeUrl;
@property (strong, nonatomic) NSString *titleStr;

// 弹出页面形式 push or present
@property (nonatomic,assign) BOOL isPresent;

/** 传入控制器、url、标题 */
+ (void)showWithContro:(UIViewController *)contro withUrlStr:(NSString *)urlStr withTitle:(NSString *)title;

@end

