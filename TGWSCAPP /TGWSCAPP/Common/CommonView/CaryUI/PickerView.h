//
//  PickerView.h
//  JYApp
//
//  Created by xxjr02 on 16/6/2.
//  Copyright © 2016年 xxjr02. All rights reserved.
//

#import "BaseLineView.h"

@interface PickerView : BaseLineView
{
    NSString *_title;
    
    UIView *_backGroundView;   // 全尺寸的黑色半透明背景
    
    UIView *_itemView;
    
    float _titleWidth;
}

@property (nonatomic,strong) UILabel *holderLabel;

@property (nonatomic,strong) UIImageView *rightImage;

@property (nonatomic,strong) NSArray *itemsArray;

@property (nonatomic,strong) Block_Int finishedBlock;

@property (nonatomic,strong) Block_Void beginBlock;

@property (nonatomic, copy) NSString *placeHolder;

@property (nonatomic,assign) BOOL unnecessary;

@property (nonatomic,assign) int selectedIndex;

@property (nonatomic,assign) BOOL colorStyle;

// 默认为YES，跳页面时不需要显示，设置为NO
@property (nonatomic,assign) BOOL showPicker;

// 弹出框选择
-(PickerView *)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder itemArray:(NSArray *)items origin_Y:(CGFloat)origin_Y;

// 弹出框选择2 (placeHolder 靠右， 宽度可自定义)
-(PickerView *)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder  width:(int)width  itemArray:(NSArray *)items origin_Y:(CGFloat)origin_Y;

// 弹出框选择， 右侧带图片
-(PickerView *)initWithTitle:(NSString *)title imageName:(NSString*)imageName placeHolder:(NSString *)placeHolder itemArray:(NSArray *)items origin_Y:(CGFloat)origin_Y;
      
// 跳页面选择
-(PickerView *)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder origin_Y:(CGFloat)origin_Y;

// 跳页面选择(风格2， placeHolder靠右)
-(PickerView *)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder width:(int)width origin_Y:(CGFloat)origin_Y;

// 选择照片
-(PickerView *)initWithTitle:(NSString *)title placeHolderImage:(UIImage *)image origin_Y:(CGFloat)origin_Y;

-(void)showPickView;

-(void)setSelectedIndex:(int)selectedIndex;


// 弹出框选择，两边有距离
-(PickerView *)initWithTypeTitle:(NSString *)title placeHolder:(NSString *)placeHolder itemArray:(NSArray *)items layoutImagePicker:(BOOL)imgPicker origin_Y:(CGFloat)origin_Y origin_X:(CGFloat)origin_X;

// 跳页面选择，两边有距离
-(PickerView *)initWithTypeTitle:(NSString *)title placeHolder:(NSString *)placeHolder origin_Y:(CGFloat)origin_Y  origin_X:(CGFloat)origin_X;

@end
