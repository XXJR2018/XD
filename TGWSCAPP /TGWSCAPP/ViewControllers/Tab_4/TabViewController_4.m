//
//  TabViewController_4.m
//  XXJR
//
//  Created by xxjr03 on 2018/12/4.
//  Copyright © 2018 Cary. All rights reserved.
//

#import "TabViewController_4.h"

#import "UserInfoViewController.h"
#import "OrderViewController.h"
#import "MyBalanceViewController.h"
#import "CouponViewController.h"
#import "MyCollectViewController.h"
#import "AddressViewController.h"
#import "CustomerServiceViewController.h"
#import "LogisticsDescViewController.h"
#import "AppraiseListViewController.h"
#import "RefundListVC.h"
#import "XcodeWebVC.h"

#import "JXButton.h"

@interface TabViewController_4 ()
{
    UIImageView *_headImgView;
    UILabel *_nickNameLabel;
    CGFloat _currentHeight;
    
    UIButton *_balanceBtn;            // 余额
    UIButton *_totalScoreBtn;        // 积分
    
    UIView *_orderView;
    UILabel *_dfkNumLabel;
    UILabel *_dfhNumLabel;
    UILabel *_yfhNumLabel;
    UILabel *_dpjNumLabel;
    UILabel *_tkNumLabel;
    
    JXButton *_couponBtn;   //优惠券按钮
    
    UIView *_logisticsView;   //物流信息布局
    NSArray *_logisticsListArr;
}

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)UIView *headView;

@property(nonatomic, strong)UIView *footerView;

@end

@implementation TabViewController_4

-(void)custSummaryUrl{
    [MBProgressHUD showHUDAddedTo:self.view];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/cust/info/custSummary",[PDAPI getBaseUrlString]]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
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
    if (operation.jsonResult.attr.count > 0) {
         _logisticsListArr = [operation.jsonResult.attr objectForKey:@"logisticsList"];
        [self changeOrderInfo:operation.jsonResult.attr];
    }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    [_tableView.mj_header endRefreshing];
}

#pragma mark-- 刷新用户数据更新用户信息显示
-(void)changeUserInfo{
    if (![CommonInfo isLoggedIn]) {
        _headImgView.image = [UIImage imageNamed:@"Tab_4-2"];
        _nickNameLabel.text = @"请登录";
        return;
    }
    if ([CommonInfo userInfo].count == 0) {
        return;
    }
    NSDictionary *dic = [CommonInfo userInfo];
    //头像
    if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"headImgUrl"]].length > 0) {
        [_headImgView sd_setImageWithURL:[dic objectForKey:@"headImgUrl"] placeholderImage:[UIImage imageNamed:@"Tab_4-2"]];
    }else{
        _headImgView.image = [UIImage imageNamed:@"Tab_4-2"];
    }
    //昵称/电话
    if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"nickName"]].length > 0) {
        _nickNameLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"nickName"]];
    }else{
        if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"hideTelephone"]].length > 0) {
            _nickNameLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"hideTelephone"]];
        }else{
            _nickNameLabel.text = @"请登录";
        }
    }
    
}

