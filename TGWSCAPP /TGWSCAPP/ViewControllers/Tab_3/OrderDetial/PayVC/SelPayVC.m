//
//  SelPayVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/5.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "SelPayVC.h"
#import "PayResultVC.h"
#import "OrderViewController.h"
#import <AlipaySDK/AlipaySDK.h>



#define    CheckImg         @"od_gou2"
#define    UnCheckImg       @"od_gou1"

@interface SelPayVC ()
{
    UIView *viewHead;
    UIView *viewPay;
    
    NSMutableArray *arrBtn;
    int iSelPay;  // 1 - 微信支付，  2 - 支付宝支付
}
@end

@implementation SelPayVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 支付宝支付结果通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ailiPayReslut:) name:DDGPayResultNotification object:nil];
    
    [self layoutNaviBarViewWithTitle:@"选择支付方法"];
    
    [self initData];
    
    [self layoutUI];
    
    
}

-(void) initData
{
    arrBtn = [[NSMutableArray alloc] init];
    iSelPay = 0;
}

#pragma mark --- 布局UI
-(void) layoutUI
{
    [self layoutHead];
    
    [self layoutPay];
}

-(void)layoutHead
{
    viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, 130)];
    [self.view addSubview:viewHead];
    viewHead.backgroundColor = [UIColor whiteColor];
    
    int iTopY = 15;
    UILabel *lableTile = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [viewHead addSubview:lableTile];
    lableTile.textColor = [ResourceManager midGrayColor];
    lableTile.font = [UIFont systemFontOfSize:14];
    lableTile.textAlignment = NSTextAlignmentCenter;
    lableTile.text = @"应付金额";
    
    iTopY += lableTile.height +10;
    UILabel *lablePrice = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 30)];
    [viewHead addSubview:lablePrice];
    lablePrice.textColor = [ResourceManager priceColor];
    lablePrice.font = [UIFont systemFontOfSize:25];
    lablePrice.textAlignment = NSTextAlignmentCenter;
    lablePrice.text = [NSString stringWithFormat:@"¥%@", _dicPay[@"payAmt"]];//@"¥17.50";
    
    
    iTopY += lablePrice.height +10;
    UILabel *lableOrderNO = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [viewHead addSubview:lableOrderNO];
    lableOrderNO.textColor = [ResourceManager midGrayColor];
    lableOrderNO.font = [UIFont systemFontOfSize:12];
    lableOrderNO.textAlignment = NSTextAlignmentCenter;
    lableOrderNO.text = [NSString stringWithFormat:@"订单编号:%@", _dicPay[@"orderNo"]];
    
}


