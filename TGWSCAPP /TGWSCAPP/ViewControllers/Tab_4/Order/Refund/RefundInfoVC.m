//
//  RefundInfoVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/9.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "RefundInfoVC.h"
#import "CustomerServiceViewController.h"
#import "RefundScheduleVC.h"
#import "RefundTXWLVC.h"
#import "RefundReCommitVC.h"

@interface RefundInfoVC ()
{
    UIScrollView *scView;
    
    UIView *viewHead; // 退款头部
    
    UIView *viewShop;  // 退款商品信息
    
    
    NSDictionary *dicUI;
    
    int iServerStatus; //0-待处理  1-商家待收货 2-同意退款 3 -同意退款退货 4-商家收到货 5-退款成功 6-退款失败 7-商家拒绝退款 8-取消申请(交易关闭)

}


@property(nonatomic, strong)UIImageView *productImgView;  //商品图片

@property(nonatomic, strong)UILabel *productNameLabel;  //商品名称

@property(nonatomic, strong)UILabel *productDescLabel;    //商品描述

@property(nonatomic, strong)UILabel *productPriceLabel;   //商品价格

@property(nonatomic, strong)UILabel *productNumLabel;   //商品数量

@end

@implementation RefundInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"退款详情"];

    [self initData];
    
    [self getUIDataFromWeb];
    
}

-(void) initData
{
    dicUI = [[NSDictionary alloc] init];
    iServerStatus = 0;
}

#pragma mark --- 布局UI
-(void) layoutUI:(NSDictionary*) dicValue
{
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight - 60)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 500);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [ResourceManager viewBackgroundColor];
    
    [self layoutHead:dicValue];
    
    [self layoutShop:dicValue];
    
    if (3 == iServerStatus)
     {
        UIButton *btnTXWL = [[UIButton alloc] initWithFrame:CGRectMake(15, SCREEN_HEIGHT- 50, SCREEN_WIDTH - 2*15, 40)];
        [self.view addSubview:btnTXWL];
        btnTXWL.backgroundColor = [UIColor whiteColor];
        btnTXWL.layer.borderWidth = 0.5;
        btnTXWL.layer.borderColor = [ResourceManager lightGrayColor].CGColor;
        btnTXWL.cornerRadius = 5;
        [btnTXWL setTitle:@"撤销退款申请" forState:UIControlStateNormal];
        [btnTXWL setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        btnTXWL.titleLabel.font = [UIFont systemFontOfSize:14];
        [btnTXWL addTarget:self action:@selector(actionCanelRequset) forControlEvents:UIControlEventTouchUpInside];
     }
    
}


