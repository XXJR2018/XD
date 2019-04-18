//
//  MyBalanceViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/25.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "MyBalanceViewController.h"

#import "BalanceViewCell.h"

#import "OrderDetailsViewController.h"
#import "RefundInfoVC.h"
#import "RechargeViewController.h"
#import "RechargeDetailsViewController.h"

@interface MyBalanceViewController ()
{
    UIView *_headerView;
    UIButton *_xfListBtn;
    UIButton *_lqListBtn;
    UIButton *_gqListBtn;
    UIButton *_RechargeBtn;
    UILabel *_balanceLabel;
    UILabel *_zsfyeLabel;
    UILabel *_zsfyeNumLabel;
    UIView *_balanceTypeView;
}
@end

@implementation MyBalanceViewController

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_xfListBtn.selected) {
        params[@"fundFlag"] = @"2";
    }else if (_lqListBtn.selected){
        params[@"fundFlag"] = @"1";
    }else{
        params[@"fundFlag"] = @"3";
    }
    params[kPage] = @(self.pageIndex);
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/cust/fund/fundList",[PDAPI getBaseUrlString]]
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
    if (operation.jsonResult.attr.count > 0) {
        NSDictionary *dic = operation.jsonResult.attr;
        if (_xfListBtn.selected) {
            _zsfyeLabel.text = @"总消费余额";
            _zsfyeNumLabel.text = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"totalExpend"] floatValue]];
        }else if (_lqListBtn.selected) {
            _zsfyeLabel.text = @"总领取余额";
            _zsfyeNumLabel.text = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"totalIncome"] floatValue]];
            if ([[dic objectForKey:@"totalIncome"] intValue] == 0) {
                _balanceTypeView.frame = CGRectMake(0, CGRectGetMaxY(_zsfyeNumLabel.frame), SCREEN_WIDTH, 0);
                [_balanceTypeView removeAllSubviews];
            }
        }else{
            _zsfyeLabel.text = @"总过期余额";
             _zsfyeNumLabel.text = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"totalOverdue"] floatValue]];
            if ([[dic objectForKey:@"totalOverdue"] intValue] == 0) {
                _balanceTypeView.frame = CGRectMake(0, CGRectGetMaxY(_zsfyeNumLabel.frame), SCREEN_WIDTH, 0);
                [_balanceTypeView removeAllSubviews];
            }
        }
    }
    if (operation.jsonResult.rows.count > 0) {
        [self reloadTableViewWithArray:operation.jsonResult.rows];
    }else{
        self.pageIndex --;
        if (self.pageIndex > 1) {
            [MBProgressHUD showErrorWithStatus:@"没有更多数据了" toView:self.view];
        }
        [_tableView reloadData];
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
    [MobClick beginLogPageView:@"我的余额"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"我的余额"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"我的余额"];
   
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView setTableFooterView:[UIView new]];
   [_tableView registerClass:[BalanceViewCell class] forCellReuseIdentifier:@"balance_cell"];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_tableView setSeparatorColor:[ResourceManager color_5]];
    
    [self layoutUI];
}

-(void)layoutUI{
    _headerView = [[UIView alloc]init];
    [_tableView setTableHeaderView:_headerView];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 100, 20)];
    [_headerView addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = [ResourceManager color_1];
    titleLabel.text = @"可用余额";
    _balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame), 100, 25)];
    [_headerView addSubview:_balanceLabel];
    _balanceLabel.font = [UIFont systemFontOfSize:20];
    _balanceLabel.textColor = UIColorFromRGB(0xB00000);
    _balanceLabel.text = [NSString stringWithFormat:@"￥%.2f",[[[CommonInfo userInfo] objectForKey:@"usableAmount"] floatValue]];
    
    _RechargeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH  - 90, CGRectGetMidY(_balanceLabel.frame) - 30/2, 70, 30)];
    [_headerView addSubview:_RechargeBtn];
    _RechargeBtn.layer.borderWidth = 0.5;
    _RechargeBtn.layer.borderColor = UIColorFromRGB(0xB00000).CGColor;
    [_RechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    _RechargeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_RechargeBtn setTitleColor:UIColorFromRGB(0xB00000) forState:UIControlStateNormal];
    [_RechargeBtn addTarget:self action:@selector(Recharge) forControlEvents:UIControlEventTouchUpInside];
    
    _xfListBtn = [[UIButton alloc]init];
    _lqListBtn = [[UIButton alloc]init];
    _gqListBtn = [[UIButton alloc]init];
    _xfListBtn.selected = YES;
    NSArray *btnArr = @[_xfListBtn,_lqListBtn,_gqListBtn];
    NSArray *titleArr = @[@"收支明细",@"领取记录",@"过期记录"];
    for (int i = 0; i < btnArr.count; i ++) {
        UIButton *btn = ((UIButton *)btnArr[i]);
        [_headerView addSubview:btn];
        btn.frame = CGRectMake(SCREEN_WIDTH/3 * i, CGRectGetMaxY(_balanceLabel.frame) + 25, SCREEN_WIDTH/3, 50);
        btn.backgroundColor = [ResourceManager viewBackgroundColor];
        btn.tag = i;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
        [btn setTitleColor:[ResourceManager color_1] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(banlanceTouch:) forControlEvents:UIControlEventTouchUpInside];
        if (i > 0) {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3 * i, CGRectGetMaxY(_balanceLabel.frame) + 35, 0.5, 20)];
            [_headerView addSubview:lineView];
            lineView.backgroundColor = [ResourceManager color_5];
        }
    }
    
    _zsfyeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_xfListBtn.frame), 200, 50)];
    [_headerView addSubview:_zsfyeLabel];
    _zsfyeLabel.font = [UIFont systemFontOfSize:14];
    _zsfyeLabel.textColor = [ResourceManager color_6];
    _zsfyeLabel.text = @"总消费余额";
    
    _zsfyeNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, CGRectGetMaxY(_xfListBtn.frame), 150, 50)];
    [_headerView addSubview:_zsfyeNumLabel];
    _zsfyeNumLabel.textAlignment = NSTextAlignmentRight;
    _zsfyeNumLabel.font = [UIFont systemFontOfSize:14];
    _zsfyeNumLabel.textColor = [ResourceManager mainColor];
    _zsfyeNumLabel.text = @"0";
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_zsfyeNumLabel.frame) - 0.5, SCREEN_WIDTH - 20, 0.5)];
    [_headerView addSubview:lineView];
    lineView.backgroundColor = [ResourceManager color_5];
    
    _balanceTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_zsfyeNumLabel.frame), SCREEN_WIDTH, 0)];
    [_headerView addSubview:_balanceTypeView];
    _balanceTypeView.backgroundColor = [UIColor whiteColor];
    
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(_balanceTypeView.frame));
}

