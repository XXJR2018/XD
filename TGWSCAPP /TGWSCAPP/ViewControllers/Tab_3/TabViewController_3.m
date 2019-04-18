//
//  TabViewController_3.m
//  XXJR
//
//  Created by xxjr03 on 2018/9/4.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "TabViewController_3.h"
#import "LZCartViewController.h"


@interface TabViewController_3 ()
{
    UIScrollView *_scView;
    
    LZCartViewController *VC;
   
}


@end

@implementation TabViewController_3

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"购物车"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"购物车"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.hideBackButton = YES;
    //[self layoutNaviBarViewWithTitle:@"购物车"];
  
    
    [self layoutUI];
    



}

-(void)layoutUI
{
    // 初始化时， 传入参数
    VC = [[LZCartViewController alloc] initWithVar:YES];
    
    // 设置了很多方法，只有这样设置才能正确设置子sub的view的大小
    CGRect frameTemp = self.view.frame;
    frameTemp.size.height = SCREEN_HEIGHT - TabbarHeight;
    VC.view.frame = frameTemp;
    
    [self addChildViewController:VC];
    [self.view addSubview:VC.view];
    
}

-(void)addButtonView{
    [self.view addSubview:self.tabBar];
}


@end
