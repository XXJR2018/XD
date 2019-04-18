//
//  RadioButtonView.m
//  JYApp
//
//  Created by xxjr02 on 16/6/2.
//  Copyright © 2016年 xxjr02. All rights reserved.
//

#import "RadioButtonView.h"

@implementation RadioButtonView

-(RadioButtonView *)initWithTitle:(NSString *)title item1:(NSString *)item1 item2:(NSString *)item2 origin_Y:(CGFloat)origin_Y{
    self = [super initWithFrame:CGRectMake(0, origin_Y, SCREEN_WIDTH, CellHeight44)];
    if (self) {
        self.linetype = LineTypeBotton;
        
        UIFont *font = [UIFont systemFontOfSize:14.0];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CellSpaceReserved, (CellHeight44 - CellTitleFontSize)/2, 130.0, CellTitleFontSize)];
        label.font = font;
        label.text = title;
        label.textColor = [ResourceManager color_7];
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        
        CGSize size = [item1 sizeWithAttributes:@{NSFontAttributeName:font}];
        float buttonWidth = 25 + size.width;
        CGSize size2 = [item2 sizeWithAttributes:@{NSFontAttributeName:font}];
        float buttonWidth2 = 25 + size2.width;
        
        UIButton *button_1 = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - buttonWidth - buttonWidth2 - 12.0 - 20.0, 10, buttonWidth, 25)];
        [button_1 setImage:[UIImage imageNamed:@"select_no"] forState:UIControlStateNormal];
        [button_1 setImage:[UIImage imageNamed:@"select_yes"] forState:UIControlStateSelected];
        [button_1 setTitle:item1 forState:UIControlStateNormal];
        [button_1 setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
        button_1.imageEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 0);
        button_1.titleEdgeInsets  = UIEdgeInsetsMake(0, 0, 0, -4);
        button_1.titleLabel.font = font;
        button_1.selected = YES;
        button_1.tag = (int)1200;
        [button_1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button_1];
        
        UIButton *button_2 = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - buttonWidth2 - 12.0, 10, buttonWidth2, 25)];
        [button_2 setImage:[UIImage imageNamed:@"select_no"] forState:UIControlStateNormal];
        [button_2 setImage:[UIImage imageNamed:@"select_yes"] forState:UIControlStateSelected];
        [button_2 setTitle:item2 forState:UIControlStateNormal];
        [button_2 setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
        button_2.imageEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 0);
        button_2.titleEdgeInsets  = UIEdgeInsetsMake(0, 0, 0, -4);
        button_2.titleLabel.font = font;
        button_2.tag = (int)1201;
        [button_2 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button_2];
        
        _selectedButton = button_1;
        
//        button_1.backgroundColor = RandomColor;
//        button_2.backgroundColor = RandomColor;
    }
    return self;
}

-(RadioButtonView *)initWithTitle:(NSString *)title items:(NSArray *)items origin_Y:(CGFloat)origin_Y{
    self = [super initWithFrame:CGRectMake(0, origin_Y, SCREEN_WIDTH, 70.0)];
    if (self) {
//        self.linetype = LineTypeBotton;
        
        UIFont *font = [UIFont systemFontOfSize:14.0];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CellSpaceReserved, (CellHeight44 - CellTitleFontSize)/2, 130.0, CellTitleFontSize)];
        label.font = font;
        label.text = title;
        label.textColor = [ResourceManager color_7];
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        
        float totalWidth = 0.0;
        for (int i = 0; i < items.count; i ++) {
            CGSize size = [items[i] sizeWithAttributes:@{NSFontAttributeName:font}];
            float buttonWidth = 20 + size.width;
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CellSpaceReserved + 15.0*i + totalWidth - 2.0, CGRectGetMaxY(label.frame) + 10.0, buttonWidth, 25)];
            [button setImage:[UIImage imageNamed:@"select_no"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"select_yes"] forState:UIControlStateSelected];
            [button setTitle:items[i] forState:UIControlStateNormal];
            [button setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
            button.imageEdgeInsets = UIEdgeInsetsMake(0, -3, 0, 0);
            button.titleEdgeInsets  = UIEdgeInsetsMake(0, 0, 0, -4);
            button.titleLabel.font = font;
            if (i == 0) {
                button.selected = YES;
                _selectedButton = button;
            }
            
            button.tag = (int)1200 + i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            totalWidth += buttonWidth;
        }
    }
    return self;
}

-(void)setSelectedIndex:(int)selectedIndex{
    _selectedIndex = selectedIndex;
    
    // 获取相应button
    UIButton *button = (UIButton *)[self viewWithTag:1200 + selectedIndex];
    if (button) {
        [self buttonClick:button];
    }
}

-(void)buttonClick:(UIButton *)button{
    if (button == _selectedButton) {
        return;
    }
    
    _selectedButton.selected = NO;
    button.selected = YES;
    
    _selectedButton = button;
    
    _selectedIndex = (int)_selectedButton.tag - 1200;
    
    if (_finishedBlock) {
        _finishedBlock((int)(_selectedButton.tag - 1200));
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
