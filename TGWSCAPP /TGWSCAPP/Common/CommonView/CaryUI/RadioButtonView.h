//
//  RadioButtonView.h
//  JYApp
//
//  Created by xxjr02 on 16/6/2.
//  Copyright © 2016年 xxjr02. All rights reserved.
//

#import "BaseLineView.h"

@interface RadioButtonView : BaseLineView
{
    UIButton *_selectedButton;
}

@property (nonatomic,strong) Block_Int finishedBlock;

@property (nonatomic,assign) int selectedIndex;

-(RadioButtonView *)initWithTitle:(NSString *)title item1:(NSString *)item1 item2:(NSString *)item2 origin_Y:(CGFloat)origin_Y;

-(RadioButtonView *)initWithTitle:(NSString *)title items:(NSArray *)items origin_Y:(CGFloat)origin_Y;

-(void)setSelectedIndex:(int)selectedIndex;

@end
