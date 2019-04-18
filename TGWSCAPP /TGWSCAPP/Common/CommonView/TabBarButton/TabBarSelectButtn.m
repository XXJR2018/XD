//
//  TabBarSelectButtn.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/11.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "TabBarSelectButtn.h"

@implementation TabBarSelectButtn

- (void)setSelectedState:(BOOL)selectedState
{
    _selectedState = selectedState;
    if (selectedState)
    {
        [self setTitleColor:_selectedTextColor forState:UIControlStateNormal];
        [self setBackgroundImage:_selectedBackgroundImage forState:UIControlStateNormal];
        [self setImage:_selectedImage forState:UIControlStateNormal];
        [self setBackgroundColor:_selectedBGColor];
    }
    else
    {
        [self setTitleColor:_normalTextColor forState:UIControlStateNormal];
        [self setBackgroundImage:_normalBackgroundImage forState:UIControlStateNormal];
        [self setImage:_normalImage forState:UIControlStateNormal];
        [self setBackgroundColor:_normalBGColor];
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
