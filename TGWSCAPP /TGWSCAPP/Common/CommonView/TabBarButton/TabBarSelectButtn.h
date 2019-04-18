//
//  TabBarSelectButtn.h
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/11.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TabBarSelectButtn : UIButton
/*!
 @brief 状态
 */
@property (nonatomic, assign) BOOL selectedState;


/**
 *  选中图片
 */
@property (nonatomic, retain) UIImage *normalImage;
/**
 *  选中图片
 */
@property (nonatomic, retain) UIImage *selectedImage;


/**
 *  选中背景图片
 */
@property (nonatomic, retain) UIImage *selectedBackgroundImage;

/**
 *  正常状态图片
 */
@property (nonatomic, retain) UIImage *normalBackgroundImage;


/**
 *  选中文字颜色
 */
@property (nonatomic, retain) UIColor *selectedTextColor;
/**
 *  文字颜色
 */
@property (nonatomic, retain) UIColor *normalTextColor;


/**
 *  选中背景颜色
 */
@property (nonatomic, retain) UIColor *selectedBGColor;
/**
 *  背景颜色
 */
@property (nonatomic, retain) UIColor *normalBGColor;
@end

NS_ASSUME_NONNULL_END
