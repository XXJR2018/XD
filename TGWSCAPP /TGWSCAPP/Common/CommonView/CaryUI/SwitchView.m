//
//  SwitchView.m
//  JYApp
//
//  Created by xxjr02 on 16/6/3.
//  Copyright © 2016年 xxjr02. All rights reserved.
//

#import "SwitchView.h"

@implementation SwitchView

-(SwitchView *)initWithTitle:(NSString *)title origin_Y:(float)origin_Y{
    self = [super initWithFrame:CGRectMake(0, origin_Y, SCREEN_WIDTH, CellHeight44)];
    if (self) {
        self.linetype = LineTypeBotton;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CellSpaceReserved, (CellHeight44 - CellTitleFontSize)/2, 130.0, CellTitleFontSize)];
        label.font = [UIFont systemFontOfSize:14.0];
        label.text = title;
        label.textColor = [ResourceManager color_7];
        label.textAlignment = NSTextAlignmentLeft;
        [self addSubview:label];
        
        _switchView = [[UISwitch alloc] initWithFrame:CGRectMake(self.width - 70, 5, 55, 30)];
//        switchView.on = YES;
        _switchView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        [_switchView  addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_switchView];
    }
    return self;
}

-(void)switchAction:(UISwitch *)switchView{
    
    _switchOn = switchView.on;
    
    if (_switchBlock) {
        _switchBlock(switchView.on);
    }
}

-(void)setSwitchOn:(BOOL)switchOn{
    
    _switchOn = switchOn;
    
    _switchView.on = _switchOn;
    
    [self switchAction:_switchView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
