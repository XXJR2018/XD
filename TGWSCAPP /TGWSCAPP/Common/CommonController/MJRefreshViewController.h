//
//  MJRefreshViewController.h
//  DDGProject
//
//  Created by Cary on 15/1/22.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import "CommonViewController.h"
#import "DDGAFHTTPRequestOperation.h"
#import "MJRefresh.h"


@interface MJRefreshViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate>

{
    UITableView                *_tableView;
//    MJRefreshHeader        *_headView;
//    MJRefreshFooter        *_footView;
    
    BOOL					  _pullDown;
    BOOL                      _isLoading;
    BOOL                      _canLoadMore;
    
    NSInteger				  _pageRowCount;
    NSInteger				  _pageIndex;
    NSInteger				  _pageSize;
    
    NSIndexPath               *_selectedIndexPath;
}



/*!
 @property  UITableView tableView
 @brief
 */
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MJRefreshHeader *headView;
@property (nonatomic, strong) MJRefreshFooter *footView;


/*!
 @property  NSInteger pageIndex
 @brief     页码
 */
@property (nonatomic, assign) NSInteger pageIndex;
/*!
 @property  NSInteger pageIndex
 @brief     页大小
 */
@property (nonatomic, assign) NSInteger pageSizeCount;

/*!
 @property  NSInteger showRowCount
 @brief     一页的行数
 */
@property (nonatomic, assign) NSInteger showRowCount;

/**
 *  被选项的索引
 */
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

/*!
 @property  BOOL pullDown
 @brief     上拉还是下拉
 */
@property (nonatomic, assign) BOOL pullDown;

/*!
 @property  BOOL isLoading
 @brief     是否正在刷新
 */
@property (nonatomic, assign) BOOL isLoading;

/*!
 @property  BOOL canLoadMore
 @brief     能否加载更多
 */
@property (nonatomic, assign) BOOL canLoadMore;

- (void)reloadData;
/*!
 @brief     加载更多
 */
- (void)loadMoreData;
/*!
 @brief     请求完成
 */
- (void)loadFinish;

/*!
 @brief     刷新数据
 @return    void
 */
- (void)reloadTableViewWithArray:(NSArray *)array;

/*
 * 请求成功 ，做数据处理
 **/
-(void)handleData:(DDGAFHTTPRequestOperation *)operation;

/**
 * 请求发生错误的数据处理  (子类重写如果没有处理page，要先执行父类方法)
 */
-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation;

-(UITableViewCell *)noDataCell:(UITableView *)tableView;


@end
