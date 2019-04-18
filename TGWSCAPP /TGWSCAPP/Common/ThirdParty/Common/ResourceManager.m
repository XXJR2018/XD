//
//  ResourseManager.m
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import "ResourceManager.h"

#define Font_Hiragino_Sans_GB_W3            @"Hiragino Kaku Gothic ProN-Bold"


@implementation ResourceManager

static  NSString *GetAdaptImage(NSString *imageName){
    NSMutableString *realFileName;
    if (IS_IPHONE_4_OR_LESS) {
        realFileName = [NSMutableString stringWithString:imageName];
    }else if (IS_IPHONE_5 || IS_IPHONE_6){
        realFileName = [NSMutableString stringWithFormat:@"%@@2x",imageName];
    }else if (IS_IPHONE_6P){
        realFileName = [NSMutableString stringWithFormat:@"%@@3x",imageName];
    }
    return realFileName;
}

// images.xcassets 里的文件是不在ipa包的根目录下的,这里的图都不是以图片格式存储在程序包里.而是以文件形式储存在Assets.car文件中,所以是不存在文件目录的
+ (UIImage *)imageWithImageName:(NSString *)imageName{
    NSString *path = [[NSBundle mainBundle] pathForResource:GetAdaptImage(imageName) ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
}

+ (UIImage *)imageWithImageName:(NSString *)imageName type:(NSString *)imageType{
    NSString *path = [[NSBundle mainBundle] pathForResource:GetAdaptImage(imageName) ofType:imageType];
    return [UIImage imageWithContentsOfFile:path];
}

+ (UIImage *)logo{
    return [UIImage imageNamed:@"logo"];
}

/*
 *@brief  导航条背景图片
 */
+ (UIImage *)naviBack_Img{
    return [UIImage imageNamed:@""];
}
/*
 *@brief  箭头
 */
+ (UIImage *)arrow_left{
    return [UIImage imageNamed:@"arrow_right"];
}

+ (UIImage *)arrow_right{
    static UIImage *image;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        image = [UIImage imageNamed:@"arrow_right"];
    });
    return image;
}

+ (UIImage *)arrow_down{
    return [UIImage imageNamed:@"arrow_down"];
}

+ (UIImage *)arrow_up{
    return [UIImage imageNamed:@"arrow_up"];
}

+ (UIImage *)arrow_return{
    return [UIImage imageNamed:@"return"];
}



/*------------------------------------------------*/
/*
 *@brief   close
 */
+ (UIImage *)close{
    return [UIImage imageNamed:@"close"];
}

/*
 *@brief   icon_out
 */
+ (UIImage *)icon_out{
    return [UIImage imageNamed:@"icon_out"];
}

/*
 *@brief   calculator
 */
+ (UIImage *)calculator{
    return [UIImage imageNamed:@"Earnings-calculator"];
}

/*
 *@brief   tabBar
 */
+ (UIImage *)tabBar_button1_gray{
    return [UIImage imageNamed:@"Tabbar_1"];
}

+ (UIImage *)tabBar_button1_selected{
    return [UIImage imageNamed:@"Tabbar_1_Highlight"];
}

/*
 *@brief   tabBar
 */
+ (UIImage *)tabBar_button2_gray{
    return [UIImage imageNamed:@"Tabbar_2"];
}

+ (UIImage *)tabBar_button2_selected{
    return [UIImage imageNamed:@"Tabbar_2_Highlight"];
}
/*
 *@brief   tabBar
 */
+ (UIImage *)tabBar_button3_gray{
    return [UIImage imageNamed:@"Tabbar_3"];
}

+ (UIImage *)tabBar_button3_selected{
    return [UIImage imageNamed:@"Tabbar_3_Highlight"];
}

/*
 *@brief   tabBar
 */
+ (UIImage *)tabBar_button4_gray{
    return [UIImage imageNamed:@"Tabbar_4"];
}

+ (UIImage *)tabBar_button4_selected{
    return [UIImage imageNamed:@"Tabbar_4_Highlight"];
}





/********************************通用字体*******************************/
static int fontAtIndex(int index){
    int fontSize = 24.f;
    switch (index) {
        case 1:
            fontSize = 80.f;
            break;
        case 2:
            fontSize = 50.f;
            break;
        case 3:
            fontSize = 44.f;
            break;
        case 4:
            fontSize = 34.f;
            break;
        case 5:
            fontSize = 30.f;
            break;
        case 6:
            fontSize = 28.f;
            break;
        case 7:
            fontSize = 26.f;
            break;
        case 8:
            fontSize = 24.f;
            break;
        case 9:
            fontSize = 22.f;
            break;
        case 10:
            fontSize = 20.f;
            break;
        default:
            break;
    }
    return fontSize * 0.5f;
}