-(void) layoutHead:(NSDictionary*) dicValue
{
    viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    [scView addSubview:viewHead];
    viewHead.backgroundColor = [UIColor whiteColor];
    
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [viewHead addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager color_5];
    
    
    int iTopY = 15;
    int iLeftX = 10;
    UILabel *labelStatus = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 20)];
    [viewHead addSubview:labelStatus];
    labelStatus.textColor = [ResourceManager priceColor];
    labelStatus.font = [UIFont systemFontOfSize:14];
    labelStatus.text = dicValue[@"serverStatusDesc"];
    
    
    iTopY += labelStatus.height + 10;
    
    NSArray *refundDtlDesc = dicValue[@"refundDtlDesc"];
    if ([refundDtlDesc isKindOfClass:[NSArray class]])
     {
        
        for (int i = 0; i < refundDtlDesc.count; i++)
         {
            UILabel *labelDesc = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 45)];
            [viewHead addSubview:labelDesc];
            //labelDesc.backgroundColor = [UIColor yellowColor];
            labelDesc.textColor = [ResourceManager color_1];
            labelDesc.font = [UIFont systemFontOfSize:12];
            labelDesc.numberOfLines = 0;
            labelDesc.text = refundDtlDesc[i];
            [labelDesc sizeToFit];
            
            iTopY += labelDesc.height + 10;
            
            if (i == refundDtlDesc.count - 1)
             {
                iTopY += 10;
             }
         }
     }
    

    UIView *viewFG2 = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 1)];
    [viewHead addSubview:viewFG2];
    viewFG2.backgroundColor = [ResourceManager color_5];
    

    
    iTopY += viewFG.height + 20;
    UIButton *btnRequest = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 250, iTopY, 70, 25)];
    [viewHead addSubview:btnRequest];
    btnRequest.layer.borderColor = [ResourceManager lightGrayColor].CGColor;
    btnRequest.layer.borderWidth = 1;
    btnRequest.cornerRadius= 3;
    [btnRequest setTitle:@"重新申请" forState:UIControlStateNormal];
    [btnRequest setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    btnRequest.titleLabel.font = [UIFont systemFontOfSize:12];
    [btnRequest addTarget:self action:@selector(actionRequest) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnRecord = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnRequest.frame)+10, iTopY, 70, 25)];
    [viewHead addSubview:btnRecord];
    btnRecord.layer.borderColor = [ResourceManager lightGrayColor].CGColor;
    btnRecord.layer.borderWidth = 1;
    btnRecord.cornerRadius= 3;
    [btnRecord setTitle:@"售后进度" forState:UIControlStateNormal];
    [btnRecord setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    btnRecord.titleLabel.font = [UIFont systemFontOfSize:12];
    [btnRecord addTarget:self action:@selector(actionRrecond) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btnConnect = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(btnRecord.frame)+10, iTopY, 70, 25)];
    [viewHead addSubview:btnConnect];
    btnConnect.layer.borderColor = [ResourceManager lightGrayColor].CGColor;
    btnConnect.layer.borderWidth = 1;
    btnConnect.cornerRadius= 3;
    [btnConnect setTitle:@"联系商家" forState:UIControlStateNormal];
    [btnConnect setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    btnConnect.titleLabel.font = [UIFont systemFontOfSize:12];
    [btnConnect addTarget:self action:@selector(actionConnect) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btnTXWL = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 40)];
    [viewHead addSubview:btnTXWL];
    btnTXWL.backgroundColor = [ResourceManager mainColor];
    btnTXWL.cornerRadius = 5;
    [btnTXWL setTitle:@"填写物流信息" forState:UIControlStateNormal];
    [btnTXWL setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnTXWL.titleLabel.font = [UIFont systemFontOfSize:14];
    btnTXWL.hidden = YES;
    [btnTXWL addTarget:self action:@selector(actionTXWl) forControlEvents:UIControlEventTouchUpInside];


    //0-待处理  1-商家待收货 2-同意退款 3 -同意退款退货 4-商家收到货 5-退款成功 6-退款失败 7-商家拒绝退款 8-取消申请(交易关闭)
    iServerStatus = [dicValue[@"serverStatus"] intValue];

    if (0 == iServerStatus)
     {
        //    0-待处理 （请等待商家处理）
        //    按钮展示：取消申请  售后进度 联系商家
        [btnRequest setTitle:@"取消申请" forState:UIControlStateNormal];
     }
    else if (1 == iServerStatus)
     {
        //    1-商家待收货 (请等待商家收货并退款)
        //    按钮展示： 售后进度 联系商家
        btnRequest.hidden = YES;
     }
    else if (2 == iServerStatus)
     {
        //    2-同意退款 (商家同意退款)
        //    按钮展示： 售后进度 联系商家
        btnRequest.hidden = YES;
     }
    else if (3 == iServerStatus)
     {
        //    3 -同意退款退货（商家同意退款，请退货给商家）
        //    按钮展示： 填写物流
        btnRequest.hidden = YES;
        btnRecord.hidden = YES;
        btnConnect.hidden = YES;
        btnTXWL.hidden = NO;
        
        
     }
    else if (4 == iServerStatus)
     {
        //    4-商家收到货 （商家已收货）
        //    按钮展示： 售后进度 联系商家
        btnRequest.hidden = YES;
     }
    else if (5 == iServerStatus)
     {
        //    5-退款成功
        //    按钮展示： 售后进度 联系商家
        btnRequest.hidden = YES;
     }
    else if (6 == iServerStatus)
     {
        //    6-退款失败
        //    按钮展示： 重新申请 售后进度 联系商家
     }
    else if (7 == iServerStatus)
     {
        //    7-商家拒绝退款
        //    按钮展示： 重新申请 售后进度 联系商家
     }
    else if (8 == iServerStatus)
     {
        //    8-取消申请(交易关闭)
        //    按钮展示： 重新申请 售后进度 联系商家
     }
    
    
    iTopY += btnTXWL.height +20;
    viewHead.height = iTopY;
    
}

