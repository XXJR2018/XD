//
//  CouponViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/26.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "CouponViewController.h"

#import "CouponViewCell.h"
#import "ShopCouponViewCell.h"

@interface CouponViewController ()<UIGestureRecognizerDelegate>
{
    
    UIButton *_yhjBtn;
    UIButton *_gwjBtn;
    UIView *_lineViewX;
    UIButton *_wsyListBtn;
    UIButton *_ysyListBtn;
    UIButton *_ygqListBtn;
    NSString *_custPromocardId;
    UIView *_shareAlertView;
    UIView *_sheetView;
}
@end

@implementation CouponViewController

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_wsyListBtn.selected) {
        params[@"status"] = @"1";
    }else if (_ysyListBtn.selected) {
        params[@"status"] = @"2";
    }else{
        params[@"status"] = @"3";
    }
    if (_yhjBtn.selected) {
        params[@"preferentialType"] = @"1";
    }else{
        params[@"preferentialType"] = @"2";
    }
    params[kPage] = @(self.pageIndex);
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/cust/activity/custPromocardListNew",[PDAPI getBaseUrlString]]
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
    [_tableView.mj_header endRefreshing];
    [_tableView.mj_footer endRefreshing];
    if (operation.tag == 1001) {
        if (operation.jsonResult.rows.count > 0) {
            [self reloadTableViewWithArray:operation.jsonResult.rows];
        }else{
            if (self.pageIndex == 1){
                [self reloadTableViewWithArray:operation.jsonResult.rows];
            }else{
                self.pageIndex --;
                [MBProgressHUD showErrorWithStatus:@"没有更多数据了" toView:self.view];
            }
        }
    }else if (operation.tag == 1002) {
        NSDictionary *shareInfo = [operation.jsonResult.attr objectForKey:@"shareInfo"];
        if (shareInfo.count > 0) {
            [self freeShare:shareInfo];
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
    [MobClick beginLogPageView:@"优惠券"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"优惠券"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"优惠券"];
    
    _tableView.backgroundColor = [ResourceManager viewBackgroundColor];
    [_tableView setTableFooterView:[UIView new]];
    [_tableView registerNib:[UINib nibWithNibName:@"CouponViewCell" bundle:nil] forCellReuseIdentifier:@"Coupon_Cell"];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_tableView setSeparatorColor:[UIColor clearColor]];
    
    [self layoutUI];
    if (self.couponType == 1) {
        [self couponSort:_yhjBtn];
    }else if (self.couponType == 2) {
        [self couponSort:_gwjBtn];
    }
}

