//
//  PDNetWorkCoverView.m
//  PMH
//
//  Created by qiu lijian on 13-7-29.
//  Copyright (c) 2013年 Paidui, Inc. All rights reserved.
//

#import "XXJRNetWorkCoverView.h"

@interface XXJRNetWorkCoverView()

@property (nonatomic, retain) UIImageView *activeImageView;

@end

@implementation XXJRNetWorkCoverView

/**
 *  activeImageView
 *  @return UIImageView
 */
- (UIImageView *)activeImageView
{
	if (!_activeImageView)
	{
		_activeImageView = [[UIImageView alloc]initWithImage:[ResourceManager close]];
	}
	return _activeImageView;
}

/**
 *  设置view
 *  @return void
 */
- (void)setup
{
	[super setup];
    
//	[self addSubview:self.activeImageView];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    self.backgroundColor = [UIColor clearColor];
	self.textLabel.font = [UIFont systemFontOfSize:16];
	self.textLabel.text = @"当前网络不给力，建议检查网络状态";
    self.textLabel.textColor = [UIColor blackColor];
	
	[self.button setTitle:@"点击刷新" forState:UIControlStateNormal];
	[self.button sizeToFit];
    [self.button removeFromSuperview];
}


- (void)layoutSubviews
{

	[super layoutSubviews];
	
//	AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//	self.textLabel.top = [(UIViewController *)delegate.pmhRootViewController view].centerY - self.textLabel.height - kInfoCoverButtonPadding/2;
//	CGRect frame = [self convertRect:self.textLabel.frame
//									  fromView:[(UIViewController *)delegate.pmhRootViewController view]];
//	self.textLabel.top = frame.origin.y;
//	
//	self.button.top =  [(UIViewController *)delegate.pmhRootViewController view].centerY + kInfoCoverButtonPadding/2;
//	frame = [self convertRect:self.button.frame
//							fromView:[(UIViewController *)delegate.pmhRootViewController view]];
//	self.button.top = frame.origin.y;
//	
//	self.activeImageView.centerY = self.button.centerY;
//	self.activeImageView.left = self.button.right + 10;
    
    self.textLabel.frame = CGRectMake(30, 0, 280, 30);
    
}

@end
