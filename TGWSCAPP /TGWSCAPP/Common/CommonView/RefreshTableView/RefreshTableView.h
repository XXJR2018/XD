//
//  HomeTableView.h
//  DDGAPP
//
//  Created by Cary on 15/3/2.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJRefreshHeader.h"
#import "MJRefreshFooter.h"
#import "ToolsUtlis.h"

@class RefreshTableView;

@protocol RefreshTableViewDelegate <NSObject>

@optional
-(void)didSelectedRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(RefreshTableView *)aView;

-(void)loadData:(void(^)(int aAddedRowCount))complete FromView:(RefreshTableView *)aView;

-(void)refreshData:(void(^)())complete FromView:(RefreshTableView *)aView;

@optional
//- (void)tableViewWillBeginDragging:(UIScrollView *)scrollView;
//- (void)tableViewDidScroll:(UIScrollView *)scrollView;
////- (void)tableViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
//- (BOOL)tableViewEgoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view FromView:(CustomTableView *)aView;
@end

@protocol RefreshTableViewDataSource <NSObject>

@required

-(CGFloat)heightForRowAthIndexPath:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(RefreshTableView *)aView;
-(UITableViewCell *)cellForRowInTableView:(UITableView *)aTableView IndexPath:(NSIndexPath *)aIndexPath FromView:(RefreshTableView *)aView;

@optional

-(NSInteger)numberOfRowsInTableView:(UITableView *)aTableView InSection:(NSInteger)section FromView:(RefreshTableView *)aView;

@end


@interface RefreshTableView : UIView <UITableViewDataSource,UITableViewDelegate>
{
    
}
/**
 *  是否第一次加载
 */
@property (nonatomic,assign) BOOL secondLoading;

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, strong) NSMutableDictionary *paramsDic;

/*!
 @property  NSInteger tag
 @brief     用来标示 operation 的 key
 */
@property (nonatomic, assign) NSInteger operationTag;

/*!
 @property  NSInteger pageIndex
 @brief     页码
 */
@property (nonatomic, assign) NSInteger pageIndex;

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

@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *dataArray;

@property (nonatomic,assign) id<RefreshTableViewDataSource> dataSource;
@property (nonatomic,assign) id<RefreshTableViewDelegate>  delegate;

/*!
 @brief     无数据的文字提示
 */
@property (nonatomic,copy) NSString *noDataMsg;

/*!
 @brief     按钮的文字
 */
@property (nonatomic,copy) NSString *btnMsg;

/*!
 @brief     一些附加信息，备用字段
 */
@property (nonatomic,copy) NSString *otherInfo;


- (id)initWithFrame:(CGRect)frame footView:(BOOL)withFooter;

// 下拉刷新
- (void)addHeader;

// 上拉刷新
- (void)addFooter;

/**
 *  重新请求，重载数据
 */
-(void)reloadData;

/**
 *  强制刷新tableView （真正刷新，没有数据时，也会刷新）
 */
-(void)foceeReload;




/**
 *  封装所需的参数
 *
 *  @return <#return value description#>
 */
-(NSDictionary *)fetchParams;

/*
 *  结束请求
 */
-(void)endRefresh;


@end
