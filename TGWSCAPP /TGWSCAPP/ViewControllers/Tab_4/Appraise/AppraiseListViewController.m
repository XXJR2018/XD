//
//  AppraiseListViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/14.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "AppraiseListViewController.h"
#import "AppraiseViewController.h"
#import "OrderDetailsViewController.h"
#import "ReviewAppraiseViewController.h"

#import "MyAPPraiseView.h"

#import "AppraiseListCell.h"
@interface AppraiseListViewController ()
{
    UIView *_headerView;
    UIButton *_dpjBtn;
    UIButton *_wdpjBtn;
    UIView *_aleartView;
}
@end

@implementation AppraiseListViewController

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kPage] = @(self.pageIndex);
    NSString *url = [NSString stringWithFormat:@"%@appMall/account/orderComment/queryWaitOrder",[PDAPI getBaseUrlString]];
    if (_wdpjBtn.selected) {
        url = [NSString stringWithFormat:@"%@appMall/account/orderComment/queryMyCommList",[PDAPI getBaseUrlString]];
    }
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:url
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

#pragma mark 数据操作
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    
    if (operation.tag == 1000) {
        if (operation.jsonResult.rows.count > 0) {
            [_tableView setTableHeaderView:_headerView];
            if (_wdpjBtn.selected) {
                [_tableView setTableHeaderView:[UIView new]];
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
    }
    
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
}

-(CGFloat)currentCellHeightSave:(NSDictionary *)dic{
    if (_dpjBtn.selected) {
        //待评价列表高度
        NSArray *orderDtlListArr = [dic objectForKey:@"orderDtlList"];
        if ([[dic objectForKey:@"freightAmt"] intValue] > 0) {
            return 100 * orderDtlListArr.count + 155;
        }else{
            return 100 * orderDtlListArr.count + 135;
        }
    }else{
        //我的评价列表高度
        MyAPPraiseView *view = [[MyAPPraiseView alloc]initWithAppraiseListViewLayoutUI:dic];
        return view.frame.size.height;
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"评价"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"评价"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"评价"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView setTableFooterView:[UIView new]];
    [_tableView registerClass:[AppraiseListCell class] forCellReuseIdentifier:@"AppraiseList_cell"];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_tableView setSeparatorColor:[UIColor clearColor]];

    [self layoutUI];
    
    if (self.appraiseType == 2) {
        [self appraise:_wdpjBtn];
    }
    
}

- (CGRect)tableViewFrame{
    return CGRectMake(0, NavHeight + 50, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight - 50);
}

-(void)layoutUI{
    
    _dpjBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH/2, 50)];
    [self.view addSubview:_dpjBtn];
    _dpjBtn.tag = 100;
    _dpjBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_dpjBtn setTitle:@"待评价" forState:UIControlStateNormal];
    [_dpjBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    [_dpjBtn setTitleColor:[ResourceManager mainColor] forState:UIControlStateSelected];
    [_dpjBtn addTarget:self action:@selector(appraise:) forControlEvents:UIControlEventTouchUpInside];
    _dpjBtn.selected = YES;
    
    _wdpjBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, NavHeight, SCREEN_WIDTH/2, 50)];
    [self.view addSubview:_wdpjBtn];
    _wdpjBtn.tag = 101;
    _wdpjBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_wdpjBtn setTitle:@"我的评价" forState:UIControlStateNormal];
    [_wdpjBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    [_wdpjBtn setTitleColor:[ResourceManager mainColor] forState:UIControlStateSelected];
    [_wdpjBtn addTarget:self action:@selector(appraise:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, NavHeight + 50 - 0.5, SCREEN_WIDTH, 0.5)];
    [self.view addSubview:lineView];
    lineView.backgroundColor = [ResourceManager color_5];
    
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

-(void)appraise:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    if (sender.tag == 100) {
        _dpjBtn.selected = YES;
        _wdpjBtn.selected = NO;
    }else{
        _dpjBtn.selected = NO;
        _wdpjBtn.selected = YES;
    }
    
    self.pageIndex = 1;
    [self loadData];
    
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
        //根据数据计算当前cell高度
       return  [self currentCellHeightSave:self.dataArray[indexPath.row]];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return  [self noDataCell:tableView];
    }
    NSString *cellID = [NSString stringWithFormat:@"%ld_AppraiseList_cell",indexPath.row];
    AppraiseListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[AppraiseListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    if (_dpjBtn.selected) {
        cell.appraiseType = 1;
    }else{
        cell.appraiseType = 2;
    }
    cell.dataDicionary =  dic;
    cell.checkOrderBlock = ^{
        //查看订单
        OrderDetailsViewController *ctl = [[OrderDetailsViewController alloc]init];
        ctl.orderNo = [dic objectForKey:@"orderNo"];
        [self.navigationController pushViewController:ctl animated:YES];
    };
    cell.appraiseBlock = ^{
        //评价
        AppraiseViewController *ctl = [[AppraiseViewController alloc]init];
        ctl.orderNo = [dic objectForKey:@"orderNo"];
        [self.navigationController pushViewController:ctl animated:YES];
    };
    cell.reviewAppraiseBlock = ^{
        //写追评
        ReviewAppraiseViewController *ctl = [[ReviewAppraiseViewController alloc]init];
        ctl.orderDataDic = dic;
        [self.navigationController pushViewController:ctl animated:YES];
    };
    cell.clickEnlargeBlock = ^(int touchTag){
        NSString *imgUrl;
        if (touchTag < 100) {
            //3.分隔字符串
            NSString *imgUrls =[NSString stringWithFormat:@"%@",[dic objectForKey:@"imgUrl"]];
            NSArray *imgArr = [imgUrls componentsSeparatedByString:@","]; //从字符A中分隔成多个元素的数组
            imgUrl = imgArr[touchTag];
        }else{
            //3.分隔字符串
            NSString *imgUrls =[NSString stringWithFormat:@"%@",[dic objectForKey:@"appendImgUrl"]];
            NSArray *imgArr = [imgUrls componentsSeparatedByString:@","]; //从字符A中分隔成多个元素的数组
            imgUrl = imgArr[touchTag - 100];
        }
        //点击图片放大
        [self clickEnlargeImg:imgUrl];
    };
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //（这种是没有点击后的阴影效果)
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (self.dataArray.count == 0) {
        return;
    }
    
}

#pragma mark---点击图片放大
-(void)clickEnlargeImg:(NSString *)imgUrl{
    [_aleartView  removeFromSuperview];
    
    _aleartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_aleartView];
    _aleartView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    
    UIImageView *imgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - SCREEN_WIDTH)/2, SCREEN_WIDTH, SCREEN_WIDTH)];
    [_aleartView addSubview:imgview];
    [imgview sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * tapGeture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenAlert)];
    tapGeture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:tapGeture];
   
}

//点击背景消失弹窗
-(void)hidenAlert{
    [_aleartView removeFromSuperview];
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
