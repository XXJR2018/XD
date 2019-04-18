//
//  PDInfoCoverView.m
//  PMH.Common
//
//  Created by qiu lijian on 13-7-24.
//  Copyright (c) 2013年 Paidui, Inc. All rights reserved.
//

#import "XXJRInfoCoverView.h"



@implementation XXJRInfoCoverView

#pragma mark -
#pragma mark property && init

/**
 *  初始化textLabel
 *
 *  @return UILabel
 */
- (UILabel *)textLabel
{
	if (!_textLabel)
	{
		_textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
		_textLabel.numberOfLines = 3;
		_textLabel.textColor = [ResourceManager CellTitleColor];
		_textLabel.font = [UIFont systemFontOfSize:16];
		_textLabel.backgroundColor = [UIColor clearColor];
		_textLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _textLabel;
}

/**
 *  初始化button
 *
 *  @return UIButton
 */
- (UIButton *)button
{
	if (!_button)
	{
		_button = [[UIButton alloc] initWithFrame:CGRectZero];
		[_button setTitleColor:[ResourceManager greenColor] forState:UIControlStateNormal];
        _button.backgroundColor = [UIColor clearColor];
		_button.exclusiveTouch = YES;
	}
	return _button;
}

/**
 *  初始化backgroundView
 *
 *  @return UIImageView
 */
- (UIImageView *)backgroundView
{
	if (!_backgroundView)
	{
		_backgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
	}
	return _backgroundView;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code
		[self setup];
    }
    return self;
}

/**
 *  返回self
 *
 *  @return 返回self
 */
+ (id)view
{
	return [[self alloc] initWithFrame:CGRectZero];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	[self.button sizeToFit];
	[self.textLabel sizeToFit];
	self.backgroundView.frame = CGRectInset(self.bounds, 10, 10);
	self.button.centerX = self.centerX;
	self.textLabel.centerX = self.centerX;
}

#pragma mark -
#pragma mark public method

- (void)setup
{
//	if ([EVTUtils isAtLeastIOS_6_0])
//	{
//		self.backgroundView.image = [[ResourceManager gongyong_dan_upImage]
//									 resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)
//									 resizingMode:UIImageResizingModeStretch];
//	}
//	else
//	{
//		self.backgroundView.image = [[ResourceManager gongyong_dan_upImage]
//									 resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
//	}

	self.textLabel.userInteractionEnabled = NO;
	self.backgroundView.userInteractionEnabled = NO;
	self.backgroundColor = [ResourceManager viewBackgroundColor];
	[self.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
																					action:@selector(buttonPressed:)];
	[self addGestureRecognizer:tapRecognizer];
	[self addSubview:self.backgroundView];
	[self addSubview:self.textLabel];
	[self addSubview:self.button];
}



+ (id)showInView:(UIView *)superView
{
	[self dismissInView:superView];
	UIView *view = [self view];
	view.frame = superView.bounds;
	view.alpha = 0.f;
	[superView addSubview:view];
	[UIView animateWithDuration:0.2 delay:0
						options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction
					 animations:^{
						 view.alpha = 1.f;
					 } completion:NULL];
	return view;
}

+ (void)dismissInView:(UIView *)view
{
	for (XXJRInfoCoverView *subView in view.subviews)
	{
		if ([subView isMemberOfClass:[self class]])
		{
			[UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut |
             UIViewAnimationOptionAllowUserInteraction animations:^{
				subView.alpha = 0.0f;
			} completion:^(BOOL finished) {
				subView.buttonPressedEvent = nil;
				[subView removeFromSuperview];
			}];
			break;
		}
	}
}


/*!
 @brief    显示
 */
+ (BOOL)isShowingInView:(UIView *)superView
{
	for (XXJRInfoCoverView *subView in superView.subviews)
	{
		if ([subView isMemberOfClass:[self class]])
		{
			return YES;
		}
	}
	return NO;
}

#pragma mark -
#pragma mark private method

/**
 *  按钮点击事件
 *
 *  @param button 按钮
 */
- (void)buttonPressed:(UIButton *)button
{
	if (self.buttonPressedEvent)
	{
		self.buttonPressedEvent();
		return;
	}
}

@end
