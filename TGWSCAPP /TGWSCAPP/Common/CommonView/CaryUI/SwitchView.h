//
//  SwitchView.h
//  JYApp
//
//  Created by xxjr02 on 16/6/3.
//  Copyright © 2016年 xxjr02. All rights reserved.
//

#import "BaseLineView.h"

@interface SwitchView : BaseLineView
{
    UISwitch *_switchView;
}
@property (nonatomic,assign) BOOL switchOn;

@property (nonatomic,strong) Block_Bool switchBlock;

-(SwitchView *)initWithTitle:(NSString *)title origin_Y:(float)origin_Y;

@end
