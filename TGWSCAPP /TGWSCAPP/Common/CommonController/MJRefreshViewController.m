//
//  MJRefreshViewController.m
//  DDGProject
//
//  Created by Cary on 15/1/22.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import "MJRefreshViewController.h"

@interface MJRefreshViewController ()

@end

@implementation MJRefreshViewController

@synthesize selectedIndexPath = _selectedIndexPath;

//-(void)dealloc
//{
//    if (_headView) {
//        [_tableView.mj_header free];
//        _tableView.mj_header = nil;
//    }
//    
//    if (_footView) {
//        [_tableView.mj_footer free];
//    }
//    
//}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        _pullDown = YES;
        _pageSizeCount = 10;
        _pageIndex = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 下拉刷新
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reloadData];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreData];
    }];
}

#pragma mark === initData

- (CGRect)tableViewFrame
{
    return CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight);
}

/*!
 @brief
 @return    UITableView
 */
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:[self tableViewFrame]];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

/*!
 @brief     刷新数据
 @return    void
 */
- (void)reloadData
{
    //reset status
    self.pullDown = YES;
    //修改分页
    self.pageIndex = 1;
    self.isLoading = YES;
    [self loadData];
}

/*
 * 加载更多
 **/
-(void)loadMoreData{
    //修改分页
    self.pageIndex ++ ;
    //reset status
    self.pullDown = NO;
    self.isLoading = YES;
    [self loadData];
}

/*!
 @brief     请求完成
 */
- (void)loadFinish
{
    self.isLoading = NO;
    
//    [_tableView.mj_header endRefreshing];
//    [_tableView.mj_footer endRefreshing];
}


#pragma mark === 数据处理 ----- 在 loadData 完成之后调用
/*
 * 请求成功 ，做数据处理
 **/
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [self loadFinish];
    
    // 处理
    
}

/**
 * 请求发生错误的数据处理  (子类重写如果没有处理page，要先执行父类方法)
 */
-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    self.pageIndex = self.pageIndex > 1 ? self.pageIndex - 1 : 1 ;
    [self loadFinish];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    if ( ![ToolsUtlis isNetworkReachable])
    {
        [MBProgressHUD showNoNetworkHUDToView:self.view];
        return;
    }
    
    [MBProgressHUD showErrorWithStatus:[operation.errorDDG localizedDescription] toView:self.tableView];
}

- (void)reloadTableViewWithArray:(NSArray *)array
{
    if (self.pullDown){
        [self refreshTableViewWithArray:array];
        [_tableView.mj_header endRefreshing];
    }else{
        [self refreshTableViewWithMoreArray:array];
        [_tableView.mj_footer endRefreshing];
    }
}

/*!
 @brief     刷新
 @return    void
 */
- (void)refreshTableViewWithArray:(NSArray *)array
{
    if (self.pullDown){
        [self.dataArray removeAllObjects];
    }
    
    [self.dataArray addObjectsFromArray:array];
    
    if ([array count] < self.pageSizeCount){
        //显示已到最后一页
        self.canLoadMore = NO;
        [self.tableView reloadData];
    }else{
        [self.tableView reloadData];
    }
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

/*!
 @brief     加载更多
 @return    void
 */
- (void)refreshTableViewWithMoreArray:(NSArray *)array
{
    if (self.pullDown)
    {
        [self.dataArray removeAllObjects];
    }
    
    [self.dataArray addObjectsFromArray:array];
    
    [self.tableView reloadData];
    
}

#pragma mark === UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count ?: 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //#warning 子类要重写
    
    return nil;
}

-(UITableViewCell *)noDataCell:(UITableView *)tableView{
    static NSString * cellID = @"noDataCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [self noDataView:cell.contentView];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

        
@end