-(void) layoutShop:(NSDictionary*) dicValue
{
    NSDictionary  *dic = dicValue;
    
    int iTopY = viewHead.height + 10;
    viewShop = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 300)];
    [scView addSubview:viewShop];
    viewShop.backgroundColor = [UIColor whiteColor];
    
    iTopY = 10;
    int iLeftX = 10;
    UILabel *labelStatus = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 15)];
    [viewShop addSubview:labelStatus];
    labelStatus.textColor = [ResourceManager color_1];
    labelStatus.font = [UIFont systemFontOfSize:12];
    labelStatus.text = @"退款信息";
    
    iTopY += labelStatus.height + 10;
    UIView *viewFG2 = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 1)];
    [viewShop addSubview:viewFG2];
    viewFG2.backgroundColor = [ResourceManager color_5];
    
    
    UIColor *color_1 = [ResourceManager color_1];
    UIColor *color_2 = [ResourceManager color_6];
    UIFont *font_1 = [UIFont systemFontOfSize:13];
    UIFont *font_2 = [UIFont systemFontOfSize:12];
    
    _productImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(viewFG2.frame) + 15, 70, 70)];
    [viewShop addSubview:_productImgView];
    _productImgView.backgroundColor = UIColorFromRGB(0xf6f6f6);
    [_productImgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"goodsUrl"]]];
    
    _productNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_productImgView.frame) + 10, CGRectGetMinY(_productImgView.frame) + 5, 200, 20)];
    [viewShop addSubview:_productNameLabel];
    _productNameLabel.font = font_1;
    _productNameLabel.textColor = color_1;
    _productNameLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"goodsName"]];
    
    _productDescLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_productImgView.frame) + 10, CGRectGetMaxY(_productNameLabel.frame) + 5, 200, 20)];
    [viewShop addSubview:_productDescLabel];
    _productDescLabel.font = font_2;
    _productDescLabel.textColor = color_2;
    _productDescLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"skuDesc"]];
    
    _productPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, CGRectGetMinY(_productImgView.frame) + 5, 150, 20)];
    [viewShop addSubview:_productPriceLabel];
    _productPriceLabel.textAlignment = NSTextAlignmentRight;
    _productPriceLabel.font = font_1;
    _productPriceLabel.textColor = color_2;
    _productPriceLabel.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"refundPrice"]];
    
    _productNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, CGRectGetMaxY(_productPriceLabel.frame) + 5, 150, 20)];
    [viewShop addSubview:_productNumLabel];
    _productNumLabel.textAlignment = NSTextAlignmentRight;
    _productNumLabel.font = font_2;
    _productNumLabel.textColor = color_2;
    _productNumLabel.text = [NSString stringWithFormat:@"x%@",[dic objectForKey:@"refundNum"]];
    
    iTopY = CGRectGetMaxY(_productImgView.frame) + 15;
    UIView *viewFG3 = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 1)];
    [viewShop addSubview:viewFG3];
    viewFG3.backgroundColor = [ResourceManager color_5];
    
    iTopY += viewFG3.height + 20;
    // 退款编码
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 12)];
    [viewShop addSubview:label1];
    label1.textColor = [ResourceManager color_1];
    label1.font = [UIFont systemFontOfSize:12];
    label1.text = @"退款编码";
    
    
    UILabel *label1Value = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -200 - iLeftX, iTopY, 200, 12)];
    [viewShop addSubview:label1Value];
    label1Value.textColor = [ResourceManager color_1];
    label1Value.font = [UIFont systemFontOfSize:12];
    label1Value.textAlignment = NSTextAlignmentRight;
    label1Value.text = dicValue[@"refundNo"]?[NSString stringWithFormat:@"%@", dicValue[@"refundNo"]]:@"";
    
    //申请时间
    iTopY +=  30;
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 12)];
    [viewShop addSubview:label2];
    label2.textColor = [ResourceManager color_1];
    label2.font = [UIFont systemFontOfSize:12];
    label2.text = @"申请时间";
    
    UILabel *label2Value = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -200 - iLeftX, iTopY, 200, 12)];
    [viewShop addSubview:label2Value];
    label2Value.textColor = [ResourceManager color_1];
    label2Value.font = [UIFont systemFontOfSize:12];
    label2Value.textAlignment = NSTextAlignmentRight;
    label2Value.text = dicValue[@"createTime"];
    
    //退款原因
    iTopY +=  30;
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 12)];
    [viewShop addSubview:label3];
    label3.textColor = [ResourceManager color_1];
    label3.font = [UIFont systemFontOfSize:12];
    label3.text = @"退款原因";
    
    UILabel *label3Value = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -200 - iLeftX, iTopY, 200, 12)];
    [viewShop addSubview:label3Value];
    label3Value.textColor = [ResourceManager color_1];
    label3Value.font = [UIFont systemFontOfSize:12];
    label3Value.textAlignment = NSTextAlignmentRight;
    label3Value.text = dicValue[@"resionDesc"]?[NSString stringWithFormat:@"%@", dicValue[@"resionDesc"]]:@"";
    
    //处理方式
    iTopY +=  30;
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 12)];
    [viewShop addSubview:label4];
    label4.textColor = [ResourceManager color_1];
    label4.font = [UIFont systemFontOfSize:12];
    label4.text = @"处理方式";
    
    UILabel *label4Value = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -200 - iLeftX, iTopY, 200, 12)];
    [viewShop addSubview:label4Value];
    label4Value.textColor = [ResourceManager color_1];
    label4Value.font = [UIFont systemFontOfSize:12];
    label4Value.textAlignment = NSTextAlignmentRight;
    label4Value.text = dicValue[@"refundTypeDesc"];
    
    //退款金额
    iTopY +=  30;
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 12)];
    [viewShop addSubview:label5];
    label5.textColor = [ResourceManager color_1];
    label5.font = [UIFont systemFontOfSize:12];
    label5.text = @"退款金额";
    
    UILabel *label5Value = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -200 - iLeftX, iTopY, 200, 12)];
    [viewShop addSubview:label5Value];
    label5Value.textColor = [ResourceManager color_1];
    label5Value.font = [UIFont systemFontOfSize:12];
    label5Value.textAlignment = NSTextAlignmentRight;
    label5Value.text = [NSString stringWithFormat:@"¥%@", dicValue[@"refundTotalAmt"]];
    
    //备注消息
    iTopY +=  30;
    UILabel *label6 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 12)];
    [viewShop addSubview:label6];
    label6.textColor = [ResourceManager color_1];
    label6.font = [UIFont systemFontOfSize:12];
    label6.text = @"备注消息";
    
    UILabel *label6Value = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -200 - iLeftX, iTopY, 200, 12)];
    [viewShop addSubview:label6Value];
    label6Value.textColor = [ResourceManager color_1];
    label6Value.font = [UIFont systemFontOfSize:12];
    label6Value.textAlignment = NSTextAlignmentRight;
    label6Value.text =  dicValue[@"refundDesc"]?[NSString stringWithFormat:@"%@", dicValue[@"refundDesc"]]:@"";
    
    iTopY += 30;
    viewShop.height = iTopY;
    
    
}

