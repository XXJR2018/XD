//
//  DDGCellBackgroundView.m
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import "XXJRCellBackgroundView.h"

#define TABLE_CELL_BACKGROUND    { 0.964, 0.964, 0.964, 1, 0.964, 0.964, 0.964, 1}			// #FFFFFF and #DDDDDD
#define TABLE_CELL_SELECTED_BACKGROUND  {0.848, 0.848, 0.848, 1, 0.848, 0.848, 0.848, 1}    // #D9D9D9 - #D9D9D9
#define kDefaultMargin           10


@implementation XXJRCellBackgroundView

+ (XXJRCellBackgroundView *)backgroundView
{
    XXJRCellBackgroundView *v = [[XXJRCellBackgroundView alloc] initWithFrame:CGRectZero];
    v.position = CellBackgroundViewPositionMiddle;
    return v;
}

+ (XXJRCellBackgroundView *)backgroundViewIsSelectedView:(BOOL)isSeleced
{
    XXJRCellBackgroundView *v = [[XXJRCellBackgroundView alloc] initWithFrame:CGRectZero];
    v.position = CellBackgroundViewPositionMiddle;
    v.isSelectedView = isSeleced;
    return v;
}

- (BOOL)isOpaque
{
    return NO;
}

- (void)drawRect:(CGRect)aRect
{
    // Drawing code
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    int lineWidth = 1;
    
    CGRect rect = [self bounds];
    CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
    CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
    miny -= 1;
    
    CGFloat locations[2] = {0.0, 1.0 };
    CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef myGradient = nil;
    CGFloat cm[8] = TABLE_CELL_BACKGROUND;
    CGFloat csm[8] = TABLE_CELL_SELECTED_BACKGROUND;
    CGFloat components[8];
    for(int i=0;i<8;i++)
    {
        components[i]= self.isSelectedView?csm[i]:cm[i];
    }
    
    CGContextSetStrokeColorWithColor(c, [[UIColor grayColor] CGColor]);
    CGContextSetLineWidth(c, lineWidth);
    CGContextSetAllowsAntialiasing(c, YES);
    CGContextSetShouldAntialias(c, YES);
    
    if (self.position == CellBackgroundViewPositionTop)
    {
        miny += 1;
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, minx, maxy);
        CGPathAddArcToPoint(path, NULL, minx, miny, midx, miny, kDefaultMargin);
        CGPathAddArcToPoint(path, NULL, maxx, miny, maxx, maxy, kDefaultMargin);
        CGPathAddLineToPoint(path, NULL, maxx, maxy);
        CGPathAddLineToPoint(path, NULL, minx, maxy);
        CGPathCloseSubpath(path);
        
        // Fill and stroke the path
        CGContextSaveGState(c);
        CGContextAddPath(c, path);
        CGContextClip(c);
        
        myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, 2);
        CGContextDrawLinearGradient(c, myGradient, CGPointMake(minx,miny), CGPointMake(minx,maxy), 0);
        
        CGContextAddPath(c, path);
        CGPathRelease(path);
        CGContextStrokePath(c);
        CGContextRestoreGState(c);
        
    }
    
    
    else if (self.position == CellBackgroundViewPositionBottom)
    {
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, minx, miny);
        CGPathAddArcToPoint(path, NULL, minx, maxy, midx, maxy, kDefaultMargin);
        CGPathAddArcToPoint(path, NULL, maxx, maxy, maxx, miny, kDefaultMargin);
        CGPathAddLineToPoint(path, NULL, maxx, miny);
        CGPathAddLineToPoint(path, NULL, minx, miny);
        CGPathCloseSubpath(path);
        
        // Fill and stroke the path
        CGContextSaveGState(c);
        CGContextAddPath(c, path);
        CGContextClip(c);
        
        myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, 2);
        CGContextDrawLinearGradient(c, myGradient, CGPointMake(minx,miny), CGPointMake(minx,maxy), 0);
        
        CGContextAddPath(c, path);
        CGPathRelease(path);
        CGContextStrokePath(c);
        CGContextRestoreGState(c);
        
        
    }
    else if (self.position == CellBackgroundViewPositionMiddle)
    {
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, minx, miny);
        CGPathAddLineToPoint(path, NULL, maxx, miny);
        CGPathAddLineToPoint(path, NULL, maxx, maxy);
        CGPathAddLineToPoint(path, NULL, minx, maxy);
        CGPathAddLineToPoint(path, NULL, minx, miny);
        CGPathCloseSubpath(path);
        
        // Fill and stroke the path
        CGContextSaveGState(c);
        CGContextAddPath(c, path);
        CGContextClip(c);
        
        myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, 2);
        CGContextDrawLinearGradient(c, myGradient, CGPointMake(minx,miny), CGPointMake(minx,maxy), 0);
        
        CGContextAddPath(c, path);
        CGPathRelease(path);
        CGContextStrokePath(c);
        CGContextRestoreGState(c);
        
    }
    
    
    else if (self.position == CellBackgroundViewPositionSingle)
    {
        miny += 1;
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, minx, midy);
        CGPathAddArcToPoint(path, NULL, minx, miny, midx, miny, kDefaultMargin);
        CGPathAddArcToPoint(path, NULL, maxx, miny, maxx, midy, kDefaultMargin);
        CGPathAddArcToPoint(path, NULL, maxx, maxy, midx, maxy, kDefaultMargin);
        CGPathAddArcToPoint(path, NULL, minx, maxy, minx, midy, kDefaultMargin);
        CGPathCloseSubpath(path);
        
        
        // Fill and stroke the path
        CGContextSaveGState(c);
        CGContextAddPath(c, path);
        CGContextClip(c);
        
        
        myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, 2);
        CGContextDrawLinearGradient(c, myGradient, CGPointMake(minx,miny), CGPointMake(minx,maxy), 0);
        
        CGContextAddPath(c, path);
        CGPathRelease(path);
        CGContextStrokePath(c);
        CGContextRestoreGState(c);
    }
    
    if (!self.isSelectedView && self.position == CellBackgroundViewPositionMiddle)
    {
        CGContextSetStrokeColorWithColor(c, [UIColor whiteColor].CGColor);
        CGContextMoveToPoint(c, minx+1, maxy-1);
        CGContextAddLineToPoint(c, maxx-1, maxy-1);
        CGContextStrokePath(c);
    }
    
    CGColorSpaceRelease(myColorspace);
    CGGradientRelease(myGradient);
    return;
}


- (void)setPosition:(CellBackgroundViewPosition)newPosition
{
    if (_position != newPosition)
    {
        _position = newPosition;
        [self setNeedsDisplay];
    }
}


@end