#pragma mark-- 刷新订单信息
-(void)changeOrderInfo:(NSDictionary *)dic{
    if (![CommonInfo isLoggedIn]) {
        _dfkNumLabel.hidden = YES;
        _dfkNumLabel.text = @"";
        _dfhNumLabel.hidden = YES;
        _dfhNumLabel.text = @"";
        _yfhNumLabel.hidden = YES;
        _yfhNumLabel.text = @"";
        _dfhNumLabel.hidden = YES;
        _dpjNumLabel.text = @"";
        _tkNumLabel.hidden = YES;
        _tkNumLabel.text = @"";
        [_balanceBtn setTitle:@"余额：￥0.00" forState:UIControlStateNormal];
        [_totalScoreBtn setTitle:@"积分：0.00" forState:UIControlStateNormal];
        [_couponBtn setImage:[UIImage imageNamed:@"XD-img-11"] forState:UIControlStateNormal];
        [_logisticsView removeAllSubviews];
        _logisticsView.frame = CGRectMake(0, CGRectGetMaxY(_orderView.frame), SCREEN_WIDTH, 0);
        self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(_logisticsView.frame));

        [_tableView reloadData];
        return;
    }
    
    //代付款
    if ([[dic objectForKey:@"noPayOrderCount"] intValue] > 0) {
        _dfkNumLabel.hidden = NO;
        _dfkNumLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"noPayOrderCount"]];
    }else{
        _dfkNumLabel.hidden = YES;
        _dfkNumLabel.text = @"";
    }
    //代发货
    if ([[dic objectForKey:@"noSendOrderCount"] intValue] > 0) {
        _dfhNumLabel.hidden = NO;
        _dfhNumLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"noSendOrderCount"]];
    }else{
        _dfhNumLabel.hidden = YES;
        _dfhNumLabel.text = @"";
    }
    //已发货
    if ([[dic objectForKey:@"sendOrderCount"] intValue] > 0) {
        _yfhNumLabel.hidden = NO;
        _yfhNumLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sendOrderCount"]];
    }else{
        _yfhNumLabel.hidden = YES;
        _yfhNumLabel.text = @"";
    }
    //待评价
    if ([[dic objectForKey:@"waitOrderCount"] intValue] > 0) {
        _dpjNumLabel.hidden = NO;
        _dpjNumLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"waitOrderCount"]];
    }else{
        _dpjNumLabel.hidden = YES;
        _dpjNumLabel.text = @"";
    }
    //退款/售后
    if ([[dic objectForKey:@"refundCount"] intValue] > 0) {
        _tkNumLabel.hidden = NO;
        _tkNumLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"refundCount"]];
    }else{
        _tkNumLabel.hidden = YES;
        _tkNumLabel.text = @"";
    }
    
    //余额
    if ([[dic objectForKey:@"usableAmount"] floatValue] > 0) {
        NSString *title = [NSString stringWithFormat:@"余额：￥%@",[ToolsUtlis getnumber:[dic objectForKey:@"usableAmount"]]];
        [_balanceBtn setTitle:title forState:UIControlStateNormal];
    }else{
        [_balanceBtn setTitle:@"余额：￥0.00" forState:UIControlStateNormal];
    }
    //积分
    if ([[dic objectForKey:@"totalScore"] intValue] > 0) {
        NSString *title = [NSString stringWithFormat:@"积分：%@",[dic objectForKey:@"totalScore"]];
        [_totalScoreBtn setTitle:title forState:UIControlStateNormal];
    }else{
        [_totalScoreBtn setTitle:@"积分：0.00" forState:UIControlStateNormal];
    }
    //优惠券按钮
 
    if ([[dic objectForKey:@"newCardCount"] intValue] > 0) {
        [_couponBtn setImage:[UIImage imageNamed:@"XD-img-15"] forState:UIControlStateNormal];
    }else{
        [_couponBtn setImage:[UIImage imageNamed:@"XD-img-11"] forState:UIControlStateNormal];
    }
   
    NSArray *sticsListArr = [dic objectForKey:@"logisticsList"];
    [_logisticsView removeAllSubviews];
    if (sticsListArr.count == 0) {
        _logisticsView.frame = CGRectMake(0, CGRectGetMaxY(_orderView.frame), SCREEN_WIDTH, 0);
        self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(_logisticsView.frame));
    }else{
         _logisticsView.frame = CGRectMake(0, CGRectGetMaxY(_orderView.frame), SCREEN_WIDTH, 60 * sticsListArr.count + 10);
        for (int i = 0; i < sticsListArr.count; i ++) {
            NSDictionary *dic = sticsListArr[i];
            UIView *statusView = [[UIView alloc]initWithFrame:CGRectMake(60 - 5/2, 60 * i + 20, 5, 5)];
            [_logisticsView addSubview:statusView];
            statusView.layer.cornerRadius = 5/2;
            statusView.backgroundColor = [ResourceManager color_5];
           
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(statusView.frame), (60 -45)/2 +(60 - (60 -45)/2) * i , 0.5, 60 - (60 -45)/2)];
            [_logisticsView addSubview:lineView];
            lineView.backgroundColor = [ResourceManager color_5];
            
            UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMidY(statusView.frame) - 40/2, CGRectGetMinX(statusView.frame), 40)];
            [_logisticsView addSubview:timeLabel];
            timeLabel.numberOfLines = 2;
            timeLabel.textColor = [ResourceManager color_6];
            timeLabel.textAlignment = NSTextAlignmentCenter;
            timeLabel.font = [UIFont systemFontOfSize:11];
            timeLabel.text = [NSString stringWithFormat:@"最新物流\n%@",[dic objectForKey:@"logistucsTime"]];
            
            UIImageView *productImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(statusView.frame) + 10,(60 -45)/2 + 60 * i, 45, 45)];
            [_logisticsView addSubview:productImgView];
            productImgView.userInteractionEnabled = YES;
            productImgView.backgroundColor = UIColorFromRGB(0xf6f6f6);
            [productImgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"goodsUrl"]]];
            
            UIImageView *logisticsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(productImgView.frame) + 10, CGRectGetMinY(productImgView.frame), 15, 15)];
            [_logisticsView addSubview:logisticsImgView];
            logisticsImgView.image = [UIImage imageNamed:@"Tab_4-10"];
            
            UILabel *logisticsStatusLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logisticsImgView.frame) + 5, CGRectGetMidY(logisticsImgView.frame) - 20/2, 150, 20)];
            [_logisticsView addSubview:logisticsStatusLabel];
            logisticsStatusLabel.textColor = [ResourceManager mainColor];
            logisticsStatusLabel.font = [UIFont systemFontOfSize:13];
            logisticsStatusLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"logisticsLabel"]];
            if ([logisticsStatusLabel.text isEqualToString:@"已签收"]) {
                logisticsImgView.image = [UIImage imageNamed:@"Tab_4-11"];
            }
            
            UILabel *logisticsDescLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(logisticsImgView.frame), CGRectGetMaxY(logisticsImgView.frame), SCREEN_WIDTH - CGRectGetMidX(logisticsImgView.frame) - 10, 20)];
            [_logisticsView addSubview:logisticsDescLabel];
            logisticsDescLabel.textColor = [ResourceManager color_6];
            logisticsDescLabel.font = [UIFont systemFontOfSize:12];
            logisticsDescLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"lastLogisticsInfo"]];
            
            UIButton *logisticsBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,  60 * i, SCREEN_WIDTH, 60)];
            [_logisticsView addSubview:logisticsBtn];
            logisticsBtn.tag = i;
            [logisticsBtn addTarget:self action:@selector(logisticsTouch:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
    self.headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(_logisticsView.frame));
    [_tableView reloadData];
}

