//
//  CommonViewController.h
//  DDGProject
//
//  Created by Cary on 15/1/7.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseController.h"

#import "DDGAFHTTPRequestOperation.h"

@class CustomNavigationBarView;

@interface CommonViewController : UIViewController
{
    BOOL _haveAppeared;
    
    NSMutableArray *_dataArray;
}

@property (nonatomic,assign) BOOL haveAppeared;

/*
 *  是否是NavigationViewController的第2层以下,需要返回按钮
 */
@property (nonatomic,assign) BOOL hideBackButton;

/*!
 @property  BOOL dataArray
 @brief     数据数组
 */
@property (nonatomic,strong) NSMutableArray *dataArray;

/*
 * 获取数据,在子类中重写
 **/
-(void)loadData;

/*
 *
 */
- (void)appearedLoad;

/**
 *  导航条
 *
 *  @param title <#title description#>
 */
-(CustomNavigationBarView *)layoutNaviBarViewWithTitle:(NSString *)title;

/**
 *  导航条 有背景图片
 *
 *  @param title <#title description#>
 */
-(CustomNavigationBarView *)layoutNaviBarViewBackdropTitle:(NSString *)title;

/*
 * 没有网络的视图
 **/
-(void)showNoNetworkView;

/*
 * 没有数据的视图
 **/
-(void)showNoDataView;

/*
 * 没有更多数据的视图
 **/
-(void)showNoMoreView;

/*!
 @brief     移除CoverView
 */
- (void)removeCoverView;



/**
 * 数据处理
 */
-(void)handleData:(DDGAFHTTPRequestOperation *)operation;

/**
 * 请求发生错误的数据处理
 */
-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation;


-(UITableViewCell *)noDataCell:(UITableView *)tableView;

-(void)noDataView:(UIView *)view;

-(void)resignKeyboard;

@end
