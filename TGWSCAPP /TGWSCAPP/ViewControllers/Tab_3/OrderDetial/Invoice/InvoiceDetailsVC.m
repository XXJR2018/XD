//
//  InvoiceDetailsVC.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/21.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "InvoiceDetailsVC.h"

#import "InvoiceInfoVC.h"
#import "InvoiceJpegVC.h"
@interface InvoiceDetailsVC ()
{
    NSDictionary *_invoiceDic;
    CGFloat _currentHeight;
    NSString *_invoiceImgUrl;
}
@end

@implementation InvoiceDetailsVC

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.invoiceId.length > 0) {
        params[@"invoiceId"] = self.invoiceId;
    }
    if (self.orderNo.length > 0) {
       params[@"orderNo"] = self.orderNo;
    }
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/orderInvoice/dtlInfo",[PDAPI getBaseUrlString]]
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
    if (operation.jsonResult.attr.count > 0) {
        _invoiceDic = operation.jsonResult.attr;
        [self layoutUI];
    }
    
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"发票详情"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"发票详情"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"发票详情"];
//    [self layoutUI];
}

-(void)layoutUI{
    [self.view removeAllSubviews];
    [self layoutNaviBarViewWithTitle:@"发票详情"];
    _currentHeight = 0;
    UIColor *color_1 = [ResourceManager color_1];
    UIColor *color_2 = [ResourceManager mainColor];
    UIFont *font_1 = [UIFont systemFontOfSize:14];
    UIFont *font_2 = [UIFont systemFontOfSize:12];
    
    UIView *headbgView = [[UIView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, 100)];
    [self.view addSubview:headbgView];
    headbgView.backgroundColor = UIColorFromRGB(0xAA8853);
    
    UIImageView *headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, (headbgView.frame.size.height - 50)/2, 50, 50)];
    [headbgView addSubview:headImgView];
    headImgView.backgroundColor= [ResourceManager viewBackgroundColor];
    headImgView.layer.masksToBounds = YES;
    headImgView.layer.cornerRadius = 50/2;
    [headImgView sd_setImageWithURL:[NSURL URLWithString:[[CommonInfo userInfo] objectForKey:@"headImgUrl"]]];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImgView.frame) + 10, CGRectGetMidY(headImgView.frame) - 10, 200, 20)];
    [headbgView addSubview:nameLabel];
    nameLabel.font = font_1;
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.text = [NSString stringWithFormat:@"%@",[[CommonInfo userInfo] objectForKey:@"nickName"]];
    
    UIView *kpztView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(headbgView.frame), SCREEN_WIDTH, 90)];
    [self.view addSubview:kpztView];
    kpztView.backgroundColor = [UIColor whiteColor];
    
    UILabel *kpztLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (kpztView.frame.size.height - 20)/2, 200, 20)];
    [kpztView addSubview:kpztLabel];
    kpztLabel.font = font_1;
    kpztLabel.textColor = color_1;
    if ([[_invoiceDic objectForKey:@"invoiceStatus"] intValue] == 1) {
        kpztLabel.text = @"开票状态：开票中";
        
        UIButton *changeInvoiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 110, CGRectGetMidY(kpztLabel.frame) - 15, 100, 30)];
        [kpztView addSubview:changeInvoiceBtn];
        changeInvoiceBtn.titleLabel.font = font_2;
        [changeInvoiceBtn setTitle:@"修改信息" forState:UIControlStateNormal];
        [changeInvoiceBtn setTitleColor:color_2 forState:UIControlStateNormal];
        [changeInvoiceBtn setImage:[UIImage imageNamed:@"Inv_bj"] forState:UIControlStateNormal];
        [changeInvoiceBtn addTarget:self action:@selector(changeInvoice) forControlEvents:UIControlEventTouchUpInside];
        
    }else if ([[_invoiceDic objectForKey:@"invoiceStatus"] intValue] == 2) {
        kpztLabel.text = @"开票状态：开票成功";
    }
    
    _currentHeight = CGRectGetMaxY(kpztView.frame) + 10;
    
    UIView *invoiceInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, _currentHeight, SCREEN_WIDTH, 200)];
    [self.view addSubview:invoiceInfoView];
    invoiceInfoView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *orderImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 13.5, 17.5)];
    [invoiceInfoView addSubview:orderImgView];
    orderImgView.image = [UIImage imageNamed:@"Inv_dd"];
    
    _currentHeight = CGRectGetMidY(orderImgView.frame) - 10;
    if ([_invoiceDic objectForKey:@"orderNo"]) {
        UILabel *orderNoLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(orderImgView.frame) + 10, _currentHeight, 200, 20)];
        [invoiceInfoView addSubview:orderNoLabel];
        orderNoLabel.font = font_2;
        orderNoLabel.textColor = color_1;
        orderNoLabel.text = [NSString stringWithFormat:@"订单号：%@",[_invoiceDic objectForKey:@"orderNo"]];
        
        _currentHeight = CGRectGetMaxY(orderNoLabel.frame);
    }
    if ([_invoiceDic objectForKey:@"amount"]) {
        UILabel *amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(orderImgView.frame) + 10,_currentHeight, 200, 20)];
        [invoiceInfoView addSubview:amountLabel];
        amountLabel.font = font_2;
        amountLabel.textColor = color_1;
        NSString *amountStr = [NSString stringWithFormat:@"实付金额：%@",[_invoiceDic objectForKey:@"amount"]];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]
                                              initWithString:amountStr];
        //2.匹配字符串
        [attrStr addAttribute:NSFontAttributeName value:font_2 range:NSMakeRange(0, 5)];
        [attrStr addAttribute:NSFontAttributeName value:font_1 range:NSMakeRange(5, amountStr.length - 5)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:color_1 range:NSMakeRange(0, 5)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:color_2 range:NSMakeRange(5, amountStr.length - 5)];
        amountLabel.attributedText = attrStr;
        
        _currentHeight = CGRectGetMaxY(amountLabel.frame);
    }
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _currentHeight + 10, SCREEN_WIDTH, 0.5)];
    [invoiceInfoView addSubview:lineView];
    lineView.backgroundColor = [ResourceManager color_5];
    
    UIImageView *invoiceImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame) + 10, 14, 13)];
    [invoiceInfoView addSubview:invoiceImgView];
    invoiceImgView.image = [UIImage imageNamed:@"Inv_fplx"];
    _currentHeight = CGRectGetMidY(invoiceImgView.frame) - 10;
    
    if ([_invoiceDic objectForKey:@"invoiceType"]) {
        UILabel *invoiceTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(invoiceImgView.frame) + 10, _currentHeight, 200, 20)];
        [invoiceInfoView addSubview:invoiceTypeLabel];
        invoiceTypeLabel.font = font_2;
        invoiceTypeLabel.textColor = color_1;
        if ([[_invoiceDic objectForKey:@"invoiceType"] intValue] == 1) {
            invoiceTypeLabel.text = @"发票类型：电子个人发票";
        }else if ([[_invoiceDic objectForKey:@"invoiceType"] intValue] == 2) {
            invoiceTypeLabel.text = @"发票类型：电子单位发票";
        }
        
        _currentHeight = CGRectGetMaxY(invoiceTypeLabel.frame);
    }
    
    if ([_invoiceDic objectForKey:@"company"]) {
        UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(invoiceImgView.frame) + 10, _currentHeight, 200, 20)];
        [invoiceInfoView addSubview:companyLabel];
        companyLabel.font = font_2;
        companyLabel.textColor = color_1;
        companyLabel.text = [NSString stringWithFormat:@"发票抬头：%@",[_invoiceDic objectForKey:@"company"]];
        
        _currentHeight = CGRectGetMaxY(companyLabel.frame);
    }
    
    if ([_invoiceDic objectForKey:@"unionCode"]) {
        UILabel *unionCodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(invoiceImgView.frame) + 10, _currentHeight, 200, 20)];
        [invoiceInfoView addSubview:unionCodeLabel];
        unionCodeLabel.font = font_2;
        unionCodeLabel.textColor = color_1;
        NSString *amountStr = [NSString stringWithFormat:@"税一一号：%@",[_invoiceDic objectForKey:@"unionCode"]];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]
                                              initWithString:amountStr];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(1, 2)];
        unionCodeLabel.attributedText = attrStr;
        _currentHeight = CGRectGetMaxY(unionCodeLabel.frame);
    }
    
    if ([_invoiceDic objectForKey:@"detail"]) {
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(invoiceImgView.frame) + 10, _currentHeight, 200, 20)];
        [invoiceInfoView addSubview:detailLabel];
        detailLabel.font = font_2;
        detailLabel.textColor = color_1;
        detailLabel.text = [NSString stringWithFormat:@"发票内容：%@",[_invoiceDic objectForKey:@"detail"]];
        
        _currentHeight = CGRectGetMaxY(detailLabel.frame);
    }
    
    if ([[_invoiceDic objectForKey:@"invoiceStatus"] intValue] == 2 && [_invoiceDic objectForKey:@"invoiceUrl"] && [NSString stringWithFormat:@"%@",[_invoiceDic objectForKey:@"invoiceUrl"]].length > 0) {
        _invoiceImgUrl = [NSString stringWithFormat:@"%@",[_invoiceDic objectForKey:@"invoiceUrl"]];
        UIButton *checkImgBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 80, invoiceInfoView.frame.size.height/2 - 15, 80, 30)];
        [invoiceInfoView addSubview:checkImgBtn];
        checkImgBtn.titleLabel.font = font_1;
        [checkImgBtn setTitle:@"查看>" forState:UIControlStateNormal];
        [checkImgBtn setTitleColor:color_2 forState:UIControlStateNormal];
        [checkImgBtn addTarget:self action:@selector(checkImg) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    invoiceInfoView.height = _currentHeight + 15;
    _currentHeight = CGRectGetMaxY(invoiceInfoView.frame) + 10;
   
    if ([_invoiceDic objectForKey:@"updateTime"]) {
        UIView *invoiceTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, _currentHeight, SCREEN_WIDTH, 50)];
        [self.view addSubview:invoiceTimeView];
        invoiceTimeView.backgroundColor = [UIColor whiteColor];
        
        UIImageView *timeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, (50 - 15)/2, 15, 15)];
        [invoiceTimeView addSubview:timeImgView];
        timeImgView.image = [UIImage imageNamed:@"Inv_fpsj"];
        
        
        UILabel *invoiceTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(orderImgView.frame) + 10, 0, 300, 50)];
        [invoiceTimeView addSubview:invoiceTimeLabel];
        invoiceTimeLabel.font = font_2;
        invoiceTimeLabel.textColor = color_1;
        invoiceTimeLabel.text = [NSString stringWithFormat:@"发票开具时间：%@",[_invoiceDic objectForKey:@"updateTime"]];
        
        _currentHeight = CGRectGetMaxY(invoiceTimeView.frame);
    }
}

//修改发票信息
-(void)changeInvoice{
    InvoiceInfoVC *ctl = [[InvoiceInfoVC alloc]init];
    ctl.invoiceId = [NSString stringWithFormat:@"%@",[_invoiceDic objectForKey:@"invoiceId"]];
    ctl.orderNo = [NSString stringWithFormat:@"%@",[_invoiceDic objectForKey:@"orderNo"]];
    ctl.price = [NSString stringWithFormat:@"¥%.2f", [[_invoiceDic objectForKey:@"amount"] floatValue]];
    ctl.invoiceBlock = ^(id invoiceData){
        [self loadData];
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

//查看发票图片
-(void)checkImg{
    InvoiceJpegVC *ctl = [[InvoiceJpegVC alloc]init];
    ctl.invoiceImgUrl = _invoiceImgUrl;
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
