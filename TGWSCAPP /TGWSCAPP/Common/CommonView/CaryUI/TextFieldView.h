//
//  TextFieldView.h
//  JYApp
//
//  Created by xxjr02 on 16/6/2.
//  Copyright © 2016年 xxjr02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseLineView.h"

typedef enum {
    TextFieldViewDefault,
    TextFieldViewNumber,
    TextFieldViewCode,
    TextFieldViewEmail
}TextFieldViewType;

@interface TextFieldView :BaseLineView<UITextFieldDelegate>
{
    float _titleWidth;
    
}

@property (nonatomic,strong) UITextField *textField;

@property (nonatomic,assign) BOOL unnecessary;

//文字
-(TextFieldView *)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder originY:(CGFloat)originY fieldViewType:(TextFieldViewType)type;

//文字 (风格2, placeHolder可选择方向， 宽度可以自定义)
-(TextFieldView *)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder  textAlignment:(NSTextAlignment)textAlignment  width:(int)width  originY:(CGFloat)originY fieldViewType:(TextFieldViewType)type;

//标题带图片的样式
-(TextFieldView *)initWithImageName:(NSString *)imageName  withTitle:(NSString *)title placeHolder:(NSString *)placeHolder originY:(CGFloat)originY  fieldViewType:(TextFieldViewType)type;

//标题带图片的样式， 并且带单位
-(TextFieldView *)initWithImageName:(NSString *)imageName  withTitle:(NSString *)title  unitStr:(NSString *)unitStr placeHolder:(NSString *)placeHolder originY:(CGFloat)originY  fieldViewType:(TextFieldViewType)type;

//图片
-(TextFieldView *)initWithImageName:(NSString *)imageName placeHolder:(NSString *)placeHolder atIndex:(int)index fieldViewType:(TextFieldViewType)type;



//两边有距离 文本颜色 后面单位 初始位置
-(TextFieldView *)initWithTitle:(NSString *)title unitStr:(NSString *)unitStr textColor:(UIColor *)color placeHolder:(NSString *)placeHolder originY:(CGFloat)originY originX:(CGFloat)originX  fieldViewType:(TextFieldViewType)type;

@end