-(void)logisticsTouch:(UIButton *)sender{
    NSDictionary *dic = _logisticsListArr[sender.tag];
    LogisticsDescViewController *ctl = [[LogisticsDescViewController alloc]init];
    ctl.logisticsId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"logisticsId"]];
    [self.navigationController pushViewController:ctl animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"个人中心"];
    if ([CommonInfo isLoggedIn]) {
        //改变商品数量
        [self custSummaryUrl];
    }else{
        //未登录恢复默认属性
        [self changeUserInfo];
        [self changeOrderInfo:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"个人中心"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
    
    [self changeUserInfo];
    // 更新用户头像等信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserInfo) name:@"NotificationChangeUserInfo" object:nil];
}

-(void)layoutUI{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TabbarHeight)];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [ResourceManager viewBackgroundColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //发送通知更新用户信息
        [[NSNotificationCenter defaultCenter] postNotificationName:DDGNotificationAccountNeedRefresh object:nil];
        [self custSummaryUrl];
        [self.tableView reloadData];
    }];

    _headView = [[UIView alloc]init];
    _footerView = [[UIView alloc]init];
    [self.tableView setTableHeaderView:_headView];
    [self.tableView setTableFooterView:_footerView];
    
    [self headViewUI];
    [self footerViewUI];
}

