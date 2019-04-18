//
//  XXJRLineChartView.h
//  doubleChatline
//
//  Created by xxjr02 on 16/3/31.
//  Copyright © 2016年 carlsworld. All rights reserved.
//

#import <UIKit/UIKit.h>

#define chartViewHeight 150.0

@class LineChartView;
@interface XXJRLineChartView : UIView

@property(nonatomic,strong) LineChartView *chartView;

-(id)initWithFrame:(CGRect)frame title:(NSString *)title;

//画线
- (void)drawLineWithPoints:(NSArray *)points;

@end


@interface LineChartView : UIView

// 描边色
@property(nonatomic, strong)UIColor* afColor;
// 填充色
@property(nonatomic, strong)UIColor* bfColor;
@property(nonatomic, strong)NSMutableArray* points;

@property(assign)BOOL isDrawPoint;

@end
