//
//  BaseLineView.h
//  JYApp
//
//  Created by xxjr02 on 16/6/1.
//  Copyright © 2016年 xxjr02. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+Additions.h"

typedef enum{
    LineTypeNone,
    LineTypeTop,
    LineTypeMiddle,
    LineTypeBotton,
    LineTypeTopAndBotton,
    LineTypeSpaceBotton
}LineType;

@interface BaseLineView : UIView

@property (nonatomic,assign) LineType linetype;

@property (nonatomic,copy) UIColor* lineColor;

@property (nonatomic,assign) BOOL border;

@end
