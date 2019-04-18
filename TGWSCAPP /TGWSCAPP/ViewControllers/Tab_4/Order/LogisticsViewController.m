//
//  LogisticsViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/1/8.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "LogisticsViewController.h"
#import "LogisticsDescViewController.h"

#import "LogisticsViewCell.h"

@interface LogisticsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@end

@implementation LogisticsViewController

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = self.orderNo;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/myOrder/logisticsInfo",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
}

#pragma mark 数据操作
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    if (operation.jsonResult.rows.count > 0) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:operation.jsonResult.rows];
        [_tableView reloadData];
    }

}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"物流详情"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"物流详情"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"物流详情"];
    [self layoutUI];
}

-(void)layoutUI{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    _tableView.backgroundColor = [ResourceManager viewBackgroundColor];
    [self.view addSubview:_tableView];
    [_tableView registerClass:[LogisticsViewCell class] forCellReuseIdentifier:@"logistics_cell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setTableFooterView:[UIView new]];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_tableView setSeparatorColor:[UIColor clearColor]];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *imgUrls =[NSString stringWithFormat:@"%@",[dic objectForKey:@"imgUrls"]];
    NSArray *imgArr = [imgUrls componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
    NSInteger count = 0;
    if (imgArr.count%4 == 0) {
        count = imgArr.count/4;
    }else{
        count = imgArr.count/4 + 1;
    }
    return  125 + 90 * count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LogisticsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"logistics_cell"];
    if (!cell) {
        cell = [[LogisticsViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"logistics_cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    cell.dataDicionary = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //（这种是没有点击后的阴影效果)
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSDictionary *dic = self.dataArray[indexPath.row];
    LogisticsDescViewController *ctl = [[LogisticsDescViewController alloc]init];
    ctl.logisticsId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"logisticsId"]];
    [self.navigationController pushViewController:ctl animated:YES];
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
