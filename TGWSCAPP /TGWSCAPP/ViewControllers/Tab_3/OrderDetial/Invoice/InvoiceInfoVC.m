//
//  InvoiceInfoVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/2/13.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "InvoiceInfoVC.h"

@interface InvoiceInfoVC ()<UITextFieldDelegate>
{
    UIScrollView *_scView;
    CGFloat _currentHeight;
    UIView *_centerView;
    UIView *_footerView;
    UIView *_invoicewtView;
    
    UIButton *_grInvoiceBtn;
    UIButton *_dwInvoiceBtn;
    UITextField *_invoiceNameField;
    UITextField *_phoneField;
    UITextField *_dwmcField;
    UITextField *_sbhField;
    UITextField *_emailField;
    
    UIView *_aleartView;
}
@end

@implementation InvoiceInfoVC

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

-(void)saveInvoiceUrl{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_grInvoiceBtn.selected) {
        params[@"invoiceType"] = @"1";
        params[@"company"] = _invoiceNameField.text;
    }else{
        params[@"invoiceType"] = @"2";
        params[@"company"] = _dwmcField.text;
        params[@"unionCode"] = _sbhField.text;
    }
    params[@"detail"] = @"明细";
    params[@"telephone"] = _phoneField.text;
    params[@"email"] = _emailField.text;

    if (self.orderNo.length > 0) {
        params[@"orderNo"] = self.orderNo;
    }
    if (self.invoiceId.length > 0) {
        params[@"invoiceId"] = self.invoiceId;
    }
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/orderInvoice/save",[PDAPI getBaseUrlString]]
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
        if (operation.jsonResult.attr.count > 0) {
            NSDictionary *dic = operation.jsonResult.attr;
            if ([[dic objectForKey:@"invoiceType"] intValue] == 1) {
                [self invoiceTouch:_grInvoiceBtn];
                if ([dic objectForKey:@"company"] && [NSString stringWithFormat:@"%@",[dic objectForKey:@"company"]].length > 0) {
                    _invoiceNameField.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"company"]];
                }
            }else{
                [self invoiceTouch:_dwInvoiceBtn];
                if ([dic objectForKey:@"company"] && [NSString stringWithFormat:@"%@",[dic objectForKey:@"company"]].length > 0) {
                    _dwmcField.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"company"]];
                }
                if ([dic objectForKey:@"unionCode"] && [NSString stringWithFormat:@"%@",[dic objectForKey:@"unionCode"]].length > 0) {
                    _sbhField.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"unionCode"]];
                }
            }
            if ([dic objectForKey:@"telephone"] && [NSString stringWithFormat:@"%@",[dic objectForKey:@"telephone"]].length > 0) {
                _phoneField.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"telephone"]];
            }
            if ([dic objectForKey:@"email"] && [NSString stringWithFormat:@"%@",[dic objectForKey:@"email"]].length > 0) {
                _emailField.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"email"]];
            }
            
        }
    }else if (operation.tag == 1001) {
        NSString *invoiceId = [NSString stringWithFormat:@"%@",[operation.jsonResult.attr objectForKey:@"invoiceId"]];
        if (_grInvoiceBtn.selected) {
            if (self.invoiceBlock) {
                if (invoiceId.length == 0) {
                     self.invoiceBlock(@{@"invoice":@"个人"});
                }else{
                    self.invoiceBlock(@{@"invoice":@"个人",@"invoiceId":invoiceId});
                }
            }
        }else{
            if (self.invoiceBlock) {
                if (invoiceId.length == 0) {
                    self.invoiceBlock(@{@"invoice":@"企业"});
                }else{
                    self.invoiceBlock(@{@"invoice":@"企业",@"invoiceId":invoiceId});
                }
            }
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"发票信息"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"发票信息"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"发票信息"];
    
    [self layoutUI];
}

