//
//  RechargeViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/3/11.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "RechargeViewController.h"

#import "RechargeFruitViewController.h"
#import <AlipaySDK/AlipaySDK.h>

@interface RechargeViewController ()
{
    UIScrollView *_scView;
    UILabel *_balanceLabel;
    
    UIButton *_amountBtn;
    NSMutableArray *_amountBtnArr;
    NSDictionary *_rechargeData;
    
    UIButton *_zfbPayBtn;
    UIButton *_wxPayBtn;
    
}
@end

@implementation RechargeViewController

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/cust/recharge/queryRechargeList",[PDAPI getBaseUrlString]]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
    operation.tag = 1000;
}

-(void)RechargeUrl{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_zfbPayBtn.selected) {
        params[@"payType"] = @"2";
        params[@"payCode"] = @"appAlipay";
    }else{
        params[@"payType"] = @"1";
        params[@"payCode"] = @"appWxpay";
    }
    params[@"configId"] = [_rechargeData objectForKey:@"configId"];
    params[@"rechargeAmonut"] = [_rechargeData objectForKey:@"rechargeAmonut"];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/cust/recharge/goRecharge",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
    operation.tag = 1001;
}

#pragma mark 数据操作
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
   
    if (operation.tag == 1000) {
        if (operation.jsonResult.rows.count > 0) {
            [self.dataArray addObjectsFromArray:operation.jsonResult.rows ];
            [self layoutUI];
        }
        if ([operation.jsonResult.attr objectForKey:@"usableAmount"]) {
            _balanceLabel.text = [NSString stringWithFormat:@"%.2f",[[operation.jsonResult.attr objectForKey:@"usableAmount"] floatValue]];
        }
    }else if (operation.tag == 1001) {
        if ([operation.jsonResult.attr objectForKey:@"payParams"]) {
            if (_zfbPayBtn.selected) {
                //支付宝支付
                [self ailiPay:[operation.jsonResult.attr objectForKey:@"payParams"]];
            }else{
                //微信支付
                [self weChatPay:[operation.jsonResult.attr objectForKey:@"payParams"]];
            }
        }
    }
    
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"充值"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"充值"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"充值"];
    
    // 支付宝支付结果通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ailiPayReslut:) name:DDGPayResultNotification object:nil];
}

