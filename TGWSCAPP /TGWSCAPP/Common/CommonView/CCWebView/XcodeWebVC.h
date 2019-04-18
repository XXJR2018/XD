//
//  XcodeWebVC.h
//  XXStarshipApp
//
//  Created by xxjr02 on 2018/10/19.
//  Copyright © 2018 xxjr02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface XcodeWebVC : CommonViewController

@property (strong, nonatomic) NSString *homeUrl;
@property (strong, nonatomic) NSString *titleStr;

// 弹出页面形式 push or present
@property (nonatomic,assign) BOOL isPresent;

// 进入页面类型
@property (nonatomic,assign) NSString *jumpType;

@property (strong, nonatomic) WKWebView *wkWebView;

@end