-(void)layoutUI{
    
    _scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight - 60)];
    [self.view addSubview:_scView];
    _scView.backgroundColor = [UIColor whiteColor];
    _scView.bounces = NO;
    _scView.pagingEnabled = NO;
    _scView.showsVerticalScrollIndicator = NO;
    
    [self headerViewUI];
    [self centerViewUI:1];
    [self footerViewUI];
    _scView.contentSize = CGSizeMake(0, _currentHeight);

    UIButton *saveInvoiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, SCREEN_HEIGHT - 60, SCREEN_WIDTH - 40, 50)];
    [self.view addSubview:saveInvoiceBtn];
    saveInvoiceBtn.backgroundColor = [ResourceManager mainColor];
    saveInvoiceBtn.layer.cornerRadius = 5;
    saveInvoiceBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [saveInvoiceBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveInvoiceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveInvoiceBtn addTarget:self action:@selector(saveInvoice) forControlEvents:UIControlEventTouchUpInside];
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
}

-(void)TouchViewKeyBoard{
    [self.view endEditing:YES];
}

-(void)headerViewUI{
    UIColor *color_1 = [ResourceManager color_1];
    UIColor *color_2 = [ResourceManager color_6];
    UIFont *font_1 = [UIFont systemFontOfSize:14];
    UIFont *font_2 = [UIFont systemFontOfSize:12];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
    headerView.backgroundColor = [UIColor whiteColor];
    [_scView addSubview:headerView];
    
    UILabel *fplxLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, 50)];
    [headerView addSubview:fplxLabel];
    fplxLabel.font = font_1;
    fplxLabel.textColor = color_2;
    fplxLabel.text = @"发票类型";
    
    UILabel *fplxRightLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(fplxLabel.frame), 0, 200, 50)];
    [headerView addSubview:fplxRightLabel];
    fplxRightLabel.font = font_1;
    fplxRightLabel.textColor = color_1;
    fplxRightLabel.text = @"电子发票";
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(fplxLabel.frame), SCREEN_WIDTH - 30, 0.5)];
    [headerView addSubview:lineView];
    lineView.backgroundColor = [ResourceManager color_5];
    
    UILabel *fpsmLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(lineView.frame), SCREEN_WIDTH - 30, 60)];
    [headerView addSubview:fpsmLabel];
    fpsmLabel.numberOfLines = 0;
    fpsmLabel.font = font_2;
    fpsmLabel.textColor = color_2;
    fpsmLabel.text = @"电子发票是税务局认可的有效凭证，其法律效应，基本用途及使用规定同纸质发票。";
    
    UIView *lineViewX = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(fpsmLabel.frame), SCREEN_WIDTH,10)];
    [headerView addSubview:lineViewX];
    lineViewX.backgroundColor = [ResourceManager viewBackgroundColor];
    
    _currentHeight = CGRectGetMaxY(lineViewX.frame);
}

