//
//  RefundListVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/9.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "RefundListVC.h"
#import "RefundListViewCell.h"
#import "RefundInfoVC.h"

@interface RefundListVC ()

@end

@implementation RefundListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"退款/售后"];
    
    [self layoutUI];
}


#pragma mark  ---  布局UI
-(void) layoutUI
{
    // 设置 tabelView 的位置
    int originY = NavHeight;
    self.tableView.frame =  CGRectMake(0, originY, SCREEN_WIDTH, SCREEN_HEIGHT - originY);
    
    // 隐藏分割线的颜色
    self.tableView.separatorColor = [UIColor clearColor];
 }



#pragma mark === UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count == 0) {
        return  1;
    }else{
        return self.dataArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return  tableView.frame.size.height - tableView.tableHeaderView.frame.size.height;
    }else{
        return iRefundListCellHeight;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return  [self noDataCell:tableView];
    }

    RefundListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Coupon_Cell"];
    if (!cell) {
        cell = [[RefundListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Coupon_Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.dataDicionary = self.dataArray[indexPath.row];
    
//    cell.employBlock = ^{
//        [self.navigationController popToRootViewControllerAnimated:NO];
//        [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@"1"}];
//    };

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //（这种是没有点击后的阴影效果)
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (self.dataArray.count <= 0)
     {
        return;
     }
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    
    
    //退款详情
    RefundInfoVC *VC = [[RefundInfoVC alloc] init];
    VC.dicParams = [[NSDictionary alloc] init];
    VC.dicParams = dic;
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark  ---  网络请求
-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    params[kPage] = @(self.pageIndex);
    params[kPageSize] = @(10);
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kURLrefundList];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
}


-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    
    if (operation.jsonResult.rows.count > 0) {
        [self reloadTableViewWithArray:operation.jsonResult.rows];
    }else{
        
        if (self.pageIndex > 1) {
            [MBProgressHUD showErrorWithStatus:@"没有更多数据了" toView:self.view];
        }
        
        self.pageIndex --;
        if (self.pageIndex <= 1)
         {
            [self reloadTableViewWithArray:operation.jsonResult.rows];
         }
    }
    
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}


@end
