//
//  AppDelegate.h
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/7.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/*!
 @brief     根控制器
 */
@property (nonatomic, strong) TabBarViewController *tabBarRootViewController;

@property (nonatomic, strong) UIViewController *rootViewController;

@end

