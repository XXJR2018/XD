//
//  RootViewController.m
//  CustomNavigationBarController
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import "BaseController.h"
#import "LanguageManager.h"


@implementation BaseViewController

#if DEBUG

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        DDGVerboseLog(@"class -> %@", NSStringFromClass([self class]));
    }
    return self;
}

-(id)init{
    self = [super init];
    if (self) {
        DDGVerboseLog(@"class init -> %@", NSStringFromClass([self class]));
    }
    return self;
}

#endif

- (void)dealloc
{
    if ([ToolsUtlis isAtLeastIOS_7_0])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationDidBecomeActiveNotification
                                                      object:nil];
        
        if (self.navigationController.viewControllers[0] == self)
        {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.view.backgroundColor = [ResourceManager viewBackgroundColor];
    if ([ToolsUtlis isAtLeastIOS_7_0])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleApplicationDidBecomeActiveNotification:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    } else {

    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)handleApplicationDidBecomeActiveNotification:(NSNotification *)notification
{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound)
	{
		// back button was pressed.  We know this is true because self is no longer
		// in the navigation stack.
    }
    [super viewWillDisappear:animated];
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated
{
    [super dismissModalViewControllerAnimated:animated];
    dispatch_async(dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT), ^{
        
    });
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [super dismissViewControllerAnimated:flag completion:completion];
    dispatch_async(dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT), ^{
        
    });
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([ToolsUtlis isAtLeastIOS_7_0])
    {
        if (self.navigationController.viewControllers.count == 1)
        {
            return NO;
        }
    }
    return YES;
}

#pragma mark -
#pragma mark lifeCycle

- (UIView *)superViewForHud
{
    return self.view;
}

- (BOOL)isVisible
{
    return (self.isVisible && self.view.window);
}


@end


@implementation BaseTableViewController

#if DEBUG

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        DDGVerboseLog(@"class -> %@", NSStringFromClass([self class]));
    }
    return self;
}

#endif

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    if ([ToolsUtlis isAtLeastIOS_7_0])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationDidBecomeActiveNotification
                                                      object:nil];
        
        if (self.navigationController.viewControllers[0] == self)
        {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.view.backgroundColor = [ResourceManager viewBackgroundColor];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)handleApplicationDidBecomeActiveNotification:(NSNotification *)notification
{
    [self.view endEditing:YES];
}

- (void)leftButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Get our custom nav bar
}

- (void)viewWillDisappear:(BOOL)animated
{
	if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound)
	{
		// back button was pressed.  We know this is true because self is no longer
		// in the navigation stack.
    }
    [super viewWillDisappear:animated];
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated
{
    [super dismissModalViewControllerAnimated:animated];
    
    dispatch_async(dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT), ^{
        
    });
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    [super dismissViewControllerAnimated:flag completion:completion];
    dispatch_async(dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT), ^{
        
    });
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([ToolsUtlis isAtLeastIOS_7_0])
    {
        if (self.navigationController.viewControllers.count == 1)
        {
            return NO;
        }
    }
    return YES;
}

@end

