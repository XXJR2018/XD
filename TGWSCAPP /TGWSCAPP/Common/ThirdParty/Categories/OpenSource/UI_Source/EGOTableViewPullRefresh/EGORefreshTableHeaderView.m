 //
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "EGORefreshTableHeaderView.h"

#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f


@interface EGORefreshTableHeaderView (Private)

@end

static NSString *_lastUpdatedString = nil;
static NSString *_releaseRefreshString = nil;
static NSString *_pullDownRefreshString = nil;
static NSString *_loadingString = nil;

@implementation EGORefreshTableHeaderView

@synthesize delegate = _delegate;

+ (void)setLastUpdatedString:(NSString *)lastUpdatedString
{
    if (_lastUpdatedString == nil)
        _lastUpdatedString = lastUpdatedString;
}
+ (void)setReleaseRefreshString:(NSString *)releaseRefreshString
{
    if (_releaseRefreshString == nil)
        _releaseRefreshString = releaseRefreshString;
}
+ (void)setPullDownRefreshString:(NSString *)pullDownRefreshString
{
    if (_pullDownRefreshString == nil)
        _pullDownRefreshString = pullDownRefreshString;
}
+ (void)setLoadingString:(NSString *)loadingString
{
    if (_loadingString == nil)
        _loadingString = loadingString;
}
- (NSString *)lastUpdatedString
{
    if (_lastUpdatedString == nil)
        return @"上次更新: %@";
    return _lastUpdatedString;
}
- (NSString *)releaseRefreshString
{
    if (_releaseRefreshString == nil)
        return @"释放开始刷新...";
    return _releaseRefreshString;
    
}
- (NSString *)pullDownRefreshString
{
    if (_pullDownRefreshString == nil)
        return @"下拉刷新数据...";
    return _pullDownRefreshString;
}
- (NSString *)loadingString
{
    if (_loadingString == nil)
        return @"正在载入...";
    return _loadingString;
}


- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
		
		UIImage *image = [UIImage imageNamed:@"grayArrow"];
		if (image) {
			UIImageView *logoImageView = [[UIImageView alloc] initWithImage:image];
			logoImageView.tag = 1000;
			logoImageView.contentMode = UIViewContentModeCenter;
			logoImageView.frame = CGRectMake(0, frame.size.height - 85, 320, 19);
			[self addSubview:logoImageView];
		}

		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont systemFontOfSize:12.0f];
		label.textColor = textColor;
//		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_lastUpdatedLabel=label;
		
		label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = textColor;
//		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
//		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		
		CALayer *layer = [CALayer layer];
		layer.frame = CGRectMake(65.0f, frame.size.height - 56.0f, 30.0f, 55.0f);
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:[arrow isEqualToString:@"whiteArrow.png"]
										 ?UIActivityIndicatorViewStyleWhite:UIActivityIndicatorViewStyleGray];
		view.frame = CGRectMake(68.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:view];
		_activityView = view;		
		
		[self setState:EGOOPullRefreshNormal];
		
    }
	
    return self;
	
}

- (id)initWithFrame:(CGRect)frame  {
  return [self initWithFrame:frame arrowImageName:@"whiteArrow.png" textColor:[UIColor whiteColor]];
}

#pragma mark -
#pragma mark Setters

- (void)refreshLastUpdatedDate {
	
    if ( _delegate && [_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceLastUpdated:)]) {
		
		NSDate *date = [_delegate egoRefreshTableHeaderDataSourceLastUpdated:self];
		
        if(_delegate && [_delegate respondsToSelector:@selector(egoRefreshTableHeaerDateStringFormat:)]){
		    NSString *dateStringFormat = [_delegate egoRefreshTableHeaerDateStringFormat:self];
			_lastUpdatedLabel.text = [NSString stringWithFormat:[self lastUpdatedString], 
									  [date stringWithCurrentTimeZoneFormat:dateStringFormat]];
		}
		else{
			_lastUpdatedLabel.text = [NSString stringWithFormat:[self lastUpdatedString], 
                                                            [date stringWithCurrentTimeZoneFormat:@"MM-dd HH:mm"]];
		}
		
	} else {
		
		_lastUpdatedLabel.text = nil;
		
	}

}

- (void)setState:(EGOPullRefreshState)aState{
	
	switch (aState) {
		case EGOOPullRefreshPulling:
			
			_statusLabel.text = [self releaseRefreshString];
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			
			break;
		case EGOOPullRefreshNormal:
			
			if (_state == EGOOPullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = [self pullDownRefreshString];
			[_activityView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			
			[self refreshLastUpdatedDate];
			
			break;
		case EGOOPullRefreshLoading:
			
			_statusLabel.text = [self loadingString];
			[_activityView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}


#pragma mark -
#pragma mark ScrollView Methods

- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView {	
	
	if (_state == EGOOPullRefreshLoading) {
		
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
		
	} else if (scrollView.isDragging) {
		
		BOOL _loading = NO;
        if ( _delegate && [_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
			_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
		}
		
		if (_state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			[self setState:EGOOPullRefreshNormal];
		} else if (_state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
			[self setState:EGOOPullRefreshPulling];
		}
		
		if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
		
	}
	
}

- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	
	BOOL _loading = NO;
    if (_delegate && [_delegate respondsToSelector:@selector(egoRefreshTableHeaderDataSourceIsLoading:)]) {
		_loading = [_delegate egoRefreshTableHeaderDataSourceIsLoading:self];
	}
	
	if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
		
        if (_delegate && [_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
			[_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
		}
		
		[self setState:EGOOPullRefreshLoading];
		[UIView animateWithDuration:.5
							  delay:0
							options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
						 animations:^{
							 scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
						 }
						 completion:^(BOOL finished) {
							 	[self scrollDidEndDragging];
						 }];
		
	}
}

- (void)scrollDidEndDragging
{
    if (_delegate && [_delegate respondsToSelector:@selector(egoRefreshTableHeaderDragedFinishLoad:)]) {
		[_delegate egoRefreshTableHeaderDragedFinishLoad:self];
	}
}

- (void)egoRefreshScrollViewToLoading:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(egoRefreshTableHeaderDidTriggerRefresh:)]) {
		[_delegate egoRefreshTableHeaderDidTriggerRefresh:self];
	}
	
	[self setState:EGOOPullRefreshLoading];
	
	[UIView animateWithDuration:.5
						  delay:0
						options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
					 }
					 completion:NULL];
}

- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
	[UIView animateWithDuration:.3
						  delay:0
						options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
					 }
					 completion:^(BOOL finished) {
						 [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
						 [self setState:EGOOPullRefreshNormal];
					 }];
	
}

#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_delegate=nil;
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
	_lastUpdatedLabel = nil;
}


@end
