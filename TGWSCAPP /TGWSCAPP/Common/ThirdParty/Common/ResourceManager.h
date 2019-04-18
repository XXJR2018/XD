//
//  ResourseManager.h
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>

/*------------------  Font  ------------------------------*/

#define FontRoboto_Light            @"Roboto-Light"
#define FontRoboto_Medium           @"Roboto-Medium"


/*!
 @class ResourceManager
 @brief 资源管理，包含除语言资源外所有资源， 用于统一管理app所用的字体/大小/颜色等信息， 包含不需要缓存的图片
 */
@interface ResourceManager : NSObject

+ (UIImage *)imageWithImageName:(NSString *)imageName;
+ (UIImage *)imageWithImageName:(NSString *)imageName type:(NSString *)imageType;



+ (UIImage *)logo;
/*
 *@brief  导航条背景图片
 */
+ (UIImage *)naviBack_Img;
/*
 *@brief  箭头
 */
+ (UIImage *)arrow_left;

+ (UIImage *)arrow_right;

+ (UIImage *)arrow_down;

+ (UIImage *)arrow_up;

+ (UIImage *)arrow_return;

/*------------------  Common  ------------------------------*/
/*
 *@brief   close
 */
+ (UIImage *)close;
/*
 *@brief   icon_out
 */
+ (UIImage *)icon_out;
/*
 *@brief   calculator
 */
+ (UIImage *)calculator;


/*
 *@brief   tabBar
 */
+ (UIImage *)tabBar_button1_gray;

+ (UIImage *)tabBar_button1_selected;

+ (UIImage *)tabBar_button2_gray;

+ (UIImage *)tabBar_button2_selected;

+ (UIImage *)tabBar_button3_gray;

+ (UIImage *)tabBar_button3_selected;

+ (UIImage *)tabBar_button4_gray;

+ (UIImage *)tabBar_button4_selected;



#pragma mark -
#pragma mark ==== 通用字体 ====
#pragma mark -
+ (UIFont *)font_1;

+ (UIFont *)font_2;

+ (UIFont *)font_3;

+ (UIFont *)font_4;

+ (UIFont *)font_5;

+ (UIFont *)font_6;

+ (UIFont *)font_7;

+ (UIFont *)font_8;

+ (UIFont *)font_9;

+ (UIFont *)font_10;

/*
 导航栏标题字体，左右两边按钮字体  19
 */
+ (UIFont *)navgationTitleFont;

/*
 cell文本标题
 */
+ (UIFont *)fontCellTitle;

/*
 cell文本副标题
 */
+ (UIFont *)fontCellSubtitle;

/*
 icon大标题  (主标题)
 */
+ (UIFont *)fontTitle;



#pragma mark -
#pragma mark ==== 颜色 ====
#pragma mark -

/*
 导航栏标题字体颜色，左右两边按钮字体颜色  0x000000
 */
+ (UIColor *)navgationTitleColor;

/*
 导航栏背景颜色  0x141d26
 */
+ (UIColor *)navgationBackGroundColor;

/*
 页面背景颜色  F7F8F0
 */
+ (UIColor *)viewBackgroundColor;


// 主色调
+ (UIColor *) mainColor;

// 价格的颜色
+ (UIColor *) priceColor;

// 提示语颜色
+ (UIColor *)color_0;


// backgroundColor_1  titleColor_1
+ (UIColor *)color_1;

// backgroundColor_3  lineColor_3
+ (UIColor *)color_2;

// backgroundColor_2 lineColor_2
+ (UIColor *)color_3;

+ (UIColor *)color_4;

/********************  分割线用色 ********************/
// lineColor_1
+ (UIColor *)color_5;

/******************** 文字用色 ********************/
// titleColor_2
+ (UIColor *)color_6;

// titleColor_3
+ (UIColor *)color_7;

+ (UIColor *)color_8;

// titleColor_4
+ (UIColor *)color_9;

// titleColor_5
+ (UIColor *)color_10;

/*!
 @brief cell标题的颜色 #434343
 */
+ (UIColor *)CellTitleColor;

/*!
 @brief cell标题的颜色 #959595
 */
+ (UIColor *)CellSubTitleColor;

/**
 *  红色 1
 */
+ (UIColor *)redColor1;

/**
 *  红色 2
 */
+ (UIColor *)redColor2;

/**
 *  绿色
 */
+ (UIColor *)greenColor;


/******************** 副色调 ********************/

/**
 *  青色  #1cbd95
 */
+ (UIColor *)cyanColor;

/**
 *  橙色  #f78600
 */
+ (UIColor *)orangeColor;

/**
 *  蓝色  0x074f96
 */
+ (UIColor *)blueColor;

/**
 *  黄色  0x3b96ff
 */
+ (UIColor *)yellowColor;

/**
 *  淡淡灰的  #0xf1f1f1    首页cell的分割线
 */
+ (UIColor *)superLightGrayColor;

/**
 *  浅灰的  #0xeaeaea
 */
+ (UIColor *)lightGrayColor;

/**
 *  中度灰的  #0xd6d6d6
 */
+ (UIColor *)midGrayColor;

/**
 *  黑灰的  #0x2f3b4b
 */
+ (UIColor *)blackGrayColor;

/**
 *  浅黑色  #333333
 */
+ (UIColor *)lightBlackColor;



+(UIColor *)TishiColor;
+(UIColor *)daohangColor;
+(UIColor *)anjianColor;
+(UIColor *)yanzhengColor;
+(UIColor *)f98f5d;
+(UIColor *)fbb7a7;



@end