#pragma mark  ---  网络请求
-(void)getUIDataFromWeb{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"refundNo"] = _dicParams[@"refundNo"];
    // 如果退款订单号为nil， 传订单号
    if (!_dicParams[@"refundNo"] )
     {
        params[@"orderNo"] = _dicParams[@"orderNo"];
     }
    params[@"subOrderNo"] = _dicParams[@"subOrderNo"];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kURLrefundDetailInfo];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    
    operation.tag  = 1000;
    [operation start];
}


-(void) cancelCommit
{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"refundNo"] = _dicParams[@"refundNo"];
    

    NSString *strUrl = [NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString], kURcancelApply];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                      //[MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                  }];
    
    operation.tag = 1001;
    [operation start];
    
}



-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    if (1000 == operation.tag)
     {
        dicUI = operation.jsonResult.attr;
        if (dicUI)
         {
            [self layoutUI:dicUI];
         }
     }
    else if (1001 == operation.tag)
     {
        [MBProgressHUD showErrorWithStatus:@"申请提交成功" toView:self.view];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];// 延迟执行
        return;
     }
    
}

-(void) delayMethod
{
    //[self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(4),@"index":@(0)}];
}


-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}


#pragma mark --- action
-(void) actionRequest
{
    // 0-待处理 （请等待商家处理）
    if (0 == iServerStatus)
     {
        NSLog(@"取消申请");
        [self actionCanelRequset];
        return;
     }
    
    NSLog(@"重新申请");
    
    RefundReCommitVC  *VC = [[RefundReCommitVC alloc] init];
    VC.dicParams = [[NSDictionary alloc] init];
    VC.dicParams =  dicUI;
    [self.navigationController pushViewController:VC animated:YES];
}

