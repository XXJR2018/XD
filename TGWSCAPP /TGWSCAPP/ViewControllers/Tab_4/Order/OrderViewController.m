//
//  OrderViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/28.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "OrderViewController.h"

#import "OrderListViewController.h"
#import "LSPPageView.h"


@interface OrderViewController ()<LSPPageViewDelegate>

@end

@implementation OrderViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的订单"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的订单"];
}

-(void)clickNavButton:(UIButton *)button{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(4)}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"我的订单"];
    
    [self layoutUI];
}

-(void)layoutUI{
    
    NSArray *titleArray = @[@"全部",@"待付款",@"待发货",@"已发货",@"已完成"];
    NSArray *orderStatusArr = @[@"",@"0",@"3",@"5",@"6"];
    NSMutableArray *childVcArray = [NSMutableArray array];
    for (int i = 0; i < titleArray.count; i++) {
        OrderListViewController *ctl = [[OrderListViewController alloc] init];
        ctl.orderStatus = orderStatusArr[i];
        [childVcArray addObject:ctl];
    }
    LSPPageView *pageView = [[LSPPageView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight) titles:titleArray.mutableCopy style:nil childVcs:childVcArray.mutableCopy parentVc:self];
    pageView.delegate = self;
    [pageView setToIndex:self.orderIndex];
    pageView.backgroundColor = [ResourceManager viewBackgroundColor];
    [self.view addSubview:pageView];
    
}

#pragma mark - LSPPageViewDelegate
- (void)pageViewScollEndView:(LSPPageView *)pageView WithIndex:(NSInteger)index{
    NSLog(@"第%zd个",index);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