-(void)centerViewUI:(NSInteger)invoiceType{
    [_centerView removeAllSubviews];
    
    UIColor *color_1 = [ResourceManager color_1];
    UIColor *color_2 = [ResourceManager color_6];
    UIFont *font_1 = [UIFont systemFontOfSize:14];
//    UIFont *font_2 = [UIFont systemFontOfSize:12];
    CGFloat _invoiceTypeHeight = 0;
    if (!_centerView) {
        _centerView = [[UIView alloc]initWithFrame:CGRectMake(0, _currentHeight, SCREEN_WIDTH, 50 * 4)];
        _centerView.backgroundColor = [UIColor whiteColor];
        [_scView addSubview:_centerView];
    }
   
    UILabel *fpttLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 80, 50)];
    [_centerView addSubview:fpttLabel];
    fpttLabel.font = font_1;
    fpttLabel.textColor = color_2;
    fpttLabel.text = @"发票抬头";
    
    _grInvoiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(fpttLabel.frame), 22/2, 60, 28)];
    [_centerView addSubview:_grInvoiceBtn];
    _grInvoiceBtn.tag = 1;
    _grInvoiceBtn.layer.cornerRadius = 2;
    _grInvoiceBtn.layer.borderWidth = 0.5;
    _grInvoiceBtn.layer.borderColor = [ResourceManager mainColor].CGColor;
    _grInvoiceBtn.titleLabel.font = font_1;
    [_grInvoiceBtn setTitle:@"个人" forState:UIControlStateNormal];
    [_grInvoiceBtn setTitleColor:color_1 forState:UIControlStateNormal];
    [_grInvoiceBtn setTitleColor:[ResourceManager mainColor] forState:UIControlStateSelected];
    [_grInvoiceBtn addTarget:self action:@selector(invoiceTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    _dwInvoiceBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_grInvoiceBtn.frame) + 10, 22/2, 60, 28)];
    [_centerView addSubview:_dwInvoiceBtn];
    _dwInvoiceBtn.tag = 2;
    _dwInvoiceBtn.layer.cornerRadius = 2;
    _dwInvoiceBtn.layer.borderWidth = 0.5;
    _dwInvoiceBtn.layer.borderColor = [ResourceManager mainColor].CGColor;
    _dwInvoiceBtn.titleLabel.font = font_1;
    [_dwInvoiceBtn setTitle:@"单位" forState:UIControlStateNormal];
    [_dwInvoiceBtn setTitleColor:color_1 forState:UIControlStateNormal];
    [_dwInvoiceBtn setTitleColor:[ResourceManager mainColor] forState:UIControlStateSelected];
    [_dwInvoiceBtn addTarget:self action:@selector(invoiceTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    if (invoiceType == 1) {
        _grInvoiceBtn.selected = YES;
        _dwInvoiceBtn.selected = NO;
        _grInvoiceBtn.layer.borderColor = [ResourceManager mainColor].CGColor;
        _dwInvoiceBtn.layer.borderColor = [ResourceManager color_5].CGColor;
        for (int i = 0; i < 3; i++) {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 50 * (i + 1) - 0.5, SCREEN_WIDTH - 20, 0.5)];
            [_centerView addSubview:lineView];
            lineView.backgroundColor = [ResourceManager color_5];
        }
        _invoiceNameField = [[UITextField alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(fpttLabel.frame), 250, 50)];
        [_centerView addSubview:_invoiceNameField];
        _invoiceNameField.placeholder = @"请输入发票抬头名称";
        _invoiceNameField.font = font_1;
        _invoiceNameField.textColor = color_1;
        _invoiceNameField.text = @"个人";
        
        _invoiceTypeHeight = CGRectGetMaxY(_invoiceNameField.frame);
    }else{
        _dwInvoiceBtn.selected = YES;
        _grInvoiceBtn.selected = NO;
        _dwInvoiceBtn.layer.borderColor = [ResourceManager mainColor].CGColor;
        _grInvoiceBtn.layer.borderColor = [ResourceManager color_5].CGColor;
        for (int i = 0; i < 4; i++) {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 50 * (i + 1) - 0.5, SCREEN_WIDTH - 20, 0.5)];
            [_centerView addSubview:lineView];
            lineView.backgroundColor = [ResourceManager color_5];
        }
        _dwmcField = [[UITextField alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(fpttLabel.frame), 250, 50)];
        [_centerView addSubview:_dwmcField];
        _dwmcField.placeholder = @"请输入单位名称";
        _dwmcField.font = [UIFont systemFontOfSize:14];
        _dwmcField.textColor = color_1;
        
        _sbhField = [[UITextField alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(_dwmcField.frame), 250, 50)];
        [_centerView addSubview:_sbhField];
        _sbhField.placeholder = @"*纳税人识别号或统一社会信用代码";
        _sbhField.font = [UIFont systemFontOfSize:14];
        _sbhField.textColor = color_1;
        
        UIButton *sbhsmBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40, CGRectGetMidY(_sbhField.frame) - 15, 30, 30)];
        [_centerView addSubview:sbhsmBtn];
        [sbhsmBtn setImage:[UIImage imageNamed:@"inv_sm"] forState:UIControlStateNormal];
        [sbhsmBtn addTarget:self action:@selector(sbhsmTouch) forControlEvents:UIControlEventTouchUpInside];
        
         _invoiceTypeHeight = CGRectGetMaxY(_sbhField.frame);
    }
    
    UILabel *fpnrLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, _invoiceTypeHeight, 70, 50)];
    [_centerView addSubview:fpnrLabel];
    fpnrLabel.font = font_1;
    fpnrLabel.textColor = color_2;
    fpnrLabel.text = @"发票内容";
    
    UILabel *fpnrRightLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(fpnrLabel.frame), _invoiceTypeHeight, 200, 50)];
    [_centerView addSubview:fpnrRightLabel];
    fpnrRightLabel.font = font_1;
    fpnrRightLabel.textColor = color_1;
    fpnrRightLabel.text = @"明细";
    
    UILabel *fpjeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(fpnrLabel.frame), 70, 50)];
    [_centerView addSubview:fpjeLabel];
    fpjeLabel.font = font_1;
    fpjeLabel.textColor = color_2;
    fpjeLabel.text = @"发票金额";
    
    UILabel *fpjeRightLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(fpnrLabel.frame), CGRectGetMaxY(fpnrLabel.frame), 200, 50)];
    [_centerView addSubview:fpjeRightLabel];
    fpjeRightLabel.font = font_1;
    fpjeRightLabel.textColor = color_1;
    fpjeRightLabel.text = self.price;
    
    UIView *lineViewX = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(fpjeRightLabel.frame), SCREEN_WIDTH,10)];
    [_centerView addSubview:lineViewX];
    lineViewX.backgroundColor = [ResourceManager viewBackgroundColor];
    
    _centerView.height = CGRectGetMaxY(lineViewX.frame);
    _currentHeight = CGRectGetMaxY(_centerView.frame);
}