#pragma mark--headViewUI
-(void)headViewUI{
    
    UIImageView *backdropImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 245 * ScaleSize)];
    [self.headView addSubview:backdropImgView];
    backdropImgView.image = [UIImage imageNamed:@"XD-img-1"];
    backdropImgView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, NavHeight - 40, 100, 30)];
    [backdropImgView addSubview:titleLabel];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"个人中心";
    
    UIButton *goInfoBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 40, CGRectGetMinY(titleLabel.frame), 30, 30)];
    [backdropImgView addSubview:goInfoBtn];
    [goInfoBtn setImage:[UIImage imageNamed:@"Tab_4-3"] forState:UIControlStateNormal];
    [goInfoBtn addTarget:self action:@selector(userInfo) forControlEvents:UIControlEventTouchUpInside];
    
    _headImgView = [[UIImageView alloc]initWithFrame:CGRectMake((backdropImgView.bounds.size.width - 60)/2, (backdropImgView.bounds.size.height - 60)/2, 60, 60)];
    [backdropImgView addSubview:_headImgView];
    _headImgView.image = [UIImage imageNamed:@"Tab_4-2"];
    _headImgView.userInteractionEnabled = YES;
    // 没这句话倒不了角
    _headImgView.layer.masksToBounds = YES;
    _headImgView.layer.cornerRadius = 60/2;
    _headImgView.layer.borderWidth = 1;
    _headImgView.layer.borderColor = [ResourceManager viewBackgroundColor].CGColor;
    
    _nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(_headImgView.frame) - 50, CGRectGetMaxY(_headImgView.frame) + 10, 100, 20)];
    [backdropImgView addSubview:_nickNameLabel];
    _nickNameLabel.textColor = [ResourceManager color_1];
    _nickNameLabel.font = [UIFont systemFontOfSize:15];
    _nickNameLabel.textAlignment = NSTextAlignmentCenter;
    _nickNameLabel.text = @"请登录";
    
    UIButton *userInfoBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMidX(_headImgView.frame) - 40, CGRectGetMinY(_headImgView.frame), 80, 100)];
    [backdropImgView addSubview:userInfoBtn];
    [userInfoBtn addTarget:self action:@selector(userInfo) forControlEvents:UIControlEventTouchUpInside];

    _balanceBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/2 - 150)/2, CGRectGetMaxY(userInfoBtn.frame) + 10, 150, 30)];
    [backdropImgView addSubview:_balanceBtn];
    _balanceBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_balanceBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    [_balanceBtn setImage:[UIImage imageNamed:@"XD-img-2"] forState:UIControlStateNormal];
    [_balanceBtn setTitle:@"余额：￥0.00" forState:UIControlStateNormal];
    [_balanceBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
   
    _totalScoreBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 + (SCREEN_WIDTH/2 - 150)/2, CGRectGetMinY(_balanceBtn.frame), 150, 30)];
    [backdropImgView addSubview:_totalScoreBtn];
    _totalScoreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_totalScoreBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    [_totalScoreBtn setImage:[UIImage imageNamed:@"XD-img-3"] forState:UIControlStateNormal];
    [_totalScoreBtn setTitle:@"积分：0.00" forState:UIControlStateNormal];
    [_totalScoreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    
    _currentHeight = CGRectGetMaxY(backdropImgView.frame) + 10;
    [self orderViewUI];
}