-(void)layoutUI{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavHeight + 50)];
    [self.view addSubview:headerView];
    headerView.backgroundColor = [UIColor whiteColor];
    
    _yhjBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 85, NavHeight - 40, 85, 40)];
    [headerView addSubview:_yhjBtn];
    _yhjBtn.tag = 100;
    [_yhjBtn setTitle:@"优惠券" forState:UIControlStateNormal];
    _yhjBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_yhjBtn setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
    [_yhjBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateSelected];
    [_yhjBtn addTarget:self action:@selector(couponSort:) forControlEvents:UIControlEventTouchUpInside];
    _yhjBtn.selected = YES;
    
    _gwjBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, NavHeight - 40, 85, 40)];
    [headerView addSubview:_gwjBtn];
    _gwjBtn.tag = 101;
    [_gwjBtn setTitle:@"购物券" forState:UIControlStateNormal];
    _gwjBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [_gwjBtn setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
    [_gwjBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateSelected];
    [_gwjBtn addTarget:self action:@selector(couponSort:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView_1 = [[UIView alloc]initWithFrame:CGRectMake(0, NavHeight - 0.5, SCREEN_WIDTH, 0.5)];
    [headerView addSubview:lineView_1];
    lineView_1.backgroundColor = [ResourceManager color_5];
    
    _lineViewX = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMidX(_yhjBtn.frame) - 30, CGRectGetMaxY(_yhjBtn.frame) - 1, 60, 1)];
    [headerView addSubview:_lineViewX];
    _lineViewX.backgroundColor = [ResourceManager mainColor];
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, NavHeight - 40, 50, 40)];
    [headerView addSubview:backBtn];
    [backBtn setImage:[ResourceManager arrow_return] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *explainBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90, NavHeight - 40, 90, 40)];
    [headerView addSubview:explainBtn];
    [explainBtn setTitle:@"使用说明" forState:UIControlStateNormal];
    explainBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [explainBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    [explainBtn addTarget:self action:@selector(explain) forControlEvents:UIControlEventTouchUpInside];
    
    _wsyListBtn = [[UIButton alloc]init];
    _ysyListBtn = [[UIButton alloc]init];
    _ygqListBtn = [[UIButton alloc]init];
    NSArray *btnArr = @[_wsyListBtn,_ysyListBtn,_ygqListBtn];
    NSArray *titleArr = @[@"未使用",@"已使用",@"已过期"];
    for (int i = 0; i < btnArr.count; i ++) {
        UIButton *btn = ((UIButton *)btnArr[i]);
        [headerView addSubview:btn];
        btn.frame = CGRectMake(SCREEN_WIDTH/3 * i, NavHeight, SCREEN_WIDTH/3, 50);
        btn.backgroundColor = [UIColor whiteColor];
        btn.tag = i;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        [btn setTitleColor:[ResourceManager mainColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(couponTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIView *lineView_2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_wsyListBtn.frame) - 0.5, SCREEN_WIDTH, 0.5)];
    [headerView addSubview:lineView_2];
    lineView_2.backgroundColor = [ResourceManager color_5];
    
    _wsyListBtn.selected = YES;
}

- (CGRect)tableViewFrame{
    return CGRectMake(0, NavHeight + 65, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight - 65);
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

//使用说明
-(void)explain{
    NSString *url = [NSString stringWithFormat:@"%@webMall/protocol/coupon",[PDAPI WXSysRouteAPI]];
    [CCWebViewController showWithContro:self withUrlStr:url withTitle:@"使用说明"];
}

-(void)couponSort:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    if (sender == _yhjBtn) {
        _yhjBtn.selected = YES;
        _gwjBtn.selected = NO;
        _lineViewX.frame = CGRectMake(CGRectGetMidX(_yhjBtn.frame) - 30, CGRectGetMaxY(_yhjBtn.frame) - 1, 60, 1);
        [_tableView registerNib:[UINib nibWithNibName:@"CouponViewCell" bundle:nil] forCellReuseIdentifier:@"Coupon_Cell"];
    }else{
        _yhjBtn.selected = NO;
        _gwjBtn.selected = YES;
        _lineViewX.frame = CGRectMake(CGRectGetMidX(_gwjBtn.frame) - 30, CGRectGetMaxY(_gwjBtn.frame) - 1, 60, 1);
        [_tableView registerNib:[UINib nibWithNibName:@"ShopCouponViewCell" bundle:nil] forCellReuseIdentifier:@"ShopCoupon_Cell"];
    }
    _wsyListBtn.selected = YES;
    _ysyListBtn.selected = NO;
    _ygqListBtn.selected = NO;
    [self.dataArray removeAllObjects];
    self.pageIndex = 1;
    [self loadData];
}

-(void)couponTouch:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    if (sender.tag == 0) {
        _wsyListBtn.selected = YES;
        _ysyListBtn.selected = NO;
        _ygqListBtn.selected = NO;
    }else if (sender.tag == 1) {
        _wsyListBtn.selected = NO;
        _ysyListBtn.selected = YES;
        _ygqListBtn.selected = NO;
    }else{
        _wsyListBtn.selected = NO;
        _ysyListBtn.selected = NO;
        _ygqListBtn.selected = YES;
    }
    [self.dataArray removeAllObjects];
    self.pageIndex = 1;
    [self loadData];
}

