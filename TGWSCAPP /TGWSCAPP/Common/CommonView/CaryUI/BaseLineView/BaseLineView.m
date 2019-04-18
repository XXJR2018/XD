//
//  BaseLineView.m
//  JYApp
//
//  Created by xxjr02 on 16/6/1.
//  Copyright © 2016年 xxjr02. All rights reserved.
//

#import "BaseLineView.h"

#define DefaultColor UIColorFromRGB(0xD3D3D3)

@implementation BaseLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    if (self.border) {
        self.layer.cornerRadius = 4;
        self.layer.borderColor = [self.lineColor?:DefaultColor CGColor];
        self.layer.borderWidth = 0.6;
        self.clipsToBounds = YES;
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.linetype == LineTypeNone){
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [self.lineColor?:DefaultColor CGColor]);
//    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 1.0);
    
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 0.6);

    CGPoint start , end;
    if (self.linetype == LineTypeTop) {
        start = CGPointMake(0, 0);
        end = CGPointMake(rect.size.width, 0);
    }else if (self.linetype == LineTypeMiddle) {
        start = CGPointMake(0, rect.size.height/2);
        end = CGPointMake(rect.size.width, rect.size.height/2);
    }else if (self.linetype == LineTypeBotton) {
        start = CGPointMake(0, rect.size.height);
        end = CGPointMake(rect.size.width, rect.size.height);
    }else if (self.linetype == LineTypeTopAndBotton) {
        start = CGPointMake(0, 0);
        end = CGPointMake(rect.size.width, 0);
        
        CGPoint start2 = CGPointMake(0, rect.size.height);
        CGPoint end2 = CGPointMake(rect.size.width, rect.size.height);
        CGContextMoveToPoint(context, start2.x, start2.y);
        CGContextAddLineToPoint(context, end2.x, end2.y);
    }else if (self.linetype == LineTypeSpaceBotton) {
        start = CGPointMake(15, rect.size.height);
        end = CGPointMake(rect.size.width, rect.size.height);
    }else {
        start = CGPointMake(0, 0);
        end = CGPointMake(rect.size.width, 0);
    }
    
    CGContextMoveToPoint(context, start.x, start.y);
    CGContextAddLineToPoint(context, end.x, end.y);
    
    CGContextStrokePath(context);
}

@end