-(void)invoiceTouch:(UIButton *)sender{
    [self.view endEditing:YES];
    if (sender.selected) {
        return;
    }
    [self centerViewUI:sender.tag];
    _footerView.frame = CGRectMake(0, CGRectGetMaxY(_centerView.frame), SCREEN_WIDTH, CGRectGetMaxY(_invoicewtView.frame));
    _currentHeight = CGRectGetMaxY(_footerView.frame);
    _scView.contentSize = CGSizeMake(0, _currentHeight);
}

-(void)footerViewUI{
    UIColor *color_1 = [ResourceManager color_1];
    UIColor *color_2 = [ResourceManager color_6];
    UIFont *font_1 = [UIFont systemFontOfSize:14];
    UIFont *font_2 = [UIFont systemFontOfSize:12];
    
    _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_centerView.frame) + 10, SCREEN_WIDTH, 110)];
    _footerView.backgroundColor = [UIColor whiteColor];
    [_scView addSubview:_footerView];
    
    UILabel *sprsjLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 90, 50)];
    [_footerView addSubview:sprsjLabel];
    sprsjLabel.font = font_1;
    sprsjLabel.textColor = color_2;
    sprsjLabel.text = @"*收票人手机";
    
    _phoneField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(sprsjLabel.frame), 0, 200, 50)];
    [_footerView addSubview:_phoneField];
    _phoneField.placeholder = @"请输入收票人手机号码";
    _phoneField.font = [UIFont systemFontOfSize:14];
    _phoneField.textColor = color_1;
    _phoneField.delegate = self;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(sprsjLabel.frame), SCREEN_WIDTH - 20, 0.5)];
    [_footerView addSubview:lineView];
    lineView.backgroundColor = [ResourceManager color_5];
    
    UILabel *spryxLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(sprsjLabel.frame), 90, 50)];
    [_footerView addSubview:spryxLabel];
    spryxLabel.font = font_1;
    spryxLabel.textColor = color_2;
    spryxLabel.text = @"收票人邮箱";
    
    _emailField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(spryxLabel.frame), CGRectGetMaxY(sprsjLabel.frame), 250, 50)];
    [_footerView addSubview:_emailField];
    _emailField.placeholder = @"用于接受电子发票";
    _emailField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailField.font = [UIFont systemFontOfSize:14];
    _emailField.textColor = [ResourceManager color_1];
    _emailField.delegate = self;
    
    _invoicewtView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_emailField.frame), SCREEN_WIDTH, 200)];
    [_footerView addSubview:_invoicewtView];
    _invoicewtView.backgroundColor = [ResourceManager viewBackgroundColor];
    
    UILabel *tsLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 30, 100)];
    [_invoicewtView addSubview:tsLabel];
    tsLabel.numberOfLines = 0;
    tsLabel.font = font_2;
    tsLabel.textColor = color_2;
    tsLabel.text = @"1.依据税局最新开票法规，发票开局内容均为明细\n2.因发货仓库所在地贷权归属政策原因，订单可能为您拆分开具多张发票\n3.开票金额为用户实际支付的金额（不含礼品卡与不支持该发票类型的商品实付金额）\n4.电子发票可在确认收货后，在“订单详情页”下载";
    
    UIButton *cjwtBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 110)/2, CGRectGetMaxY(tsLabel.frame) + 10, 110, 30)];
    [_invoicewtView addSubview:cjwtBtn];
    cjwtBtn.layer.borderWidth = 0.5;
    cjwtBtn.layer.borderColor = [ResourceManager color_5].CGColor;
    cjwtBtn.titleLabel.font = font_1;
    [cjwtBtn setTitle:@"发票常见问题" forState:UIControlStateNormal];
    [cjwtBtn setTitleColor:color_2 forState:UIControlStateNormal];
    [cjwtBtn addTarget:self action:@selector(invoicecjwt) forControlEvents:UIControlEventTouchUpInside];
    
    _invoicewtView.height = CGRectGetMaxY(cjwtBtn.frame) + 10;
    _footerView.height = CGRectGetMaxY(_invoicewtView.frame) + 10;
    _currentHeight = CGRectGetMaxY(_footerView.frame);
}

