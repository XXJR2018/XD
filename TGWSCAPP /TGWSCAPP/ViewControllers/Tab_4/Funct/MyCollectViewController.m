//
//  MyCollectViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/27.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "MyCollectViewController.h"
#import "MyCollectCell.h"

#import "ShopDetailVC.h"

@interface MyCollectViewController ()

@end

@implementation MyCollectViewController

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kPage] = @(self.pageIndex);
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/cust/favorite/favoriteList",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
}

#pragma mark 数据操作
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    
    if (operation.jsonResult.rows.count > 0) {
        [self reloadTableViewWithArray:operation.jsonResult.rows];
    }else{
        self.pageIndex --;
        if (self.pageIndex > 1) {
            [MBProgressHUD showErrorWithStatus:@"没有更多数据了" toView:self.view];
        }
    }
    
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"我的收藏"];
    
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的收藏"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"我的收藏"];
    
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView setTableFooterView:[UIView new]];
    [_tableView registerNib:[UINib nibWithNibName:@"MyCollectCell" bundle:nil] forCellReuseIdentifier:@"MyCollect_Cell"];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_tableView setSeparatorColor:[ResourceManager color_5]];
}

#pragma mark === UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count == 0) {
        return 1;
    }else{
        return self.dataArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return tableView.frame.size.height;
    }else{
        return 80;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return  [self noDataCell:tableView];
    }
    MyCollectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCollect_Cell"];
    if (!cell) {
        cell = [[MyCollectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCollect_Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.dataDicionary = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //（这种是没有点击后的阴影效果)
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (self.dataArray.count == 0) {
        return;
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *goodsCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"goodsCode"]];
    if (goodsCode.length > 0) {
        ShopDetailVC *VC  = [[ShopDetailVC alloc] init];
        VC.shopModel = [[ShopModel alloc] init];
        VC.shopModel.strGoodsCode = goodsCode;
        VC.est = @"favorite";
        VC.esi = [NSString stringWithFormat:@"%@",[dic objectForKey:@"favoriteId"]];
        [self.navigationController pushViewController:VC animated:YES];
    }
}



@end