-(void)layoutUI{
    
    _scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:_scView];
    _scView.backgroundColor = [UIColor whiteColor];
    _scView.showsVerticalScrollIndicator = NO;
    
    UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 251 * ScaleSize)];
    [_scView addSubview:bgImgView];
    bgImgView.image = [UIImage imageNamed:@"Recharge-1"];
    
    UILabel *balanceTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(40 * ScaleSize, 70 * ScaleSize, 100, 30)];
    [bgImgView addSubview:balanceTitleLabel];
    balanceTitleLabel.font = [UIFont systemFontOfSize:14];
    balanceTitleLabel.textColor = [UIColor whiteColor];
    balanceTitleLabel.text = @"当前余额（元）";
    
    _balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(balanceTitleLabel.frame), CGRectGetMaxY(balanceTitleLabel.frame), 200, 50)];
    [bgImgView addSubview:_balanceLabel];
    _balanceLabel.font = [UIFont boldSystemFontOfSize:35];
    _balanceLabel.textColor = [UIColor whiteColor];
    
    UIView *rechargeView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(bgImgView.frame) - 40, 2, 15)];
    [_scView addSubview:rechargeView];
    rechargeView.backgroundColor = UIColorFromRGB(0xD8B576);
    
    UILabel *rechargeTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(rechargeView.frame)+ 5, CGRectGetMidY(rechargeView.frame) - 10, 100, 20)];
    [_scView addSubview:rechargeTitleLabel];
    rechargeTitleLabel.font = [UIFont boldSystemFontOfSize:15];
    rechargeTitleLabel.textColor = [ResourceManager color_1];
    rechargeTitleLabel.text = @"充值金额";
    
    CGFloat btnWidth = 160 * ScaleSize;
    CGFloat btnHeight = 81 * ScaleSize;
    NSInteger count = 0;
    if (self.dataArray.count%2 == 0) {
        count = self.dataArray.count/2;
    }else{
        count = self.dataArray.count/2 + 1;
    }
    _amountBtnArr = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        for (int j = 0; j < 2; j++) {
            if (i * 2 + j < self.dataArray.count) {
                NSDictionary *dic = self.dataArray[i * 2 + j];
                _amountBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - btnWidth * 2)/2 + btnWidth * j, CGRectGetMaxY(rechargeTitleLabel.frame) + 20 + btnHeight * i, btnWidth, btnHeight)];
                [_scView addSubview:_amountBtn];
                [_amountBtn setImage:[UIImage imageNamed:@"Recharge-2"] forState:UIControlStateNormal];
                [_amountBtn setImage:[UIImage imageNamed:@"Recharge-3"] forState:UIControlStateSelected];
                [_amountBtn setImage:[UIImage imageNamed:@"Recharge-2"] forState:UIControlStateHighlighted];
                [_amountBtn setImage:[UIImage imageNamed:@"Recharge-3"] forState:UIControlStateSelected | UIControlStateHighlighted];
                _amountBtn.tag = i * 2 + j;
                [_amountBtn addTarget:self action:@selector(amountTouch:) forControlEvents:UIControlEventTouchUpInside];
                
                UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15 * ScaleSize, _amountBtn.frame.size.width, 30)];
                [_amountBtn addSubview:numLabel];
                numLabel.font = [UIFont boldSystemFontOfSize:16];
                numLabel.textAlignment = NSTextAlignmentCenter;
                numLabel.textColor = [ResourceManager color_1];
                numLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"rechargeAmonut"]];;
                
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(numLabel.frame), _amountBtn.frame.size.width, 20)];
                [_amountBtn addSubview:titleLabel];
                titleLabel.font = [UIFont systemFontOfSize:12];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.textColor = [ResourceManager color_6];
                titleLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"rechargeDesc"]];
                
                [_amountBtnArr addObject:_amountBtn];
            }
        }
    }
    ((UIButton *)_amountBtnArr[0]).selected = YES;
    _rechargeData = self.dataArray[0];
    
    for (int i = 0; i < 2; i++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_amountBtn.frame) + 20 + 45 * i, 20, 20)];
        [_scView addSubview:imgView];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgView.frame)+ 5, CGRectGetMidY(imgView.frame) - 10, 100, 20)];
        [_scView addSubview:titleLabel];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [ResourceManager color_1];
        
        if (i == 0) {
            imgView.image = [UIImage imageNamed:@"Recharge-4"];
            titleLabel.text = @"支付宝支付";
            _zfbPayBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40, CGRectGetMidY(imgView.frame) - 10, 20, 20)];
            [_scView addSubview:_zfbPayBtn];
            [_zfbPayBtn setImage:[UIImage imageNamed:@"Tab_4-25"] forState:UIControlStateNormal];
            [_zfbPayBtn setImage:[UIImage imageNamed:@"Tab_4-26"] forState:UIControlStateSelected];
            _zfbPayBtn.tag = i;
            [_zfbPayBtn addTarget:self action:@selector(payTypeTouch:) forControlEvents:UIControlEventTouchUpInside];
            _zfbPayBtn.selected = YES;
        }else{
            imgView.image = [UIImage imageNamed:@"Recharge-5"];
            titleLabel.text = @"微信支付";
            _wxPayBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40, CGRectGetMidY(imgView.frame) - 10, 20, 20)];
            [_scView addSubview:_wxPayBtn];
            [_wxPayBtn setImage:[UIImage imageNamed:@"Tab_4-25"] forState:UIControlStateNormal];
            [_wxPayBtn setImage:[UIImage imageNamed:@"Tab_4-26"] forState:UIControlStateSelected];
            _wxPayBtn.tag = i;
            [_wxPayBtn addTarget:self action:@selector(payTypeTouch:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    UIImageView *rechargeImg = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 309 * ScaleSize)/2, CGRectGetMaxY(_wxPayBtn.frame) + 15, 309 * ScaleSize, 70 * ScaleSize)];
    [_scView addSubview:rechargeImg];
     rechargeImg.image = [UIImage imageNamed:@"Recharge-6"];
    rechargeImg.userInteractionEnabled = YES;
    
    UIButton *rechargeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 10, rechargeImg.frame.size.width, rechargeImg.frame.size.height - 20)];
    [rechargeImg addSubview:rechargeBtn];
    [rechargeBtn setTitle:@"立即充值" forState:UIControlStateNormal];
    rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rechargeBtn setTitleColor:UIColorFromRGB(0x8F7D58) forState:UIControlStateNormal];
    [rechargeBtn addTarget:self action:@selector(recharge) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *rechargeTreatyLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(rechargeImg.frame), SCREEN_WIDTH, 20)];
    [_scView addSubview:rechargeTreatyLabel];
    rechargeTreatyLabel.textAlignment = NSTextAlignmentCenter;
    rechargeTreatyLabel.font = [UIFont systemFontOfSize:12];
    rechargeTreatyLabel.textColor = [ResourceManager color_1];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]
                                          initWithString:@"点击立即充值，即表示已阅读并同意充值活动协议"];
    [attrStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xD8B576) range:NSMakeRange(attrStr.length - 6, 6)];
    rechargeTreatyLabel.attributedText = attrStr;
    
    UIButton *treatyBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 60, CGRectGetMinY(rechargeTreatyLabel.frame), 80, 20)];
    [_scView addSubview:treatyBtn];
    [treatyBtn addTarget:self action:@selector(treaty) forControlEvents:UIControlEventTouchUpInside];
    
    _scView.contentSize = CGSizeMake(0, CGRectGetMaxY(rechargeTreatyLabel.frame) + 20);
}

