//
//  RootViewController.h
//  CustomNavigationBarController
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseViewController : UIViewController <UIGestureRecognizerDelegate>

/*!
 @property  superViewForHud
 @brief		提示界面
 */
- (UIView *)superViewForHud;

/**
 *  当前viewController是否正在显示
 *
 *  @return YES表示显示，NO表示未显示
 */
- (BOOL)isVisible;

/**
 *  从后台进入前台的回调
 *
 *  @param notification 通知
 */
- (void)handleApplicationDidBecomeActiveNotification:(NSNotification *)notification;

@end

@interface BaseTableViewController : UITableViewController <UIGestureRecognizerDelegate>

/**
 *  从后台进入前台的回调
 *
 *  @param notification 通知
 */
- (void)handleApplicationDidBecomeActiveNotification:(NSNotification *)notification;


@end
