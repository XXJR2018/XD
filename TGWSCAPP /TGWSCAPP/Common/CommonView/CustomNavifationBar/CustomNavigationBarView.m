//
//  CustomNavigationBarView.m
//  PMH.Views
//
//  Created by 登文 陈 on 14-7-30.
//  Copyright (c) 2014年 Paidui, Inc. All rights reserved.
//

#import "CustomNavigationBarView.h"


@implementation CustomNavigationBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithTitle:(NSString *)title withBackColorStyle:(NavigationBarViewBackColor)colorStyle{
    
    if (IS_IPHONE_X_MORE) {
        self = [super initWithFrame:Rect_88];
        if (self) {
            // Initialization code
        
            
            _barColor = colorStyle;
            
            [self layoutTitleViewWith:title andColorStyle:colorStyle];
            
        }
        return self;
    }else{
        self = [super initWithFrame:Rect_64];
        if (self) {
            // Initialization code
            
            _barColor = colorStyle;
            
            [self layoutTitleViewWith:title andColorStyle:colorStyle];
            
        }
        return self;
    }
    return nil;
    
}


-(id)initWithTitle:(NSString *)title withLeftButton:(UIButton *)leftButton withRightButton:(UIButton *)rightButton withBackColorStyle:(NavigationBarViewBackColor)colorStyle backdrop:(BOOL)isBackdrop{
    if (IS_IPHONE_X_MORE) {
        self = [super initWithFrame:Rect_88];
        if (self) {
            if (isBackdrop) {
                UIImageView *naviBackgroundImg = [[UIImageView alloc]initWithFrame:self.frame];
                naviBackgroundImg.image = [ResourceManager naviBack_Img];
                [self addSubview:naviBackgroundImg];
                naviBackgroundImg.userInteractionEnabled = YES;
            }
           
            // Initialization code
            if (title && title.length > 0) {
                [self layoutTitleViewWith:title andColorStyle:colorStyle];
            }
            
            if (leftButton) {
                leftButton.frame = CGRectMake(0.f,45.f+5.f,60.f, 35.0f);
                leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
                [self addSubview:leftButton];
            }
            if (rightButton) {
                rightButton.frame = CGRectMake(SCREEN_WIDTH - 60.f,45.f+5.f,60.f, 35.0f);
                [self addSubview:rightButton];
            }
            
//            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, Rect_88.size.height - 0.5, Rect_88.size.width, 0.4)];
//            line.tag = 1111;
//            line.backgroundColor = [ResourceManager color_5];
//            [self addSubview:line];
        }
        return self;
    }else{
        self = [super initWithFrame:Rect_64];
        if (self) {
            // Initialization code
            if (isBackdrop) {
                UIImageView *naviBackgroundImg = [[UIImageView alloc]initWithFrame:self.frame];
                naviBackgroundImg.image = [ResourceManager naviBack_Img];
                [self addSubview:naviBackgroundImg];
                naviBackgroundImg.userInteractionEnabled = YES;
            }
            
            if (title && title.length > 0) {
                [self layoutTitleViewWith:title andColorStyle:colorStyle];
            }
            
            if (leftButton) {
                leftButton.frame = CGRectMake(0.f,25.f,60.f, 35.0f);
                leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
                [self addSubview:leftButton];
            }
            if (rightButton) {
                rightButton.frame = CGRectMake(SCREEN_WIDTH - 60.f,25.f,60.f, 35.0f);
                [self addSubview:rightButton];
            }
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, Rect_64.size.height - 0.5, Rect_64.size.width, 0.4)];
            line.tag = 1111;
            line.backgroundColor = [ResourceManager color_5];
            [self addSubview:line];
        }
        return self;
    }
    return nil;
    
}


// 修改过，适配iPhoneX
-(void)layoutTitleViewWith:(NSString *)title andColorStyle:(NavigationBarViewBackColor)colorStyle{
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(60.f, NavHeight - 39, SCREEN_WIDTH - 60.f * 2, 35.f)];
    _titleLab.backgroundColor = [UIColor clearColor];
    _titleLab.textAlignment = NSTextAlignmentCenter;
//    _titleLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    _titleLab.font = [UIFont systemFontOfSize:16];
    
    
    if (colorStyle == NavigationBarViewBackColorWhite) {
        _titleLab.textColor = [UIColor whiteColor];
        self.backgroundColor = [ResourceManager navgationBackGroundColor];
    }else if(colorStyle == NavigationBarViewBackColorBlack){
        _titleLab.textColor = [ResourceManager navgationTitleColor];
        self.backgroundColor = [ResourceManager navgationBackGroundColor];        
    }
    
    _titleLab.text = title;
    [self addSubview:_titleLab];
}

-(id)initWithTitleImgView:(NSString *)imgString withLeftButton:(UIButton *)leftButton withRightButton:(UIButton *)rightButton withBackColorStyle:(NavigationBarViewBackColor)colorStyle{
    if (IS_IPHONE_X_MORE) {
        self = [super initWithFrame:Rect_88];
        if (self) {
            // Initialization code
            
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 131/1.7, 43/1.7)];
            imgView.image = [UIImage imageNamed:imgString];
            CGPoint center = {self.center.x, self.center.y + 10.f};
            imgView.center =  center;
            [self addSubview:imgView];
            
            
            if (leftButton) {
                leftButton.frame = CGRectMake(0.f,25.f+5.f,60.f, 35.0f);
                [self addSubview:leftButton];
            }
            if (rightButton) {
                rightButton.frame = CGRectMake(SCREEN_WIDTH - 60.f,25.f+5.f,60.f, 35.0f);
                [self addSubview:rightButton];
            }
            
            
        }
        
        self.backgroundColor = [ResourceManager navgationBackGroundColor];
        
        return self;
    }else{
        self = [super initWithFrame:Rect_64];
        if (self) {
            // Initialization code
            
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 131/1.7, 43/1.7)];
            imgView.image = [UIImage imageNamed:imgString];
            CGPoint center = {self.center.x, self.center.y + 10.f};
            imgView.center =  center;
            [self addSubview:imgView];
            
            
            if (leftButton) {
                leftButton.frame = CGRectMake(0.f,25.f,60.f, 35.0f);
                //                leftButton.backgroundColor = [UIColor redColor];
                [self addSubview:leftButton];
            }
            if (rightButton) {
                rightButton.frame = CGRectMake(SCREEN_WIDTH - 60.f,25.f,60.f, 35.0f);
                [self addSubview:rightButton];
            }
            
            
        }
        
        self.backgroundColor = [ResourceManager navgationBackGroundColor];
        
        return self;
    }
    return nil;
    
}



@end