-(void) layoutPay
{
    int iCellHeight = 60;
    int iTopY = viewHead.top + viewHead.height + 10;
    int iLeftX = 0;
    viewPay = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH, 130)];
    [self.view addSubview:viewPay];
    //viewPay.backgroundColor = [UIColor yellowColor];
    
    NSArray *arrName = @[@"微信支付",@"支付宝"];
    NSArray *arrImg = @[@"pay_wx",@"pay_zfb"];
    
    iTopY = 0;
    for(int i= 0 ; i <[arrName count]; i++)
     {
        iLeftX = 15;
        UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iCellHeight)];
        [viewPay addSubview:viewCell];
        viewCell.tag = i;
        viewCell.backgroundColor = [UIColor whiteColor];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, (iCellHeight-30)/2, 30, 30)];
        [viewCell addSubview:imgView];
        imgView.image = [UIImage imageNamed:arrImg[i]];
        
        iLeftX += imgView.width + 10;
        UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, 0, 150, iCellHeight)];
        [viewCell addSubview:labelName];
        labelName.font = [UIFont systemFontOfSize:14];
        labelName.textColor = [ResourceManager color_1];
        labelName.text = arrName[i];
        
        

        
        UIButton *btnUse = [[UIButton alloc] initWithFrame:CGRectMake(viewCell.width - 35, (iCellHeight-18)/2, 18, 18)];
        [viewCell addSubview:btnUse];
        [btnUse setImage:[UIImage imageNamed:UnCheckImg] forState:UIControlStateNormal];
        [btnUse setImage:[UIImage imageNamed:CheckImg] forState:UIControlStateSelected];
        btnUse.selected = NO;
        btnUse.userInteractionEnabled = NO;
        
        [arrBtn addObject:btnUse];
        
        
        if (i < ([arrName count] - 1))
         {
            UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, iCellHeight-1, SCREEN_WIDTH, 1)];
            [viewCell addSubview:viewFG];
            viewFG.backgroundColor = [ResourceManager color_5];
         }
        
        //添加手势, 选择券
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionSelPay:)];
        gesture.numberOfTapsRequired  = 1;
        [viewCell addGestureRecognizer:gesture];
        
        iTopY += iCellHeight;
     }
    
    iTopY += 30;
    UIButton *btnPay = [[UIButton alloc] initWithFrame:CGRectMake(15, iTopY, SCREEN_WIDTH - 30, 40)];
    [viewPay addSubview:btnPay];
    btnPay.backgroundColor = [ResourceManager priceColor];
    btnPay.cornerRadius = 3;
    [btnPay setTitle:@"确认支付" forState:UIControlStateNormal];
    btnPay.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnPay addTarget:self action:@selector(actionPay) forControlEvents:UIControlEventTouchUpInside];
    
    iTopY+= btnPay.height +10;
    
    viewPay.height = iTopY;
}


-(void) AllUnCheck
{
    for (int i= 0; i < [arrBtn count]; i++)
     {
        UIButton *btnTemp = arrBtn[i];
        btnTemp.selected = NO;
     }
}


#pragma mark ---  action
-(void)clickNavButton:(UIButton *)button{
    
    
    CDWAlertView *alertView = [[CDWAlertView alloc] init];
    
    alertView.shouldDismissOnTapOutside = NO;
    alertView.textAlignment = RTTextAlignmentCenter;
    
    // 降低高度,加入标题
    [alertView subAlertCurHeight:20];
    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 18 color=#000000>确定要放弃付款吗？</font>"]];
    
    // 加入message
    NSString *strXH= [NSString stringWithFormat:@"订单会保留一段时间，请尽快支付。"];
    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 15 color=#333333> %@ </font>",strXH]];
    
    
    [alertView addCanelButton:@"取消" actionBlock:^{
        
    }];
    
    [alertView addButton:@"确定" color:[ResourceManager mainColor] actionBlock:^{
        
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.5];// 延迟执行
        //[self performSelector:@selector(delayMethod) withObject:nil afterDelay:1];// 延迟执行
        
    }];
    
    [alertView showAlertView:self.parentViewController duration:0.0];
    
    
   
}

-(void) delayMethod
{
    //[self.navigationController popToRootViewControllerAnimated:NO];
    //[[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(4),@"index":@(0)}];
    OrderViewController *ctl = [[OrderViewController alloc]init];
    ctl.orderIndex = 1;
    [self.navigationController pushViewController:ctl animated:YES];
}

-(void) actionSelPay:(UITapGestureRecognizer*) reg
{
    [self AllUnCheck];
    int iTag = (int)reg.view.tag;
    iSelPay = iTag + 1;

    if (iTag < [arrBtn count])
     {
        UIButton *btnTemp = arrBtn[iTag];
        btnTemp.selected = YES;
     }
}

-(void) actionPay
{
    //本地支付方式定义  int iSelPay;  // 1 - 微信支付，  2 - 支付宝支付
    
    //后台的支付方式定义
    //payType  支付类型(1-微信 2- 支付宝)
    if (iSelPay == 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请选择支付方式" toView:self.view];
        return;
     }
    
    if (1== iSelPay)
     {
        [self getWeiXinOrderInfo];
     }
    else if (2 == iSelPay)
     {
        [self getALiOrderInfo];
     }
}

