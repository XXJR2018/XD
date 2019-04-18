//
//  XTitleStyle.m
//  PageViewDemo
//  https://github.com/MrLSPBoy/PageViewController
//  Created by Object on 17/7/11.
//  Copyright © 2017年 Object. All rights reserved.
//

#import "LSPTitleStyle.h"

@implementation LSPTitleStyle

- (instancetype)init{
    if (self = [super init]) {
        
        self.isTitleViewScrollEnable = YES;
        self.isContentViewScrollEnable = YES;
        self.normalColor = UIColorFromRGB(0x333333);
        self.selectedColor = UIColorFromRGB(0x704a18);
        self.font = [UIFont systemFontOfSize:14.0];
        self.titleMargin = 0.0;
        self.isShowBottomLine = YES;
        self.bottomLineColor = self.selectedColor;
        self.bottomLineH = 2.0;
        self.isNeedScale = NO;
        self.scaleRange = 1.2;
        self.isShowCover = NO;
        self.coverBgColor = [UIColor clearColor];
        self.coverMargin = 0.0;
        self.coverH = 25.0;
        self.coverRadius = 5;
        self.bottomLineW = 60;
    }
    return self;
}

@end
