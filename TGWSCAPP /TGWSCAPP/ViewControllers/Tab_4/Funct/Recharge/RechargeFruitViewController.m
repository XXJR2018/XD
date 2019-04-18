//
//  RechargeFruitViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/3/18.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "RechargeFruitViewController.h"

@interface RechargeFruitViewController ()

@end

@implementation RechargeFruitViewController

-(void)queryRechargeUrl{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"configId"] = self.configId;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/cust/recharge/queryPaySucInfo",[PDAPI getBaseUrlString]]
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
        [self RechargeSuccessUI:operation.jsonResult.attr];
    }
    
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNaviBarViewWithTitle:@"充值"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.configId.length > 0) {
        //发送通知更新用户信息
        [[NSNotificationCenter defaultCenter] postNotificationName:DDGNotificationAccountNeedRefresh object:nil];
        [self queryRechargeUrl];
    }else{
        [self RechargeFail];
    }
    
}

-(void)clickNavButton:(UIButton *)button{
    if (self.configId.length > 0) {
       [self.navigationController popToRootViewControllerAnimated:YES];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)RechargeSuccessUI:(NSDictionary *)dic{
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 50)/2, NavHeight + 25, 50, 50)];
    [self.view addSubview:imgView];
    imgView.image = [UIImage imageNamed:@"Recharge-7"];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame), SCREEN_WIDTH, 60)];
    [self.view addSubview:titleLabel];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textColor = [ResourceManager color_1];
    titleLabel.text = @"充值成功";
    
    UIView *rechargeInfoView =[[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLabel.frame) + 5, SCREEN_WIDTH - 40, 100)];
    [self.view addSubview:rechargeInfoView];
    rechargeInfoView.backgroundColor = [ResourceManager viewBackgroundColor];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(rechargeInfoView.size.width/2, 10, 0.5, rechargeInfoView.size.height - 20)];
    [rechargeInfoView addSubview:lineView];
    lineView.backgroundColor = [ResourceManager color_5];
    
    UILabel *gwjTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, CGRectGetMinX(lineView.frame), 20)];
    [rechargeInfoView addSubview:gwjTitleLabel];
    gwjTitleLabel.textAlignment = NSTextAlignmentCenter;
    gwjTitleLabel.font = [UIFont systemFontOfSize:12];
    gwjTitleLabel.textColor = [ResourceManager color_1];
    gwjTitleLabel.text = @"赠送无门槛购物劵";
    
    UILabel *gwjNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(gwjTitleLabel.frame), CGRectGetMinX(lineView.frame), 30)];
    [rechargeInfoView addSubview:gwjNumLabel];
    gwjNumLabel.textAlignment = NSTextAlignmentCenter;
    gwjNumLabel.font = [UIFont boldSystemFontOfSize:15];
    gwjNumLabel.textColor = [ResourceManager color_1];
    gwjNumLabel.text = [NSString stringWithFormat:@"%@元",[dic objectForKey:@"rewardAmonut"]];
    
    UIButton *couponBtn = [[UIButton alloc]initWithFrame:CGRectMake((CGRectGetMinX(lineView.frame) - 80)/2, CGRectGetMaxY(gwjNumLabel.frame), 80, 25)];
    [rechargeInfoView addSubview:couponBtn];
    couponBtn.layer.cornerRadius = 2;
    couponBtn.layer.borderWidth = 0.5;
    couponBtn.layer.borderColor = UIColorFromRGB(0xDDD1B2).CGColor;
    [couponBtn setTitle:@"查看购物劵" forState:UIControlStateNormal];
    couponBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [couponBtn setTitleColor:UIColorFromRGB(0xDDD1B2) forState:UIControlStateNormal];
    [couponBtn addTarget:self action:@selector(coupon) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *balanceTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame), 10, CGRectGetMinX(lineView.frame), 20)];
    [rechargeInfoView addSubview:balanceTitleLabel];
    balanceTitleLabel.textAlignment = NSTextAlignmentCenter;
    balanceTitleLabel.font = [UIFont systemFontOfSize:12];
    balanceTitleLabel.textColor = [ResourceManager color_1];
    balanceTitleLabel.text = @"当前账户余额";
    
    UILabel *balanceNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame), CGRectGetMaxY(gwjTitleLabel.frame), CGRectGetMinX(lineView.frame), 30)];
    [rechargeInfoView addSubview:balanceNumLabel];
    balanceNumLabel.textAlignment = NSTextAlignmentCenter;
    balanceNumLabel.font = [UIFont boldSystemFontOfSize:15];
    balanceNumLabel.textColor = [ResourceManager color_1];
    balanceNumLabel.text = [NSString stringWithFormat:@"%@元",[dic objectForKey:@"usableAmount"]];
    
    
    UIButton *shopBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(rechargeInfoView.frame) + 20, SCREEN_WIDTH - 40, 50)];
    [self.view addSubview:shopBtn];
    shopBtn.layer.cornerRadius = 5;
    shopBtn.backgroundColor = UIColorFromRGB(0xDDD1B2);
    [shopBtn setTitle:@"去购物" forState:UIControlStateNormal];
    shopBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [shopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shopBtn addTarget:self action:@selector(goShop) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
}

-(void)RechargeFail{
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 50)/2, NavHeight + 25, 50, 50)];
    [self.view addSubview:imgView];
    imgView.image = [UIImage imageNamed:@"Recharge-8"];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame) + 15, SCREEN_WIDTH, 20)];
    [self.view addSubview:titleLabel];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [ResourceManager color_1];
    titleLabel.text = @"充值失败";
    
    UILabel *subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), SCREEN_WIDTH, 30)];
    [self.view addSubview:subTitleLabel];
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.font = [UIFont boldSystemFontOfSize:14];
    subTitleLabel.textColor = [ResourceManager color_6];
    subTitleLabel.text = @"请重新尝试";
    
    
    UIButton *rechargeBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(subTitleLabel.frame) + 30, SCREEN_WIDTH - 40, 50)];
    [self.view addSubview:rechargeBtn];
    rechargeBtn.layer.cornerRadius = 5;
    rechargeBtn.backgroundColor = UIColorFromRGB(0xDDD1B2);
    [rechargeBtn setTitle:@"继续充值" forState:UIControlStateNormal];
    rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rechargeBtn addTarget:self action:@selector(recharge) forControlEvents:UIControlEventTouchUpInside];
}

-(void)goShop{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(1)}];
}

-(void)coupon{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(4),@"index":@(3)}];
}

-(void)recharge{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