//查看协议
-(void)treaty{
    NSString *url = [NSString stringWithFormat:@"%@webMall/protocol/recharge",[PDAPI WXSysRouteAPI]];
    [CCWebViewController showWithContro:self withUrlStr:url withTitle:@"充值活动协议"];
}

//选择额度
-(void)amountTouch:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    ((UIButton *)_amountBtnArr[0]).selected = NO;
    _rechargeData = nil;
    if (sender != _amountBtn) {
        _amountBtn.selected = NO;
        _amountBtn = sender;
    }
    _amountBtn.selected = YES;
    _rechargeData = self.dataArray[sender.tag];
  
}

//选择支付方式
-(void)payTypeTouch:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    if (sender.tag == 0) {
        _zfbPayBtn.selected = YES;
        _wxPayBtn.selected = NO;
    }else{
        _zfbPayBtn.selected = NO;
        _wxPayBtn.selected = YES;
    }
}

#pragma mark --- 充值
-(void)recharge{
    [self RechargeUrl];
}

-(void)weChatPay:(NSDictionary*)payParams {
    if (payParams.count == 0) {
        return;
    }
    DDGWeChat *manager = [DDGWeChat getSharedWeChat];
    manager.payblock = ^(id obj) {
        BaseResp *resp = ( BaseResp *) obj;
        if (resp.errCode == 0){
            // 支付成功
            RechargeFruitViewController *ctl = [[RechargeFruitViewController alloc]init];
            ctl.configId = [NSString stringWithFormat:@"%@",[_rechargeData objectForKey:@"configId"]];
            [self.navigationController pushViewController:ctl animated:YES];
        }else{
            // 支付失败
            RechargeFruitViewController *ctl = [[RechargeFruitViewController alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
        }
    };
    
    // 微信支付
    WXPayModel *model = [[WXPayModel alloc] init];
    model.partnerId = payParams[@"mchId"];
    model.prepayid = payParams[@"prepayId"];
    model.timestamp = [NSString stringWithFormat:@"%@",payParams[@"timeStamp"]];
    model.sign = payParams[@"sign"];
    model.noncestr = payParams[@"nonceStr"];
    model.appid = payParams[@"appId"];
    model.partner_key = APPSecret_WC;
    [manager wxPayWith:model];
    
}

-(void)ailiPay:(NSDictionary*)payParams {
    if (payParams.count == 0) {
        return;
    }
    
    //应用注册scheme,在XXXX-Info.plist定义URL types
    NSString *appScheme = @"TGWSCAPP";
    NSString *orderInfo = payParams[@"orderInfo"];
    [[AlipaySDK defaultService] payOrder:orderInfo fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
    }];
    
}

#pragma mark ---通知事件
-(void) ailiPayReslut:(NSNotification *)notification{
    NSLog(@"ailiPayReslut user info is %@",notification.object);
    NSDictionary *dic = notification.object;
    
    if (dic){
        NSString *memo = dic[@"memo"];
        NSString *result = dic[@"result"];
        NSString *resultStatus = dic[@"resultStatus"];
        
        NSLog(@"memo: %@ result: %@  resultStatus: %@",memo,result,resultStatus);
        //    9000 订单支付成功
        //    8000 正在处理中
        //    4000 订单支付失败
        //    6001 用户中途取消
        //    6002 网络连接出错
        
        if ([resultStatus isEqualToString:@"9000"]){
            // 支付成功
            RechargeFruitViewController *ctl = [[RechargeFruitViewController alloc]init];
            ctl.configId = [NSString stringWithFormat:@"%@",[_rechargeData objectForKey:@"configId"]];
            [self.navigationController pushViewController:ctl animated:YES];
        }else if ([resultStatus isEqualToString:@"6001"]){
            // 用户取消
        }else{
            // 支付错误
            RechargeFruitViewController *ctl = [[RechargeFruitViewController alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
        }
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
