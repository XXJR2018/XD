//
//  RechargeDetailsViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/3/11.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "RechargeDetailsViewController.h"

@interface RechargeDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lshNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *rechargeType;
@property (weak, nonatomic) IBOutlet UILabel *rechargeNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTop;
@end

@implementation RechargeDetailsViewController

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"recordId"] = self.recordId;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/cust/recharge/queryRechargeDtl",[PDAPI getBaseUrlString]]
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
    if (operation.jsonResult.attr.count > 0) {
        NSDictionary *dic = operation.jsonResult.attr;
        self.lshNumLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"tradeId"]];
        self.rechargeType.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"fundType"]];
        self.rechargeNumLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"amount"]];
        self.timeLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"createTime"]];
        self.balanceLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"usableAmount"]];
    }
    
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"充值详情"];
    
    if (iOS11Less) {
        self.layoutTop.constant = NavHeight;
    }
    
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