#pragma mark 订单按钮布局
-(void)orderViewUI{
    
    _orderView = [[UIView alloc]initWithFrame:CGRectMake(0, _currentHeight, SCREEN_WIDTH, 0)];
    _orderView.backgroundColor = [UIColor whiteColor];
    [self.headView addSubview:_orderView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 150, 40)];
    [_orderView addSubview:titleLabel];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"我的订单";
    titleLabel.textColor = [ResourceManager color_1];
    
    UIButton *allOrderBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 95, 0, 90, 40)];
    [_orderView addSubview:allOrderBtn];
    allOrderBtn.tag = 99;
    allOrderBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [allOrderBtn setTitle:@"查看全部 >" forState:UIControlStateNormal];
    [allOrderBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    [allOrderBtn addTarget:self action:@selector(orderTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), SCREEN_WIDTH, 0.5)];
    [_orderView addSubview:lineView];
    lineView.backgroundColor = [ResourceManager color_5];
    
    CGFloat btnWidth = SCREEN_WIDTH/5;
    NSArray *imgArr = @[@"XD-img-4",@"XD-img-5",@"XD-img-6",@"XD-img-7",@"XD-img-8"];
    NSArray *titleArr = @[@"待付款",@"待发货",@"已发货",@"待评价",@"退款/售后"];
    for (int i = 0; i < imgArr.count; i ++) {
        JXButton *orderBtn = [[JXButton alloc]initWithFrame:CGRectMake(btnWidth * i, CGRectGetMaxY(lineView.frame), btnWidth, btnWidth - 10)];
        [_orderView addSubview:orderBtn];
        orderBtn.textFont = [UIFont systemFontOfSize:13];
        orderBtn.tag = i + 100;
        [orderBtn addTarget:self action:@selector(orderTouch:) forControlEvents:UIControlEventTouchUpInside];
        [orderBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        [orderBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        [orderBtn setImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        
        _orderView.height = CGRectGetMaxY(orderBtn.frame) + 10;
        
        if (i == 0) {
            _dfkNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth - 34, 8, 12, 12)];
            [orderBtn addSubview:_dfkNumLabel];
            _dfkNumLabel.clipsToBounds = YES;
            _dfkNumLabel.layer.cornerRadius = 12/2;
            _dfkNumLabel.backgroundColor = UIColorFromRGB(0xaf0e1d);
            _dfkNumLabel.textColor = [UIColor whiteColor];
            _dfkNumLabel.textAlignment = NSTextAlignmentCenter;
            _dfkNumLabel.font = [UIFont systemFontOfSize:8];
            _dfkNumLabel.hidden = YES;
        }else if (i == 1) {
            _dfhNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth - 34, 8, 12, 12)];
            [orderBtn addSubview:_dfhNumLabel];
            _dfhNumLabel.clipsToBounds = YES;
            _dfhNumLabel.layer.cornerRadius = 12/2;
            _dfhNumLabel.backgroundColor = UIColorFromRGB(0xaf0e1d);
            _dfhNumLabel.textColor = [UIColor whiteColor];
            _dfhNumLabel.textAlignment = NSTextAlignmentCenter;
            _dfhNumLabel.font = [UIFont systemFontOfSize:8];
            _dfhNumLabel.hidden = YES;
        }else if (i == 2) {
            _yfhNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth - 34, 8, 12, 12)];
            [orderBtn addSubview:_yfhNumLabel];
            _yfhNumLabel.clipsToBounds = YES;
            _yfhNumLabel.layer.cornerRadius = 12/2;
            _yfhNumLabel.backgroundColor = UIColorFromRGB(0xaf0e1d);
            _yfhNumLabel.textColor = [UIColor whiteColor];
            _yfhNumLabel.textAlignment = NSTextAlignmentCenter;
            _yfhNumLabel.font = [UIFont systemFontOfSize:8];
            _yfhNumLabel.hidden = YES;
        }else if (i == 3) {
            _dpjNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth - 34, 8, 12, 12)];
            [orderBtn addSubview:_dpjNumLabel];
            _dpjNumLabel.clipsToBounds = YES;
            _dpjNumLabel.layer.cornerRadius = 12/2;
            _dpjNumLabel.backgroundColor = UIColorFromRGB(0xaf0e1d);
            _dpjNumLabel.textColor = [UIColor whiteColor];
            _dpjNumLabel.textAlignment = NSTextAlignmentCenter;
            _dpjNumLabel.font = [UIFont systemFontOfSize:8];
             _dpjNumLabel.hidden = YES;
        }else if (i == 4) {
            _tkNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth - 34, 8, 12, 12)];
            [orderBtn addSubview:_tkNumLabel];
            _tkNumLabel.clipsToBounds = YES;
            _tkNumLabel.layer.cornerRadius = 12/2;
            _tkNumLabel.backgroundColor = UIColorFromRGB(0xaf0e1d);
            _tkNumLabel.textColor = [UIColor whiteColor];
            _tkNumLabel.textAlignment = NSTextAlignmentCenter;
            _tkNumLabel.font = [UIFont systemFontOfSize:8];
            _tkNumLabel.hidden = YES;
        }
    }
    
    _logisticsView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_orderView.frame), SCREEN_WIDTH, 0)];
    _logisticsView.backgroundColor = [UIColor whiteColor];
    [_headView addSubview:_logisticsView];
    
    _currentHeight = CGRectGetMaxY(_logisticsView.frame);
     _headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _currentHeight);
}