-(void) actionRrecond
{
    NSLog(@"申请进度");
    RefundScheduleVC *VC = [[RefundScheduleVC alloc] init];
    VC.dicParams = [[NSDictionary alloc] init];
    VC.dicParams = _dicParams;
    [self.navigationController pushViewController:VC animated:YES];
}


-(void) actionConnect
{
    NSLog(@"联系商家");
    CustomerServiceViewController *ctl = [[CustomerServiceViewController alloc]init];
    [self.navigationController pushViewController:ctl animated:YES];
}

-(void) actionTXWl
{
    NSLog(@"填写物流");
    RefundTXWLVC *VC = [[RefundTXWLVC alloc] init];
    VC.dicParams = [[NSDictionary alloc] init];
    VC.dicParams = _dicParams;
    [self.navigationController pushViewController:VC animated:YES];
}

-(void) actionCanelRequset
{
    NSLog(@"取消申请");
    
    CDWAlertView *alertView = [[CDWAlertView alloc] init];
    
    alertView.shouldDismissOnTapOutside = NO;
    alertView.textAlignment = RTTextAlignmentCenter;
    
    // 降低高度
    [alertView subAlertCurHeight:10];
    //[alertView addSubTitle:[NSString stringWithFormat:@"<font size = 18 color=#000000>确定要放弃付款吗？</font>"]];
    
    // 加入message
    NSString *strXH= [NSString stringWithFormat:@"您将撤销本次申请，如果问题未解决，您还可以再次发起，确定要继续"];
    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 14 color=#333333> %@ </font>",strXH]];
    
    [alertView subAlertCurHeight:10];
    
    [alertView addCanelButton:@"取消" actionBlock:^{
        
    }];
    
    [alertView addButton:@"确定" color:[ResourceManager mainColor] actionBlock:^{
        
         [self cancelCommit];
        
    }];
    
    [alertView showAlertView:self.parentViewController duration:0.0];
    
   
}

@end