+ (UIFont *)font_1
{
    static UIFont *font;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        font = [UIFont systemFontOfSize:fontAtIndex(1)];
    });
    return font;
}

+ (UIFont *)font_2
{
    static UIFont *font;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        font = [UIFont systemFontOfSize:fontAtIndex(2)];
    });
    return font;
}

+ (UIFont *)font_3
{
    static UIFont *font;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        font = [UIFont systemFontOfSize:fontAtIndex(3)];
    });
    return font;
}

+ (UIFont *)font_4
{
    static UIFont *font;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        font = [UIFont systemFontOfSize:fontAtIndex(4)];
    });
    return font;
}

+ (UIFont *)font_5
{
    static UIFont *font;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        font = [UIFont systemFontOfSize:fontAtIndex(5)];
    });
    return font;
}

+ (UIFont *)font_6
{
    static UIFont *font;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        font = [UIFont systemFontOfSize:fontAtIndex(6)];
    });
    return font;
}

+ (UIFont *)font_7
{
    static UIFont *font;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        font = [UIFont systemFontOfSize:fontAtIndex(7)];
    });
    return font;
}

+ (UIFont *)font_8
{
    static UIFont *font;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        font = [UIFont systemFontOfSize:fontAtIndex(8)];
    });
    return font;
}

+ (UIFont *)font_9
{
    static UIFont *font;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        font = [UIFont systemFontOfSize:fontAtIndex(9)];
    });
    return font;
}

+ (UIFont *)font_10
{
    static UIFont *font;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        font = [UIFont systemFontOfSize:fontAtIndex(10)];
    });
    return font;
}


/*
 导航栏标题字体，左右两边按钮字体  19
 */
+ (UIFont *)navgationTitleFont
{
    static UIFont *font;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        font = [UIFont systemFontOfSize:19.0];
    });
    return font;
}

/*
 cell文本标题
 */
+ (UIFont *)fontCellTitle{
    static UIFont *font;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //        font = [UIFont fontWithName:Font_Hiragino_Sans_GB_W3 size:13.f];
        font = [UIFont systemFontOfSize:13.f];
    });
    return font;
}

/*
 cell文本副标题
 */
+ (UIFont *)fontCellSubtitle{
    static UIFont *font;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //        font = [UIFont fontWithName:Font_Hiragino_Sans_GB_W3 size:10.f];
        font = [UIFont systemFontOfSize:10.f];
    });
    return font;
}

/*
 icon大标题
 */
+ (UIFont *)fontTitle{
    static UIFont *font;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        font = [UIFont fontWithName:@"Arial" size:16.f];
    });
    return font;
}

/*
 主要的font
 */
+ (UIFont *)mainFont{
    static UIFont *font;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        font = [UIFont systemFontOfSize:14.f];
    });
    return font;
}


#pragma mark -
#pragma mark ==== 颜色 ====
#pragma mark -
/*
 导航栏标题字体颜色，左右两边按钮字体颜色  0xffffff
 */
+ (UIColor *)navgationTitleColor
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0x333333);
    });
    return color;
}

/*
 导航栏背景颜色  0x3b96ff
 */
+ (UIColor *)navgationBackGroundColor
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xffffff);
    });
    return color;
}

static int colorAtIndex(int index){
    switch (index) {
        case 0:
            return 0xcdcdd1;
            break;
        case 1:
            return 0x333333;
            break;
        case 2:
            return 0xf9f9f9; // EFEFEF
            break;
        case 3:
            return 0xEFEFEF;
            break;
        case 4:
            return 0xe1dede;
            break;
        case 5:
            return 0xdedfe0;
            break;
        case 6:
            return 0x9a9a9a;
            break;
        case 7:
            return 0x585858;
            break;
        case 8:
            return 0x333333;
            break;
        case 9:
            return 0xf9621e;
            break;
        case 10:
            return 0xf78600;
            break;
        default:
            break;
    }
    return 0xebebf4;
}

/******************** 副色调 ********************/
/**
 *  红色 1
 */
+ (UIColor *)redColor1
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xf98f69);
    });
    return color;
}

/**
 *  红色 2
 */
