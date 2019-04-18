//
//  AddressViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/27.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "AddressViewController.h"

#import "AddAddressViewController.h"
#import "AddressViewCell.h"

@interface AddressViewController ()
{
    UIView *_lineView;
}
@end

@implementation AddressViewController

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kPage] = @(self.pageIndex);
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/custAddr/list",[PDAPI getBaseUrlString]]
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
    [MobClick beginLogPageView:@"地址管理"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"地址管理"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"地址管理"];
    
    [self layoutUI];
}

-(void)layoutUI{
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView setTableFooterView:[UIView new]];
    [_tableView registerNib:[UINib nibWithNibName:@"AddressViewCell" bundle:nil] forCellReuseIdentifier:@"Address_Cell"];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_tableView setSeparatorColor:[ResourceManager color_5]];
    
    UIView *footView = [[UIView alloc]init];
    [_tableView setTableFooterView:footView];
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    [footView addSubview:_lineView];
    _lineView.backgroundColor = [ResourceManager color_5];
    UIButton *addAddressBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 150, SCREEN_WIDTH - 40, 50)];
    [footView addSubview:addAddressBtn];
    addAddressBtn.layer.borderWidth = 0.5;
    addAddressBtn.layer.borderColor = [ResourceManager mainColor].CGColor;
    [addAddressBtn setTitle:@"+ 添加地址" forState:UIControlStateNormal];
    addAddressBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [addAddressBtn setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    [addAddressBtn addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    footView.frame = CGRectMake(0, 10, SCREEN_WIDTH, CGRectGetMaxY(addAddressBtn.frame) + 20);
}

-(void)addAddress{
    AddAddressViewController *ctl = [[AddAddressViewController alloc]init];
    ctl.titleStr = @"新增地址";
    ctl.addressBlock = ^{
        [self loadData];
    };
    [self.navigationController pushViewController:ctl animated:YES];
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
        return tableView.frame.size.height - 230;
    }else{
        return 80;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        _lineView.backgroundColor = [UIColor clearColor];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCel"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableViewCel"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 105)/2, 150, 105, 133.5)];
        imgView.image = [UIImage imageNamed:@"Tab_4-23"];
        [cell.contentView addSubview:imgView];
        return cell;
    }
    _lineView.backgroundColor = [ResourceManager color_5];
    AddressViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Address_Cell"];
    if (!cell) {
        cell = [[AddressViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Address_Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.redactBlock = ^{
        AddAddressViewController *ctl = [[AddAddressViewController alloc]init];
        ctl.titleStr = @"修改地址";
        ctl.addressDic = self.dataArray[indexPath.row];
        ctl.addressBlock = ^{
            [self loadData];
        };
        [self.navigationController pushViewController:ctl animated:YES];
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
    if (self.selectType == 100) {
        NSString *addrId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"addrId"]];
        if (addrId.length > 0) {
            self.selectAddressBlock(addrId);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (self.selectType == 101){
        if (self.selAddressBlock){
            self.selAddressBlock(dic);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        AddAddressViewController *ctl = [[AddAddressViewController alloc]init];
        ctl.titleStr = @"修改地址";
        ctl.addressDic = dic;
        ctl.addressBlock = ^{
            [self loadData];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }

}


@end