#pragma mark === UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count == 0) {
        return  1;
    }else{
        return self.dataArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return  tableView.frame.size.height - tableView.tableHeaderView.frame.size.height;
    }else{
        if (_yhjBtn.selected) {
            return 130;
        }else{
            return 150;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return  [self noDataCell:tableView];
    }
    if (_yhjBtn.selected) {
        CouponViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Coupon_Cell"];
        if (!cell) {
            cell = [[CouponViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Coupon_Cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.employBlock = ^{
            [self.navigationController popToRootViewControllerAnimated:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@"1"}];
        };
        cell.dataDicionary = self.dataArray[indexPath.row];
        return cell;
    }else{
        ShopCouponViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCoupon_Cell"];
        if (!cell) {
            cell = [[ShopCouponViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShopCoupon_Cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.shareBlock = ^{
            _custPromocardId = [NSString stringWithFormat:@"%@",[self.dataArray[indexPath.row] objectForKey:@"custPromocardId"]];
            [self shareAlertViewUI];
        };
        
        cell.dataDicionary = self.dataArray[indexPath.row];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //（这种是没有点击后的阴影效果)
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

#pragma mark ------share
-(void)sharePromocardUrl{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"custPromocardId"] = _custPromocardId;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/cust/activity/sharePromocard",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
    operation.tag = 1002;
}

//分享链接给好友
-(void)freeShare:(NSDictionary *)dicShare {
     [self hidenAlert];
    
    NSString *shareUrl = dicShare[@"url"];
    NSString *shareTitle = dicShare[@"title"];
    NSString *shareSubTitle = dicShare[@"content"];
    NSString *shareImgStr = dicShare[@"image"];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImgStr]]];
    if (image && (image.size.width > 100  || image.size.height > 100)) {
        image = [image scaledToSize:CGSizeMake(100, 100*image.size.height/image.size.width)];
    }
    [[DDGShareManager shareManager] weChatShare:@{@"title":shareTitle, @"subTitle":shareSubTitle,@"image":UIImageJPEGRepresentation(image,1.0),@"url": shareUrl} shareScene:0];
    [[DDGShareManager  shareManager] setBlock:^(id obj) {
        NSDictionary *dic = (NSDictionary *)obj;
        if ([[dic objectForKey:@"success"] boolValue]) {
            [MBProgressHUD showSuccessWithStatus:@"分享成功" toView:self.view];
            [self loadData];
        }else{
            [MBProgressHUD showErrorWithStatus:@"分享失败" toView:self.view];
        }
    }];
//    [[DDGShareManager shareManager] share:ShareContentTypeNews items:@{@"title":shareTitle, @"subTitle":shareSubTitle?:@"",@"image":UIImageJPEGRepresentation(image,1.0),@"url": shareUrl} types:@[DDGShareTypeWeChat_haoyou,DDGShareTypeWeChat_pengyouquan,DDGShareTypeQQ,DDGShareTypeQQqzone,DDGShareTypeCopyUrl] showIn:self block:^(id result){
//        NSDictionary *dic = (NSDictionary *)result;
//        if ([[dic objectForKey:@"success"] boolValue]) {
//            [MBProgressHUD showSuccessWithStatus:@"分享成功" toView:self.view];
//        }else{
//            [MBProgressHUD showErrorWithStatus:@"分享失败" toView:self.view];
//        }
//    }];
}

// 分享二维码图片到朋友圈
-(void)shareCodeUrl{
     [self hidenAlert];
    NSString *shareCodeUrl =  [NSString stringWithFormat:@"%@appMall/account/cust/activity/shareCode?signId=%@&custPromocardId=%@",[PDAPI getBaseUrlString],[CommonInfo signId],_custPromocardId];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareCodeUrl]]];
    [[DDGShareManager shareManager] weChatShare:@{@"image":UIImageJPEGRepresentation(image,1.0)} shareScene:1];
    [[DDGShareManager  shareManager] setBlock:^(id obj) {
        NSDictionary *dic = (NSDictionary *)obj;
        if ([[dic objectForKey:@"success"] boolValue]) {
            [MBProgressHUD showSuccessWithStatus:@"分享成功" toView:self.view];
            [self loadData];
        }else{
            [MBProgressHUD showErrorWithStatus:@"分享失败" toView:self.view];
        }
    }];
//    [[DDGShareManager shareManager] share:ShareContentTypeNews items:@{@"image":UIImageJPEGRepresentation(image,1.0)} types:@[DDGShareTypeWeChat_haoyou,DDGShareTypeWeChat_pengyouquan,DDGShareTypeQQ,DDGShareTypeQQqzone] showIn:self block:^(id result){
//        NSDictionary *dic = (NSDictionary *)result;
//        if ([[dic objectForKey:@"success"] boolValue]) {
//            [MBProgressHUD showSuccessWithStatus:@"分享成功" toView:self.view];
//        }else{
//            [MBProgressHUD showErrorWithStatus:@"分享失败" toView:self.view];
//        }
//    }];
    
}


