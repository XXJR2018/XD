//
//  OrderListViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/28.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "OrderListViewController.h"

#import "LogisticsViewController.h"
#import "OrderDetailsViewController.h"
#import "AppraiseViewController.h"

#import "InvoiceInfoVC.h"
#import "InvoiceDetailsVC.h"

#import "SelPayVC.h"
#import "OrderListViewCell.h"
#import "RefundRequstFrist.h"
#import "RefundInfoVC.h"
#import "YCMenuView.h"

#define orderCellHeight  100

@interface OrderListViewController ()
{
    UIView *_headerView;
    NSString *_closeRemark;     //取消订单理由
    UIButton *_closeOrderBtn;
    NSMutableArray *_closeOrderBtnArr;
    UIView *_closeOrderAleartView;
}

@property(nonatomic,strong) NSString *orderNo;  //订单ID

@end

@implementation OrderListViewController

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.orderStatus.length > 0) {
        params[@"orderStatus"] = self.orderStatus;
    }
    params[kPage] = @(self.pageIndex);
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/myOrder/allList",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
    operation.tag = 1000;
}

//取消订单
-(void)cancelOrderUrl:(NSString *)orderNo{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = orderNo;
    if (_closeRemark.length > 0) {
        params[@"closeRemark"] = _closeRemark;
    }
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/myOrder/cancelOrder",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
    operation.tag = 1001;
}

//删除订单
-(void)deleteOrderUrl:(NSString *)orderNo{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = orderNo;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/myOrder/deleteOrder",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
    operation.tag = 1002;
}

//确认收货
-(void)confirmGoodsUrl:(NSString *)orderNo{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = orderNo;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/myOrder/confirmGoods",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
    operation.tag = 1003;
}

//再次购买
-(void)againShopUrl:(NSString *)orderNo{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = orderNo;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/myOrder/againShop",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
    operation.tag = 1004;
}


#pragma mark 数据操作
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    
    if (operation.tag == 1000) {
        if (operation.jsonResult.rows.count > 0) {
            [_tableView setTableHeaderView:[UIView new]];
            if ([self.orderStatus isEqualToString:@"6"]) {
                [_tableView setTableHeaderView:_headerView];
            }
            
            [self reloadTableViewWithArray:operation.jsonResult.rows];
        }else{
            if (self.pageIndex == 1) {
                 [_tableView setTableHeaderView:[UIView new]];
                [self.dataArray removeAllObjects];
                [_tableView reloadData];
            }else{
                self.pageIndex --;
                [MBProgressHUD showErrorWithStatus:@"没有更多数据了" toView:self.view];
            }
        }
    }else if (operation.tag == 1001) {
        [MBProgressHUD showSuccessWithStatus:@"订单取消成功" toView:self.view];
        [self performBlock:^{
            [self loadData];
        } afterDelay:1];
    }else if (operation.tag == 1002) {
        [MBProgressHUD showSuccessWithStatus:@"订单删除成功" toView:self.view];
        [self performBlock:^{
            [self loadData];
        } afterDelay:1];
    }else if (operation.tag == 1003) {
        [MBProgressHUD showSuccessWithStatus:@"确认收货成功" toView:self.view];
        [self performBlock:^{
            [self loadData];
        } afterDelay:1];
    }else if (operation.tag == 1004) {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"商品添加成功" message:@"商品已成功添加至购物车，前往购物车查看" preferredStyle:UIAlertControllerStyleAlert];
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(3)}];
        }]];
        [self presentViewController:actionSheet animated:YES completion:nil];
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
    [MobClick beginLogPageView:@"订单列表"];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"订单列表"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _closeOrderBtnArr = [NSMutableArray array];
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerClass:[OrderListViewCell class] forCellReuseIdentifier:@"OrderList_Cell"];
    [_tableView setTableFooterView:[UIView new]];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_tableView setSeparatorColor:[UIColor clearColor]];
    UIView *viewX = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    [self.view addSubview:viewX];
    viewX.backgroundColor = [ResourceManager color_5];
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    _headerView.backgroundColor = UIColorFromRGB(0xF9EBE1);
    
    UIImageView *LWImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (40 - 15)/2, 15, 15)];
    [_headerView addSubview:LWImgView];
    LWImgView.image = [UIImage imageNamed:@"Tab_4-40"];
    
    UILabel *LWLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(LWImgView.frame) + 5, 0, 300, 40)];
    [_headerView addSubview:LWLabel];
    LWLabel.font = [UIFont systemFontOfSize:13];
    LWLabel.textColor = UIColorFromRGB(0xCC5F40);
    LWLabel.text = @"评价送积分，多评多得不限次数~~";
    
}

