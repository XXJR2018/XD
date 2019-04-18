//
//  AccountSecurityViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/25.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "AccountSecurityViewController.h"

#import "PhoneCheckViewController.h"
#import "paymentPWViewController.h"

@interface AccountSecurityViewController ()

@end

@implementation AccountSecurityViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"账户安全"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"账户安全"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"账户安全"];
    
    if ([[[CommonInfo userInfo] objectForKey:@"hasTradePwd"] intValue] == 1) {
        [self layoutUI_2];
    }else{
        [self layoutUI_1];
    }
    
}

-(void)layoutUI_1{
    
    UIButton *SZBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, NavHeight + 10, SCREEN_WIDTH, 50)];
    [self.view addSubview:SZBtn];
    SZBtn.backgroundColor = [UIColor whiteColor];
    SZBtn.tag = 101;
    [SZBtn addTarget:self action:@selector(payPassWordTpuch:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *SZtitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 50)];
    [SZBtn addSubview:SZtitleLabel];
    SZtitleLabel.textColor = [ResourceManager color_1];
    SZtitleLabel.font = [UIFont systemFontOfSize:14];
    SZtitleLabel.text = @"设置支付密码";
    
    UIImageView *SZJTImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 25, (50 - 16)/2, 9, 16)];
    [SZBtn addSubview:SZJTImgView];
    SZJTImgView.image = [UIImage imageNamed:@"arrow_right"];
    
}


-(void)layoutUI_2{
    
    UIButton *XGBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, NavHeight + 10, SCREEN_WIDTH, 50)];
    [self.view addSubview:XGBtn];
    XGBtn.backgroundColor = [UIColor whiteColor];
    XGBtn.tag = 102;
    [XGBtn addTarget:self action:@selector(payPassWordTpuch:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *XGtitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 50)];
    [XGBtn addSubview:XGtitleLabel];
    XGtitleLabel.textColor = [ResourceManager color_1];
    XGtitleLabel.font = [UIFont systemFontOfSize:14];
    XGtitleLabel.text = @"修改支付密码";
    
    UIImageView *XGJTImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 25, (50 - 16)/2, 9, 16)];
    [XGBtn addSubview:XGJTImgView];
    XGJTImgView.image = [UIImage imageNamed:@"arrow_right"];
    
    UIButton *WJBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(XGBtn.frame) + 10, SCREEN_WIDTH, 50)];
    [self.view addSubview:WJBtn];
    WJBtn.backgroundColor = [UIColor whiteColor];
    WJBtn.tag = 103;
    [WJBtn addTarget:self action:@selector(payPassWordTpuch:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *WJtitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 50)];
    [WJBtn addSubview:WJtitleLabel];
    WJtitleLabel.textColor = [ResourceManager color_1];
    WJtitleLabel.font = [UIFont systemFontOfSize:14];
    WJtitleLabel.text = @"忘记支付密码";
    
    UIImageView *WJJTImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 25, (50 - 16)/2, 9, 16)];
    [WJBtn addSubview:WJJTImgView];
    WJJTImgView.image = [UIImage imageNamed:@"arrow_right"];
    
}

-(void)payPassWordTpuch:(UIButton *)sender{
    switch (sender.tag) {
        case 101:{
            //设置密码
            PhoneCheckViewController *ctl = [[PhoneCheckViewController alloc]init];
            ctl.titleStr = @"设置支付密码";
            [self.navigationController pushViewController:ctl animated:YES];
        }break;
        case 102:{
            //修改密码
            paymentPWViewController *ctl = [[paymentPWViewController alloc]init];
            ctl.titleStr = @"修改支付密码";
            [self.navigationController pushViewController:ctl animated:YES];
        }break;
        case 103:{
            //忘记密码
            PhoneCheckViewController *ctl = [[PhoneCheckViewController alloc]init];
            ctl.titleStr = @"忘记支付密码";
            [self.navigationController pushViewController:ctl animated:YES];
        }break;
        default:
            break;
    }
    
}

@end
