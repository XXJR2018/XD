//
//  AppraiseViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/13.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "AppraiseViewController.h"
#import "IssueAppraiseViewController.h"
#import "ReviewAppraiseViewController.h"
#import "AppraiseViewCell.h"

@interface AppraiseViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@end

@implementation AppraiseViewController

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = self.orderNo;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/orderComment/queryWaitCommList",[PDAPI getBaseUrlString]]
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
    [MobClick beginLogPageView:@"评价"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"评价"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"评价"];
    
    [self layoutUI];
}

-(void)layoutUI{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:_tableView];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setTableFooterView:[UIView new]];
    [_tableView registerNib:[UINib nibWithNibName:@"AppraiseViewCell" bundle:nil] forCellReuseIdentifier:@"Appraise_cell"];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_tableView setSeparatorColor:[ResourceManager color_5]];
    
}

#pragma mark === UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppraiseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Appraise_cell"];
    if (!cell) {
        cell = [[AppraiseViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Appraise_cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.appraiseBlock = ^{
        if ([[dic objectForKey:@"commentStatus"] intValue] == 1) {
            //评价
            IssueAppraiseViewController *ctl = [[IssueAppraiseViewController alloc]init];
            ctl.orderDataDic = dic;
            [self.navigationController pushViewController:ctl animated:YES];
        }else if ([[dic objectForKey:@"commentStatus"] intValue] == 2) {
            //追评
            ReviewAppraiseViewController *ctl = [[ReviewAppraiseViewController alloc]init];
            ctl.orderDataDic = dic;
            [self.navigationController pushViewController:ctl animated:YES];
        }else if ([[dic objectForKey:@"commentStatus"] intValue] == 3) {
            //查看评价
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(4),@"index":@(1)}];
        }
        
    };
    
    cell.dataDicionary = dic;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //（这种是没有点击后的阴影效果)
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
   
   
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