#pragma mark - shareAlertViewUI
-(void)shareAlertViewUI{
    [_shareAlertView removeFromSuperview];
    
    _shareAlertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_shareAlertView];
    _shareAlertView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidenAlert)];
    gesture.numberOfTapsRequired  = 1;
    gesture.delegate = self;
    [_shareAlertView addGestureRecognizer:gesture];
    
    _sheetView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 280, SCREEN_WIDTH, 280)];
    [_shareAlertView addSubview:_sheetView];
    _sheetView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    [_sheetView addSubview:titleLabel];
    titleLabel.textColor = [ResourceManager color_1];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"赠送给好友";

    UIView *ruleView = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame), SCREEN_WIDTH - 30, 100)];
    [_sheetView addSubview:ruleView];
    ruleView.layer.cornerRadius = 8;
    ruleView.layer.borderWidth = 0.5;
    ruleView.layer.borderColor = [ResourceManager color_5].CGColor;
    
    UILabel *subitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, ruleView.frame.size.width - 20, 90)];
    [ruleView addSubview:subitleLabel];
    subitleLabel.textColor = [ResourceManager color_1];
    subitleLabel.numberOfLines = 0;
    subitleLabel.font = [UIFont systemFontOfSize:12];
    subitleLabel.text = @"赠送规则：\n1.赠送出的劵在您的账户中不能使用了\n2.分享后没有人领取会在24小时后退回，若购物劵有效期小于24小时，那么购物劵退回时会自动作废";
    
    for (int i = 0; i < 2; i++) {
        UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4 - 50 + SCREEN_WIDTH/2 * i, CGRectGetMaxY(ruleView.frame), 100, 120)];
        [_sheetView addSubview:shareBtn];
        shareBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [shareBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
       
        if (i == 0) {
            [shareBtn setTitle:@"微信好友" forState:UIControlStateNormal];
            [shareBtn setImage:[UIImage imageNamed:@"com_wechat"] forState:UIControlStateNormal];
            [shareBtn addTarget:self action:@selector(sharePromocardUrl) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [shareBtn setTitle:@"微信朋友圈" forState:UIControlStateNormal];
            [shareBtn setImage:[UIImage imageNamed:@"com_wepyq"] forState:UIControlStateNormal];
            [shareBtn addTarget:self action:@selector(shareCodeUrl) forControlEvents:UIControlEventTouchUpInside];
        }
        
        //使图片和文字水平居中显示
        [shareBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-shareBtn.imageView.frame.size.width, -shareBtn.imageView.frame.size.height - 10,0)];
        [shareBtn setImageEdgeInsets:UIEdgeInsetsMake(-shareBtn.titleLabel.intrinsicContentSize.height - 10, 0, 0, -shareBtn.titleLabel.intrinsicContentSize.width)];
    }
    
}

//确定
-(void)hidenAlert{
    [_shareAlertView removeFromSuperview];
}

#pragma mark-UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if ([touch.view isDescendantOfView:_sheetView]) {
        return NO;
    }
    return YES;
}



@end
