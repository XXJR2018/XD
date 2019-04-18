//
//  RangeSliderView.h
//  JYApp
//
//  Created by xxjr02 on 16/6/2.
//  Copyright © 2016年 xxjr02. All rights reserved.
//

#import "BaseLineView.h"
#import "TTRangeSlider.h"

@class SliderModel;

@interface RangeSliderView : BaseLineView<TTRangeSliderDelegate>
{
    UILabel *_titleLabel;
    UILabel *_subTitleLabel;
    
    BOOL _viewInited;
}

@property (nonatomic,strong) TTRangeSlider *slider;

/// slider 属性设置
@property (nonatomic,strong) SliderModel *sliderModel;

- (instancetype)initWithTitle:(NSString *)title origin_Y:(float)origin_Y;

@end


@interface SliderModel : NSObject

@property (nonatomic,assign) int minValue;
@property (nonatomic,assign) int maxValue;
@property (nonatomic,assign) int selectedMinimum;
@property (nonatomic,assign) int selectedMaximum;

@property (nonatomic,copy) UIColor *slideColor;

// 单位值
@property (nonatomic,assign) int unitValue;
// 单位
@property (nonatomic,copy) NSString *unit;

// 显示两个滑块
@property (nonatomic,assign) BOOL showLeftHandle;


@end