#pragma mark ---充值
-(void)Recharge{
    RechargeViewController *ctl = [[RechargeViewController alloc]init];
    [self.navigationController pushViewController:ctl animated:YES];
}


-(void)banlanceTouch:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
   
   _balanceTypeView.frame = CGRectMake(0, CGRectGetMaxY(_zsfyeNumLabel.frame), SCREEN_WIDTH, 0);
    [_balanceTypeView removeAllSubviews];
    if (sender.tag == 0) {
        _xfListBtn.selected = YES;
        _lqListBtn.selected = NO;
        _gqListBtn.selected = NO;
    }else if (sender.tag == 1) {
        _xfListBtn.selected = NO;
        _lqListBtn.selected = YES;
        _gqListBtn.selected = NO;
        NSArray *titleArr = @[@"领取时间",@"到期时间",@"到账余额（元)"];
        for (int i = 0;  i < titleArr.count; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10 + (SCREEN_WIDTH - 20)/3 * i, 0, (SCREEN_WIDTH - 20)/3, 40)];
            [_balanceTypeView addSubview:label];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [ResourceManager color_1];
            label.text = titleArr[i];
            if (i == 0) {
                label.textAlignment = NSTextAlignmentLeft;
            }else if (i == 1) {
                label.textAlignment = NSTextAlignmentCenter;
            }else{
                label.textAlignment = NSTextAlignmentRight;
            }
        }
        
        _balanceTypeView.frame = CGRectMake(0, CGRectGetMaxY(_zsfyeNumLabel.frame), SCREEN_WIDTH, 40);
    }else{
        _xfListBtn.selected = NO;
        _lqListBtn.selected = NO;
        _gqListBtn.selected = YES;
        NSArray *titleArr = @[@"过期时间",@"过期余额（元)"];
        for (int i = 0;  i < titleArr.count; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10 +(SCREEN_WIDTH - 20)/2 * i, 0, (SCREEN_WIDTH - 20)/2, 40)];
            [_balanceTypeView addSubview:label];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = [ResourceManager color_1];
            label.text = titleArr[i];
            if (i == 0) {
                label.textAlignment = NSTextAlignmentLeft;
            }else{
                label.textAlignment = NSTextAlignmentRight;
            }
        }
        
        _balanceTypeView.frame = CGRectMake(0, CGRectGetMaxY(_zsfyeNumLabel.frame), SCREEN_WIDTH, 40);
    }
    
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(_balanceTypeView.frame));
    [_tableView setTableHeaderView:_headerView];
    
    self.pageIndex = 1;
    [self.dataArray removeAllObjects];
    [self loadData];
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
        if (_xfListBtn.selected) {
            return 100;
        }else{
            return 50;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return  [self noDataCell:tableView];
    }
    BalanceViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"balance_cell"];
    cell = nil;
    if (!cell) {
        cell = [[BalanceViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"balance_cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.dataDicionary = self.dataArray[indexPath.row];
    if (_xfListBtn.selected) {
        cell.balanceType = 100;
    }else if (_lqListBtn.selected) {
        cell.balanceType = 101;
    }else if (_gqListBtn.selected) {
        cell.balanceType = 102;
    }
    
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
    if (_xfListBtn.selected) {
        NSString *fundType = [NSString stringWithFormat:@"%@",[dic objectForKey:@"fundType"]];
        if ([fundType isEqualToString:@"order"] || [fundType isEqualToString:@"refundOrder"]) {
            OrderDetailsViewController *ctl = [[OrderDetailsViewController alloc]init];
            ctl.orderNo = [NSString stringWithFormat:@"%@",[(NSDictionary *)self.dataArray[indexPath.row] objectForKey:@"orderNo"]];
            [self.navigationController pushViewController:ctl animated:YES];
        }else if ([fundType isEqualToString:@"applyRefund"]) {
            RefundInfoVC *VC = [[RefundInfoVC alloc] init];
            VC.dicParams = [[NSDictionary alloc] init];
            VC.dicParams = dic;
            [self.navigationController pushViewController:VC animated:YES];
        }else if ([fundType isEqualToString:@"recharge"]) {
            RechargeDetailsViewController *ctl = [[RechargeDetailsViewController alloc] init];
            ctl.recordId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"recordId"]];
            [self.navigationController pushViewController:ctl animated:YES];
        }
    }

}



@end
