//
//  CustomNavigationBarView.h
//  PMH.Views
//
//  Created by 登文 陈 on 14-7-30.
//  Copyright (c) 2014年 Paidui, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define Rect_88                          CGRectMake(0,0,SCREEN_WIDTH,88.f)
#define Rect_64                          CGRectMake(0,0,SCREEN_WIDTH,64.f)


/**
 *  展示类型
 */
typedef NS_ENUM(NSInteger, NavigationBarViewBackColor)
{
    /*!
     @brief
     */
    NavigationBarViewBackColorWhite,
    /*!
     @brief
     */
    NavigationBarViewBackColorBlack,
};


@interface CustomNavigationBarView : UIView


@property(nonatomic,strong) UILabel *titleLab;

@property(nonatomic,copy) NSString *title;

@property(nonatomic,copy) UIImage *leftImage;

@property(nonatomic,copy) UIImage *rightImage;

@property(nonatomic,assign) NavigationBarViewBackColor barColor;


-(id)initWithTitle:(NSString *)title withBackColorStyle:(NavigationBarViewBackColor)colorStyle;

-(id)initWithTitle:(NSString *)title withLeftButton:(UIButton *)leftButton withRightButton:(UIButton *)rightButton withBackColorStyle:(NavigationBarViewBackColor)colorStyle backdrop:(BOOL)isBackdrop;

-(id)initWithTitleImgView:(NSString *)imgString withLeftButton:(UIButton *)leftButton withRightButton:(UIButton *)rightButton withBackColorStyle:(NavigationBarViewBackColor)colorStyle;

-(id)initWithTitle:(NSString *)title withLeftButton:(UIButton *)leftButton;

@end