//发票常见问题
-(void)invoicecjwt{
    [self.view endEditing:YES];
    NSString *url = [NSString stringWithFormat:@"%@webMall/protocol/invoice",[PDAPI WXSysRouteAPI]];
    [CCWebViewController showWithContro:self withUrlStr:url withTitle:@"发票服务"];
}

//保存发票信息
-(void)saveInvoice{
    [self.view endEditing:YES];
    
    if (_grInvoiceBtn.selected) {
        if (_invoiceNameField.text.length == 0) {
            [MBProgressHUD showErrorWithStatus:@"请填写发票抬头" toView:self.view];
            return;
        }
    }else{
        if (_dwmcField.text.length == 0) {
            [MBProgressHUD showErrorWithStatus:@"请填写发票抬头" toView:self.view];
            return;
        }
        if (_sbhField.text.length == 0) {
            [MBProgressHUD showErrorWithStatus:@"请填写纳税人识别号或社会统一信用代码" toView:self.view];
            return;
        }
    }
    if (_phoneField.text.length == 0 || _phoneField.text.length != 11) {
        [MBProgressHUD showErrorWithStatus:@"请正确填写收票人手机号码" toView:self.view];
        return;
    }
    [self saveInvoiceUrl];
}

//识别号说明点击事件
-(void)sbhsmTouch{
    [self.view endEditing:YES];
    [_aleartView  removeFromSuperview];

    _aleartView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_aleartView];
    _aleartView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];

    UIView *view = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 300)/2, (SCREEN_HEIGHT - 320)/2, 300, 320)];
    [_aleartView addSubview:view];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 8;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 20, view.bounds.size.width - 60, 200)];
    [view addSubview:titleLabel];
    titleLabel.textColor = [ResourceManager color_1];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.text = @"根据国税总局规定：购买方为企业的，索取增值税普通发票时，应向销售方提供纳税人识别号或统一社会信用代码；销售方为其开具增值税普通发票时，应在“购买方纳税人识别号”栏填写购买方纳税人识别号或社会统一信用代码。不符合规定的发票，不得作为税收凭证。纳税人识别号有两种方式获取：①联系公司财务咨询开票信息；②登录全国组织代码管理中心查询:\nhttp://www.nacao.org.cn/";
    [titleLabel sizeToFit];

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 20, view.frame.size.width, 0.5)];
    [view addSubview:lineView];
    lineView.backgroundColor = [ResourceManager color_5];
    
    UIButton *agreeBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(lineView.frame), view.bounds.size.width - 60, 50)];
    [view addSubview:agreeBtn];
    [agreeBtn setTitle:@"确定" forState:UIControlStateNormal];
    agreeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [agreeBtn setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(hidenAlert) forControlEvents:UIControlEventTouchUpInside];

    view.height = CGRectGetMaxY(agreeBtn.frame);
    
}

//确定
-(void)hidenAlert{
     [_aleartView removeFromSuperview];
}

#pragma mark---UITextFieldDelegate
//开始编辑时,键盘遮挡文本框，视图上移
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移30个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-210,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}

//恢复原始视图位置
-(void)resumeView{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    
    CGRect rect=CGRectMake(0.0f,0,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}

//键盘落下事件
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self resumeView];
}

-(void)viewDidDisappear:(BOOL)animated{
    [self resumeView];
    [super viewDidDisappear:animated];
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