- (CGRect)tableViewFrame{
    return CGRectMake(0, 0, SCREEN_WIDTH, self.view.size.height);
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
        NSDictionary *dic = self.dataArray[indexPath.row];
        NSArray *orderDtlListArr = [dic objectForKey:@"orderDtlList"];
        if ([[dic objectForKey:@"freightAmt"] intValue] > 0) {
            return orderCellHeight * orderDtlListArr.count + 155;
        }
        return orderCellHeight * orderDtlListArr.count + 135;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return  [self noDataCell:tableView];
    }
    NSString *cellID = [NSString stringWithFormat:@"%ld_cell",indexPath.row];
    OrderListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[OrderListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.orderLeftBlock = ^(UIButton *sender){
        [self orderLeftTouch:self.dataArray[indexPath.row] leftBtn:sender];
    };
    cell.orderCentreBlock = ^{
        [self orderCentreTouch:self.dataArray[indexPath.row]];
    };
    cell.orderRightBlock = ^{
        [self orderRightTouch:self.dataArray[indexPath.row]];
    };
    cell.orderTimeBlock = ^{
        NSString *orderNo = [NSString stringWithFormat:@"%@",[(NSDictionary *)self.dataArray[indexPath.row] objectForKey:@"orderNo"]];
        [self cancelOrderUrl:orderNo];
    };
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
    NSString *orderNo = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderNo"]];
    OrderDetailsViewController *ctl = [[OrderDetailsViewController alloc]init];
    ctl.orderNo = orderNo;
    [self.navigationController pushViewController:ctl animated:YES];
    
}

#pragma mark--订单列表按钮点击事件
-(void)orderLeftTouch:(NSDictionary *)dic leftBtn:(UIButton *)sender{
    //    状态（//0-待付款 1-交易成功 2-交易失败 3-卖家确认(待发货) 4-卖家审核失败 5-已发货  6-确认收货 7-交易关闭  8-退款成功  ）
    NSInteger status = [[dic objectForKey:@"status"] intValue];
    NSLog(@"status == %ld",status);
    if (status != 6) {
        _orderNo  = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderNo"]];
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:@"\n确定要删除订单?\n\n" preferredStyle:UIAlertControllerStyleAlert];
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //删除订单
            [self deleteOrderUrl:self.orderNo];
        }]];
        [self presentViewController:actionSheet animated:YES completion:nil];
    }else{
        //更多
        YCMenuAction *action1 = [YCMenuAction actionWithTitle:@"申请开票" image:nil handler:^(YCMenuAction *action) {
            //申请开票
            if ([[dic objectForKey:@"invoiceFlag"] intValue] == 1) {
                InvoiceDetailsVC *ctl = [[InvoiceDetailsVC alloc]init];
                ctl.orderNo = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderNo"]];
                [self.navigationController pushViewController:ctl animated:YES];
            }else{
                if ( [[dic objectForKey:@"invoiceAmount"] floatValue] > 0) {
                    InvoiceInfoVC *ctl = [[InvoiceInfoVC alloc]init];
                    ctl.orderNo = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderNo"]];
                    ctl.price = [NSString stringWithFormat:@"¥%.2f", [[dic objectForKey:@"invoiceAmount"] floatValue]];
                    [self.navigationController pushViewController:ctl animated:YES];
                }else{
                    [MBProgressHUD showErrorWithStatus:@"支付金额为零，不能开发票。" toView:self.view];
                }
            }
        }];
        YCMenuAction *action2 = [YCMenuAction actionWithTitle:@"申请售后" image:nil handler:^(YCMenuAction *action) {
            //申请售后
            RefundRequstFrist *VC = [[RefundRequstFrist alloc] init];
            VC.dicParams = [[NSDictionary alloc] init];
            VC.dicParams = dic;
            [self.navigationController pushViewController:VC animated:YES];
        }];
        YCMenuAction *action3 = [YCMenuAction actionWithTitle:@"删除订单" image:nil handler:^(YCMenuAction *action) {
            //删除订单
            [self deleteOrderUrl:self.orderNo];
        }];
        
        YCMenuView *YCView = [YCMenuView menuWithActions:@[action1,action2,action3] width:100 relyonView:sender];
        YCView.maxDisplayCount = 5;
        YCView.cornerRaius = 0;
        YCView.menuCellHeight = 40;
        YCView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
        YCView.menuColor = [UIColor colorWithWhite:0 alpha:0.7];
        YCView.textFont = [UIFont systemFontOfSize:14];
        YCView.textColor = [UIColor whiteColor];
        [YCView show];
    }
    
}

