//
//  CommonViewController.m
//  DDGProject
//
//  Created by Cary on 15/1/7.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import "CommonViewController.h"

@interface CommonViewController ()

@end

@implementation CommonViewController

@synthesize dataArray = _dataArray;

#pragma mark === initData
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark === viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    if (!_haveAppeared) {
        [self appearedLoadIfNeed];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (!_haveAppeared) {
        _haveAppeared = YES;
    }
}

- (void)appearedLoadIfNeed
{
    if (self.haveAppeared == NO){
        [self appearedLoad];
    }
}

/*!
 @brief     显示
 @return    void
 */
- (void)appearedLoad
{
    //没有网络直接读数据库数据,有网络在willappear请求数据
    if ([ToolsUtlis isNetworkReachable]){
        [self loadData];
    }else{
        [MBProgressHUD showErrorWithStatus:[LanguageManager networkUnreachableTipsString] toView:self.view];
    }
}

/*
 * 获取数据
 **/
-(void)loadData{

}


#pragma mark === viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [ResourceManager viewBackgroundColor];
    
}

#pragma mark ==== Layout-UI
-(CustomNavigationBarView *)layoutNaviBarViewWithTitle:(NSString *)title{
    CustomNavigationBarView *navBarView;
    if (!self.hideBackButton) {
        UIButton *buttonLeft              = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonLeft setImage:[ResourceManager arrow_return] forState:UIControlStateNormal];
        buttonLeft.tag = 10011;
        [buttonLeft addTarget:self action:@selector(clickNavButton:) forControlEvents:UIControlEventTouchUpInside];
        navBarView = [[CustomNavigationBarView alloc] initWithTitle:title withLeftButton:buttonLeft withRightButton:nil withBackColorStyle:NavigationBarViewBackColorBlack backdrop:NO];
        [self.view addSubview:navBarView];
    }else{
        navBarView = [[CustomNavigationBarView alloc] initWithTitle:title withLeftButton:nil withRightButton:nil withBackColorStyle:NavigationBarViewBackColorBlack backdrop:NO];
        [self.view addSubview:navBarView];
    }
    return navBarView;
}

#pragma mark ==== Layout-UI
-(CustomNavigationBarView *)layoutNaviBarViewBackdropTitle:(NSString *)title{
    CustomNavigationBarView *navBarView;
    if (!self.hideBackButton) {
        UIButton *buttonLeft              = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonLeft setImage:[ResourceManager arrow_return] forState:UIControlStateNormal];
        buttonLeft.tag = 10011;
        [buttonLeft addTarget:self action:@selector(clickNavButton:) forControlEvents:UIControlEventTouchUpInside];
        navBarView = [[CustomNavigationBarView alloc] initWithTitle:title withLeftButton:buttonLeft withRightButton:nil withBackColorStyle:NavigationBarViewBackColorBlack backdrop:YES];
        [self.view addSubview:navBarView];
    }else{
        navBarView = [[CustomNavigationBarView alloc] initWithTitle:title withLeftButton:nil withRightButton:nil withBackColorStyle:NavigationBarViewBackColorBlack backdrop:YES];
        [self.view addSubview:navBarView];
    }
    return navBarView;
}

-(void)clickNavButton:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark === ShowViews
/*!
 @brief     是否有数据
 @return    BOOL
 */
- (BOOL)isNoData
{
    return ([self.dataArray count] == 0);
}

/*
 * 没有网络的视图
 **/
-(void)showNoNetworkView{
    
}

/*
 * 没有数据的视图
 **/
-(void)showNoDataView{
    if ([self isNoData])
    {
        XXJRInfoCoverView *noDataConverView = [XXJRInfoCoverView showInView:self.view];
        noDataConverView.textLabel.text = @"没有数据";
        CGRect rect = CGRectMake(0, 200, SCREEN_WIDTH, 36.0);
        noDataConverView.frame = rect;
    }
}

/*
 * 没有更多数据的视图
 **/
-(void)showNoMoreView{
    
}


/*!
 @brief     移除CoverView
 @return    void
 */
- (void)removeCoverView
{
    [XXJRNetWorkCoverView dismissInView:self.view];
    [XXJRInfoCoverView dismissInView:self.view];
}


#pragma mark === 数据处理 ----- 在 loadData 完成之后调用
/*
 * 请求成功 ，做数据处理
 **/
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    // 处理
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


/**
 * 请求发生错误的数据处理  (子类重写如果没有处理page，要先执行父类方法)
 */
-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}

-(UITableViewCell *)noDataCell:(UITableView *)tableView{
    static NSString * cellID = @"noDataCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    [self noDataView:cell.contentView];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)noDataView:(UIView *)view{
    [view removeAllSubviews];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 125)/2, 150, 125, 147.5)];
    imageView.image = [UIImage imageNamed:@"noDataImg"];
    [view addSubview:imageView];
}

-(void)resignKeyboard
{
    [self.view endEditing:YES];
}

@end