+ (UIColor *)redColor2
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xF86931);
    });
    return color;
}

/**
 *  绿色
 */
+ (UIColor *)greenColor
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0x298829);
    });
    return color;
}

/**
 *  青色  #1cbd95
 */
+ (UIColor *)cyanColor{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xf78600);
    });
    return color;
}

/**
 *  橙色  #f78600
 */
+ (UIColor *)orangeColor{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xf78600);
    });
    return color;
}

/**
 *  蓝色  0x3b96ff
 */
+ (UIColor *)blueColor{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0x3b96ff);
    });
    return color;
}

/**
 *  黄色  0x3b96ff
 */
+ (UIColor *)yellowColor{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xFABD4C);
    });
    return color;
}


/********************  背景用色 ********************/
/*
 页面背景颜色  #ebebf4
 */
+ (UIColor *)viewBackgroundColor
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xf7f7f7);
    });
    return color;
}


// 主色调
+ (UIColor *) mainColor
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0x9C0000);
    });
    return color;
}

// 价格的颜色
+ (UIColor *) priceColor
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0x9f1421);
    });
    return color;
}
// 提示语颜色
+ (UIColor *)color_0
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(colorAtIndex(0));
    });
    return color;
}

// backgroundColor_1  titleColor_1
+ (UIColor *)color_1
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(colorAtIndex(1));
    });
    return color;
}

// backgroundColor_3  lineColor_3
+ (UIColor *)color_2
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(colorAtIndex(2));
    });
    return color;
}

// backgroundColor_2 lineColor_2
+ (UIColor *)color_3
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(colorAtIndex(3));
    });
    return color;
}

+ (UIColor *)color_4
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(colorAtIndex(4));
    });
    return color;
}

/********************  分割线用色 ********************/
// lineColor_1
+ (UIColor *)color_5
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(colorAtIndex(5));
    });
    return color;
}

/******************** 文字用色 ********************/
// titleColor_2
+ (UIColor *)color_6{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(colorAtIndex(6));
    });
    return color;
}

// titleColor_3
+ (UIColor *)color_7{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(colorAtIndex(7));
    });
    return color;
}

+ (UIColor *)color_8
{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(colorAtIndex(8));
    });
    return color;
}

// titleColor_4
+ (UIColor *)color_9{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(colorAtIndex(9));
    });
    return color;
}

// titleColor_5
+ (UIColor *)color_10{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(colorAtIndex(10));
    });
    return color;
}


/*!
 @brief cell标题的颜色 #434343
 */
+ (UIColor *)CellTitleColor{
    return UIColorFromRGB(0x434343);
}

/*!
 @brief cell副标题的颜色 #959595
 */
+ (UIColor *)CellSubTitleColor{
    return UIColorFromRGB(0x959595);
}

/******************** 图标用色 ********************/
+ (UIColor *)iconColor_1{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(colorAtIndex(1));
    });
    return color;
}

+ (UIColor *)iconColor_2{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(colorAtIndex(5));
    });
    return color;
}

+ (UIColor *)iconColor_3{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(colorAtIndex(9));
    });
    return color;
}

/**
 *  淡淡灰的  #0xf1f1f1    首页cell的分割线
 */
+ (UIColor *)superLightGrayColor{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xf1f1f1);
    });
    return color;
}

/**
 *  浅灰的  #c3c3c3
 */
+ (UIColor *)lightGrayColor{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xc3c3c3);
    });
    return color;
}

/**
 *  中度灰的  #0x666666
 */
+ (UIColor *)midGrayColor{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0x666666);
    });
    return color;
}
/**
 *  黑灰的  #0x2f3b4b
 */
+ (UIColor *)blackGrayColor{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0x676767);
    });
    return color;
}

/**
 *  浅黑色(重灰色)  #333333
 */
+ (UIColor *)lightBlackColor{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0x333333);
    });
    return color;
}


+ (UIColor *)TishiColor{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xcfcfcf);
    });
    return color;
}
+ (UIColor *)daohangColor{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xfc6923);
    });
    return color;
}
+ (UIColor *)anjianColor{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xfc7637);
    });
    return color;
}
+ (UIColor *)yanzhengColor{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0x349feb);
    });
    return color;
}

+ (UIColor *)f98f5d{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xf98f5d);
    });
    return color;
}
+ (UIColor *)fbb7a7{
    static UIColor *color;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = UIColorFromRGB(0xfbb7a7);
    });
    return color;
}

@end
