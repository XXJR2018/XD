//
//  PDInfoCoverView.h
//  PMH.Common
//
//  Created by qiu lijian on 13-7-24.
//  Copyright (c) 2013年 Paidui, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kInfoCoverButtonPadding 50

/**
 *  信息状态界面基类
 */
@class DDGInfoCoverView;

/*!
 @class DDGInfoCoverView
 @brief 提示信息
 */
@interface XXJRInfoCoverView : UIView
/*!
 @brief     按钮方法
 */
@property (nonatomic, copy) void(^buttonPressedEvent)() ;
/*!
 @brief     按钮
 */
@property (nonatomic, strong) UIButton *button;
/*!
 @brief     提示信息
 */
@property (nonatomic, strong) UILabel *textLabel;
/*!
 @brief     背景图片
 */
@property (nonatomic, strong) UIImageView *backgroundView;
/*!
 @brief    初始化
 */
- (void)setup;
/*!
 @brief    显示
 */
+ (BOOL)isShowingInView:(UIView *)superView;
/*!
 @brief    显示
 */
+ (id)showInView:(UIView *)superView;
/*!
 @brief    消失
 */
+ (void)dismissInView:(UIView *)view;


@end
