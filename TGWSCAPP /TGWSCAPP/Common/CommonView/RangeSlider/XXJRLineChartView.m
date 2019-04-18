//
//  XXJRLineChartView.m
//  doubleChatline
//
//  Created by xxjr02 on 16/3/31.
//  Copyright © 2016年 carlsworld. All rights reserved.
//

#import "XXJRLineChartView.h"


#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)

@implementation XXJRLineChartView

-(id)initWithFrame:(CGRect)frame title:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20.f, 20.f, SCREEN_WIDTH - 40.f, 16)];
        titleLab.text = title;
        titleLab.textColor = [UIColor colorWithRed:147.f/255.f green:225.f/255.f blue:226.f/255.f alpha:1.f];
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.font = [UIFont systemFontOfSize:13.f];
        [self addSubview:titleLab];
        
        float chartViewOriginY = 50.f , chartViewOriginX = 20.f;
        for(int i=0; i<5; i++){
            UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0,chartViewOriginY + i*chartViewHeight/5, 18.0, 15)];
            [label setText:[NSString stringWithFormat:@"%2d", 25-i*5]];
            [label setTextColor:[UIColor grayColor]];
            [label setFont:[UIFont systemFontOfSize:11]];
            [label setTextAlignment:NSTextAlignmentRight];
            [label setBackgroundColor:[UIColor clearColor]];
            [self addSubview:label];
        }
        
        if(!_chartView){
            _chartView = [[LineChartView alloc]initWithFrame:CGRectMake(chartViewOriginX, chartViewOriginY, SCREEN_WIDTH - chartViewOriginX*2, chartViewHeight)];
            _chartView.backgroundColor = [UIColor whiteColor];
            [self addSubview:_chartView];
        }
        
        UIView *lineY = [[UIView alloc] initWithFrame:CGRectMake(19.0, chartViewOriginY, 1.0, chartViewHeight + 1.0)];
        lineY.backgroundColor = [UIColor colorWithRed:15.f/255.f green:120.f/255.f blue:188.f/255.f alpha:1.f];
        [self addSubview:lineY];
        
        [self XAndDayViewX:chartViewOriginX y:chartViewOriginY + chartViewHeight];
    }
    return self;
}

//画线
- (void)drawLineWithPoints:(NSArray *)points
{
    if (points && points.count > 0) {
        if(!_chartView.points.count){
            // 绘制曲线
            self.chartView.points = [points mutableCopy];
            
            [self.chartView setNeedsDisplay];
        }
    }else{
        // 无数据的色块与提示
        float spaceFront = 50.0*ScaleSize * 0.8 , spaceBack = 30.0*ScaleSize  * 0.8;
        UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(spaceFront, 70.0, self.width - spaceFront - spaceBack, 110.0)];
        colorView.backgroundColor = [UIColor colorWithRed:147.f/255.f green:225.f/255.f blue:226.f/255.f alpha:1.f];
        [self addSubview:colorView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 32)];
        imageView.center = CGPointMake(colorView.width/2, colorView.height/2 - 10.0);
        imageView.image = [UIImage imageNamed:@"dataList"];
        [colorView addSubview:imageView];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0.0, 0.0, 120.0, 15)];
        label.center = CGPointMake(colorView.width/2, colorView.height/2 + 22.0);
        [label setText:@"您本月暂无申请记录"];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont systemFontOfSize:12]];
        label.textAlignment = NSTextAlignmentCenter;
        [colorView addSubview:label];
    }
}

-(void)XAndDayViewX:(float)x y:(float)y{
    UIView *lineX = [[UIView alloc] initWithFrame:CGRectMake(x, y, self.width - 20.f, 1.0)];
    lineX.backgroundColor = [UIColor colorWithRed:15.f/255.f green:120.f/255.f blue:188.f/255.f alpha:1.f];
    [self addSubview:lineX];
    
    for (int i = 1; i <= 6; i ++) {
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake((self.width - 40.f)/6 * i + 20 - 0.5,y + 1, 1, 5)];
        line.backgroundColor = [UIColor grayColor];
        [self addSubview:line];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake((self.width - 40.f)/6 * i + 4.0,y + 8, 30.f, 15)];
        [label setText:[NSString stringWithFormat:@"%2d", i*5]];
        [label setTextColor:[UIColor grayColor]];
        [label setFont:[UIFont systemFontOfSize:11]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [self addSubview:label];
    }
}


@end

@implementation LineChartView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.afColor = [UIColor colorWithRed:126.f/255.f green:194.f/255.f blue:194.f/255.f alpha:1.f];
        self.bfColor = [UIColor colorWithRed:147.f/255.f green:225.f/255.f blue:226.f/255.f alpha:1.f];
        self.points = [[NSMutableArray alloc]init];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    if([self.points count]){
        //画线
        UIBezierPath* path = [UIBezierPath bezierPath];
        [path setLineWidth:2.0];
        
        CGPoint FirstPoint = [[self.points objectAtIndex:0] CGPointValue];
        [path moveToPoint:CGPointMake(0, 300)];
        [path addLineToPoint:FirstPoint];
        for(int i=0; i<[self.points count]-1; i++){
            CGPoint firstPoint = [[self.points objectAtIndex:i] CGPointValue];
            CGPoint secondPoint = [[self.points objectAtIndex:i+1] CGPointValue];
            [path addCurveToPoint:secondPoint controlPoint1:CGPointMake((secondPoint.x-firstPoint.x)/2+firstPoint.x, firstPoint.y) controlPoint2:CGPointMake((secondPoint.x-firstPoint.x)/2+firstPoint.x, secondPoint.y)];
            
        }
        
        [path addLineToPoint:CGPointMake([[self.points objectAtIndex:[self.points count]-1] CGPointValue].x, 300)];
        // 设置描边色
        [[UIColor colorWithRed:56.f/255.f green:197.f/255.f blue:186.f/255.f alpha:1.f] set];
        // 设置线段头尾部的样式
        path.lineCapStyle = kCGLineCapRound;
        [path strokeWithBlendMode:kCGBlendModeNormal alpha:1];
        
        
        UIBezierPath* pathForFill = [path copy];
        // 设置填充色
        [[UIColor colorWithRed:147.f/255.f green:225.f/255.f blue:226.f/255.f alpha:1.f] setFill];
        [pathForFill fill];
        
        // 图点
        if(!self.isDrawPoint){
            for(int i=0; i<[self.points count] - 1; i++){
                
                CGContextRef ctx = UIGraphicsGetCurrentContext();
                CGPoint point = [[self.points objectAtIndex:i] CGPointValue];
                
                int tp = i ;
                if (1 < tp && tp<[self.points count] - 1 && tp % 5 == 0) {
                    [self.afColor setFill];
                    CGContextFillEllipseInRect(ctx, CGRectMake(point.x - 3.5, point.y - 4, 7, 7));
                    [[UIColor whiteColor] setFill];
                    CGContextFillEllipseInRect(ctx, CGRectMake(point.x - 2.5, point.y - 3, 5, 5));
                }
                
            }
        }
        
    }
}

@end
