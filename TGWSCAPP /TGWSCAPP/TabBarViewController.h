//
//  TabBarViewController.h
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/10.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TabViewController_1.h"
#import "TabViewController_2.h"
#import "TabViewController_3.h"
#import "TabViewController_4.h"

#import "TabBarSelectButtn.h"

NS_ASSUME_NONNULL_BEGIN

@interface TabBarViewController : UITabBarController

/*!
 @brief     当前控制器
 */
@property (nonatomic, strong) UINavigationController *homeViewController;

/**
 *  按钮视图
 */
@property (strong, nonatomic)  UIView *buttonsView;


@property (strong, nonatomic)  TabBarSelectButtn *tab1_Button;
@property (strong, nonatomic)  TabBarSelectButtn *tab2_Button;
@property (strong, nonatomic)  TabBarSelectButtn *tab3_Button;
@property (strong, nonatomic)  TabBarSelectButtn *tab4_Button;

/**
 *  点击按钮
 */
- (void)setButtonsState:(id)sender;

@end

NS_ASSUME_NONNULL_END