-(void)orderCentreTouch:(NSDictionary *)dic{
    //    状态（//0-待付款 1-交易成功 2-交易失败 3-卖家确认(待发货) 4-卖家审核失败 5-已发货  6-确认收货 7-交易关闭  8-退款成功  ）
    NSInteger status = [[dic objectForKey:@"status"] intValue];
    NSLog(@"status == %ld",status);
    _orderNo  = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderNo"]];
    if (status == 0 || status == 2) {
        //取消订单
        [self closeOrderAleartViewUI:_orderNo];
    }else if (status == 5) {
        //查看物流
        LogisticsViewController *ctl = [[LogisticsViewController alloc]init];
        ctl.orderNo = _orderNo;
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (status == 6) {
        //再次购买
        [self againShopUrl:_orderNo];
    }
    
}

-(void)orderRightTouch:(NSDictionary *)dic{
    //    状态（//0-待付款 1-交易成功 2-交易失败 3-卖家确认(待发货) 4-卖家审核失败 5-已发货  6-确认收货 7-交易关闭  8-退款成功  ）
    NSInteger status = [[dic objectForKey:@"status"] intValue];
    NSLog(@"status == %ld",status);
    _orderNo  = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderNo"]];
    if (status == 0 || status == 2) {
        //付款
        SelPayVC  *VC = [[SelPayVC alloc] init];
        VC.dicPay = dic;
        [self.navigationController pushViewController:VC animated:YES];
    }else if (status == 1 || status == 3) {
        // 申请退款
        RefundRequstFrist *VC = [[RefundRequstFrist alloc] init];
        VC.dicParams = [[NSDictionary alloc] init];
        VC.dicParams = dic;
        [self.navigationController pushViewController:VC animated:YES];
    }else if (status == 4 || status == 7) {
        //再次购买
        [self againShopUrl:_orderNo];
    }else if (status == 5) {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"确认收货" message:@"是否确认收货" preferredStyle:UIAlertControllerStyleAlert];
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //确认收货
            [self confirmGoodsUrl:self.orderNo];
        }]];
        [self presentViewController:actionSheet animated:YES completion:nil];
    }else if (status == 6) {
        //评价
        AppraiseViewController *ctl = [[AppraiseViewController alloc]init];
        ctl.orderNo = [dic objectForKey:@"orderNo"];
        [self.navigationController pushViewController:ctl animated:YES];
    }else if (status == 8) {
        //退款详情
        RefundInfoVC *VC = [[RefundInfoVC alloc] init];
        VC.dicParams = [[NSDictionary alloc] init];
        VC.dicParams = dic;
        [self.navigationController pushViewController:VC animated:YES];
    }
}

