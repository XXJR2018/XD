//
//  RangeSliderView.m
//  JYApp
//
//  Created by xxjr02 on 16/6/2.
//  Copyright © 2016年 xxjr02. All rights reserved.
//

#import "RangeSliderView.h"
#import "TTRangeSlider.h"
@implementation RangeSliderView

- (instancetype)initWithTitle:(NSString *)title origin_Y:(float)origin_Y
{
    self = [super initWithFrame:CGRectMake(0, origin_Y, SCREEN_WIDTH, 80.0)];
    if (self) {
        
//        self.backgroundColor = RandomColor;
        
        UIFont *font = [UIFont systemFontOfSize:13.0];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 4, SCREEN_WIDTH - 200, CellTitleFontSize)];
        _titleLabel.font = font;
        _titleLabel.text = title;
        _titleLabel.textColor = [ResourceManager CellSubTitleColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 25, SCREEN_WIDTH - 200, 20.0)];
        _subTitleLabel.font = [UIFont systemFontOfSize:20.0];
        _subTitleLabel.textColor = [ResourceManager redColor1];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_subTitleLabel];
        
        _slider = [[TTRangeSlider alloc]initWithFrame:CGRectMake(0.f, 45.0, SCREEN_WIDTH , 20.0)];
        _slider.delegate = self;
        [self addSubview:_slider];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
        _slider.numberFormatterOverride = formatter;
    }
    return self;
}

-(void)setSliderModel:(SliderModel *)sliderModel{
    _sliderModel = sliderModel;
    
    _slider.minValue = sliderModel.minValue;
    _slider.maxValue = sliderModel.maxValue;
    _slider.selectedMinimum = sliderModel.selectedMinimum;
    _slider.selectedMaximum = sliderModel.selectedMaximum;
    _slider.disableRange = sliderModel.showLeftHandle;
    
    _titleLabel.text = [NSString stringWithFormat:@"%@(%@)",_titleLabel.text,_sliderModel.unit];
    _subTitleLabel.text = [NSString stringWithFormat:@"%d",_sliderModel.selectedMaximum*_sliderModel.unitValue];
    if (sliderModel.slideColor) {
         _slider.tintColor = sliderModel.slideColor;
        
    }
    
    
    _viewInited = YES;
}

#pragma mark TTRangeSliderViewDelegate
-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum{
    
    int minimum = (int)selectedMinimum , maximum = (int)selectedMaximum;
    
    if (_viewInited) {
        _sliderModel.selectedMinimum = minimum;
        _sliderModel.selectedMaximum = maximum;
    }
    
    _subTitleLabel.text = [NSString stringWithFormat:@"%d",maximum*_sliderModel.unitValue];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation SliderModel


@end