#pragma mark--footerViewUI
-(void)footerViewUI{
    
    UIView *functView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_WIDTH/3 * 2)];
    functView.backgroundColor = [UIColor whiteColor];
    [_footerView addSubview:functView];
    
    _footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(functView.frame) + 20);
    
    CGFloat btnWidth = SCREEN_WIDTH/3;
    NSArray *imgArr = @[@"XD-img-9",@"XD-img-10",@"XD-img-11",@"XD-img-12",@"XD-img-13",@"XD-img-14"];
    NSArray *titleArr = @[@"我的余额",@"我的积分",@"优惠券",@"我的收藏",@"地址管理",@"客服中心"];
    
    UIView *lineView_1 = [[UIView alloc]initWithFrame:CGRectMake(15, btnWidth, SCREEN_WIDTH - 30, 0.5)];
    [functView addSubview:lineView_1];
    lineView_1.backgroundColor = [ResourceManager color_5];
    
    UIView *lineView_2 = [[UIView alloc]initWithFrame:CGRectMake(btnWidth, 15, 0.5, btnWidth * 2 - 30)];
    [functView addSubview:lineView_2];
    lineView_2.backgroundColor = [ResourceManager color_5];
    
    UIView *lineView_3 = [[UIView alloc]initWithFrame:CGRectMake(btnWidth * 2, 15, 0.5, btnWidth * 2 - 30)];
    [functView addSubview:lineView_3];
    lineView_3.backgroundColor = [ResourceManager color_5];
    
    for (int i = 0; i < 3; i ++) {
        for (int j = 0; j < 3; j ++) {
            if ( i * 3 + j < imgArr.count) {
                if ( i * 3 + j == 2) {
                    _couponBtn = [[JXButton alloc]initWithFrame:CGRectMake(btnWidth * j + (btnWidth - 80)/2, btnWidth * i + (btnWidth - 80)/2, 80, 80)];
                    [functView addSubview:_couponBtn];
                    _couponBtn.tag =  i * 3 + j;
                    [_couponBtn addTarget:self action:@selector(functTouch:) forControlEvents:UIControlEventTouchUpInside];
                    [_couponBtn setTitle:titleArr[ i * 3 + j] forState:UIControlStateNormal];
                    [_couponBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
                    [_couponBtn setImage:[UIImage imageNamed:imgArr[ i * 3 + j]] forState:UIControlStateNormal];
                }else{
                    JXButton *functBtn = [[JXButton alloc]initWithFrame:CGRectMake(btnWidth * j + (btnWidth - 80)/2, btnWidth * i + (btnWidth - 80)/2, 80, 80)];
                    [functView addSubview:functBtn];
                    functBtn.tag =  i * 3 + j;
                    [functBtn addTarget:self action:@selector(functTouch:) forControlEvents:UIControlEventTouchUpInside];
                    [functBtn setTitle:titleArr[ i * 3 + j] forState:UIControlStateNormal];
                    [functBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
                    [functBtn setImage:[UIImage imageNamed:imgArr[ i * 3 + j]] forState:UIControlStateNormal];
                }
            }
        }
    }
    
}

-(void)userInfo{
    if (![CommonInfo isLoggedIn]) {
        [DDGUserInfoEngine engine].parentViewController = self;
        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
        return;
    }
    UserInfoViewController *ctl = [[UserInfoViewController alloc]init];
    [self.navigationController pushViewController:ctl animated:YES];
}

#pragma mark----订单按钮点击事件orderTouch
-(void)orderTouch:(UIButton *)sender{
    if (![CommonInfo isLoggedIn]) {
        [DDGUserInfoEngine engine].parentViewController = self;
        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
        return;
    }
    
    NSLog(@"%ld",sender.tag);
    switch (sender.tag) {
        case 99:{
            //全部订单
            OrderViewController *ctl = [[OrderViewController alloc]init];
            ctl.orderIndex = 0;
            [self.navigationController pushViewController:ctl animated:YES];
        }break;
        case 100:{
            //代付款
            OrderViewController *ctl = [[OrderViewController alloc]init];
            ctl.orderIndex = 1;
            [self.navigationController pushViewController:ctl animated:YES];
        }break;
        case 101:{
            //代发货
            OrderViewController *ctl = [[OrderViewController alloc]init];
            ctl.orderIndex = 2;
            [self.navigationController pushViewController:ctl animated:YES];
        }break;
        case 102:{
            //已发货
            OrderViewController *ctl = [[OrderViewController alloc]init];
            ctl.orderIndex = 3;
            [self.navigationController pushViewController:ctl animated:YES];
        }break;
        case 103:{
            //待评价
            AppraiseListViewController *ctl = [[AppraiseListViewController alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
        }break;
        case 104:{
            //退款/售后
            RefundListVC *ctl = [[RefundListVC alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
        }break;
        default:
            break;
    }
    
}

#pragma mark----funct底部功能按钮点击事件
-(void)functTouch:(UIButton *)sender{
    if (![CommonInfo isLoggedIn]) {
        [DDGUserInfoEngine engine].parentViewController = self;
        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
        return;
    }
    switch (sender.tag) {
        case 0:{
            //我的余额
            MyBalanceViewController *ctl = [[MyBalanceViewController alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
        }break;
        case 1:{
            //我的积分     
            XcodeWebVC  *vc = [[XcodeWebVC alloc] init];
            vc.homeUrl = @"webMall/score";
            vc.titleStr = @"我的积分";
            [self.navigationController pushViewController:vc animated:YES];
        }break;
        case 2:{
            //优惠券
            CouponViewController *ctl = [[CouponViewController alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
        }break;
        case 3:{
            //我的收藏
            MyCollectViewController *ctl = [[MyCollectViewController alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
        }break;
        case 4:{
            //地址管理
            AddressViewController *ctl = [[AddressViewController alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
        }break;
        case 5:{
            //客服中心
            CustomerServiceViewController *ctl = [[CustomerServiceViewController alloc]init];
            [self.navigationController pushViewController:ctl animated:YES];
        }break;
        default:
            break;
    }
    
}





-(void)addButtonView{
    [self.view addSubview:self.tabBar];
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