#pragma mark 取消订单原因弹窗布局
-(void)closeOrderAleartViewUI:(NSString *)orderNo{
    [_closeOrderAleartView  removeFromSuperview];
    
    _closeOrderAleartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [[UIApplication sharedApplication].keyWindow addSubview:_closeOrderAleartView];
    _closeOrderAleartView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    UIView *aleartView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 310)/2, (SCREEN_HEIGHT - 270)/2, 310, 270)];
    [_closeOrderAleartView addSubview:aleartView];
    aleartView.backgroundColor = [UIColor whiteColor];
    aleartView.layer.cornerRadius = 8;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, aleartView.bounds.size.width, 50)];
    [aleartView addSubview:titleLabel];
    titleLabel.textColor = [ResourceManager mainColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"请选择取消订单的理由";
    
    UIView *lineView_1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), aleartView.bounds.size.width, 0.5)];
    [aleartView addSubview:lineView_1];
    lineView_1.backgroundColor = [ResourceManager mainColor];
    
    NSArray *titleArr = @[@"我不想买了",@"信息填写错误，重新拍",@"卖家缺货",@"其他原因"];
    for (int i = 0;  i < titleArr.count; i++) {
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(lineView_1.frame) + 10 + 35 * i, aleartView.bounds.size.width - 50, 35)];
        [aleartView addSubview:titleLabel];
        titleLabel.textColor = [ResourceManager color_1];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = titleArr[i];
        
        _closeOrderBtn = [[UIButton alloc]initWithFrame:CGRectMake(aleartView.bounds.size.width - 35, CGRectGetMinY(titleLabel.frame) + 5, 25, 25)];
        [aleartView addSubview:_closeOrderBtn];
        _closeOrderBtn.tag = i;
        [_closeOrderBtn setImage:[UIImage imageNamed:@"Tab_4-28"] forState:UIControlStateNormal];
        [_closeOrderBtn setImage:[UIImage imageNamed:@"Tab_4-29"] forState:UIControlStateSelected];
        [_closeOrderBtn addTarget:self action:@selector(closeOrder:) forControlEvents:UIControlEventTouchUpInside];
        
        [_closeOrderBtnArr addObject:_closeOrderBtn];
    }
    
    UIView *lineView_2 = [[UIView alloc]initWithFrame:CGRectMake(0, aleartView.bounds.size.height - 50, aleartView.bounds.size.width, 0.5)];
    [aleartView addSubview:lineView_2];
    lineView_2.backgroundColor = [ResourceManager color_5];
    
    UIView *lineView_3 = [[UIView alloc]initWithFrame:CGRectMake((aleartView.bounds.size.width - 0.5)/2, CGRectGetMaxY(lineView_2.frame), 0.5, 50)];
    [aleartView addSubview:lineView_3];
    lineView_3.backgroundColor = [ResourceManager color_5];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView_2.frame), aleartView.bounds.size.width/2, 50)];
    [aleartView addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *agreeBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(cancelBtn.frame), CGRectGetMaxY(lineView_2.frame), aleartView.bounds.size.width/2, 50)];
    [aleartView addSubview:agreeBtn];
    [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    agreeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [agreeBtn setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(agree) forControlEvents:UIControlEventTouchUpInside];
}


- (void)cancel {
    [_closeOrderAleartView removeFromSuperview];
    _closeRemark = nil;
    _orderNo = nil;
}

-(void)agree{
    if (_closeRemark.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"请选择取消订单的理由" toView:_closeOrderAleartView];
        return;
    }
    [_closeOrderAleartView removeFromSuperview];
    
    if (_orderNo.length > 0 && _closeRemark.length > 0) {
        //取消订单
        [self cancelOrderUrl:_orderNo];
    }
    
}

-(void)closeOrder:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    if (sender != _closeOrderBtn) {
        _closeOrderBtn.selected = NO;
        _closeOrderBtn = sender;
    }
    _closeOrderBtn.selected  =YES;
    
    NSArray *titleArr = @[@"我不想买了",@"信息填写错误，重新拍",@"卖家缺货",@"其他原因"];
    _closeRemark = titleArr[sender.tag];
}

@end