-(void) weChatPay:(NSDictionary*) dicWeChatOrderInof
{
    DDGWeChat *manager = [DDGWeChat getSharedWeChat];

    __weak typeof(self) weakSelf = self;
    
    manager.payblock = ^(id obj) {
        BaseResp *resp = ( BaseResp *) obj;
        
        if (0 == resp.errCode)
         {
            // 支付成功
            PayResultVC  *VC = [[PayResultVC alloc] init];
            VC.isSuceess = YES;
            [self.navigationController pushViewController:VC animated:YES];
            
         }
        else if (-2 == resp.errCode)
         {
            // 用户取消
         }
        else
         {
            // 支付错误
            PayResultVC  *VC = [[PayResultVC alloc] init];
            VC.dicPayResult = weakSelf.dicPay;
            [self.navigationController pushViewController:VC animated:YES];
         }
    };
    
    NSDictionary *payParams = [dicWeChatOrderInof objectForKey:@"payParams"];
    if (!payParams)
     {
        [MBProgressHUD showErrorWithStatus:@"获取微信支付参数错误" toView:self.view];
     }
    
    // 微信支付抢单
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

-(void) ailiPay:(NSDictionary*) dicAiliOrderInfo
{

    
    NSDictionary *payParams = [dicAiliOrderInfo objectForKey:@"payParams"];
    if (!payParams)
     {
        [MBProgressHUD showErrorWithStatus:@"获取支付宝参数错误" toView:self.view];
     }
    
    NSString *orderInfo = payParams[@"orderInfo"];
    
    //应用注册scheme,在XXXX-Info.plist定义URL types
    NSString *appScheme = @"TGWSCAPP";
    
    [[AlipaySDK defaultService] payOrder:orderInfo fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
    }];
}

#pragma mark --- 网络请求
-(void) getWeiXinOrderInfo
{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLgoPay];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"payType"] = @(1);
    params[@"payCode"] = @"appWxpay";
   params[@"orderNo"] = [_dicPay objectForKey:@"orderNo"];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}

-(void) getALiOrderInfo
{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLgoPay];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"payType"] = @(2);
    params[@"payCode"] = @"appAlipay";
    params[@"orderNo"] = [_dicPay objectForKey:@"orderNo"];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 1001;
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (1000 == operation.tag )
     {
        [self weChatPay:operation.jsonResult.attr];
     }
    if (1001 == operation.tag )
     {
        [self ailiPay:operation.jsonResult.attr];
     }
}



-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    
}



#pragma mark ---通知事件
-(void) ailiPayReslut:(NSNotification *)notification
{
    NSLog(@"ailiPayReslut user info is %@",notification.object);
    NSDictionary *dic = notification.object;
    
    if (dic)
     {
        NSString *memo = dic[@"memo"];
        NSString *result = dic[@"result"];
        NSString *resultStatus = dic[@"resultStatus"];
        
        NSLog(@"memo: %@ result: %@  resultStatus: %@",memo,result,resultStatus);
        
        //    9000 订单支付成功
        //    8000 正在处理中
        //    4000 订单支付失败
        //    6001 用户中途取消
        //    6002 网络连接出错
        
        if ([resultStatus isEqualToString:@"9000"])
         {
            // 支付成功
            PayResultVC  *VC = [[PayResultVC alloc] init];
            VC.isSuceess = YES;
            [self.navigationController pushViewController:VC animated:YES];
         }
        else if ([resultStatus isEqualToString:@"6001"])
         {
            // 用户取消
         }
        else
         {
            // 支付错误
            PayResultVC  *VC = [[PayResultVC alloc] init];
            VC.dicPayResult = _dicPay;
            [self.navigationController pushViewController:VC animated:YES];
         }
     }
    

    
    //tradePassword = [dic objectForKey:@"password"] ;
    
}

@end
