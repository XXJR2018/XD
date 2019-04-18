//
//  PDModalView.m
//  EVTUtils
//
//  Created by paidui-mini on 14-4-10.
//  Copyright (c) 2014年 Paidui, Inc. All rights reserved.
//

#import "XXJRModalView.h"

static XXJRModalView *modalView = nil;

@interface XXJRModalView ()

@property (nonatomic, retain) UIWindow *overlayWindow;

@property (nonatomic, retain) UIView *contentView;

@end

@implementation XXJRModalView

#pragma mark - Public Method

+ (XXJRModalView *)shareModalView
{
    if (modalView == nil)
    {
        modalView = [[XXJRModalView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return modalView;
}

+ (void)showModalView:(UIView *)view
{
    CGRect frame = view.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    view.frame = frame;
    [XXJRModalView shareModalView].contentView = view;
    
    [[XXJRModalView shareModalView].overlayWindow addSubview:view];
    [[XXJRModalView shareModalView] show];
}

+ (void)dismissModalView
{
    [[XXJRModalView shareModalView] dismiss];
}

#pragma mark - Property

- (UIWindow *)overlayWindow
{
    if (!_overlayWindow)
    {
        _overlayWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayWindow.autoresizesSubviews = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayWindow.backgroundColor = [UIColor clearColor];
    }
    return _overlayWindow;
}

#pragma mark - Private Method

- (void)dismiss
{
    CGRect frame = self.contentView.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = frame;
        self.alpha = 0.f;
    } completion:nil];

}

- (void)show
{
    [self.overlayWindow makeKeyAndVisible];
    
    CGRect frame = self.contentView.frame;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - self.contentView.frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.6f;
        self.contentView.frame = frame;
    }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        
        [self.overlayWindow addSubview:self];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.f;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
