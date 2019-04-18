//
//  RefundRequstSecond.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/9.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "RefundRequstSecond.h"
#import "RefundCommitVC.h"


#define orderCellHeight  130


@interface RefundRequstSecond ()
{
    UIScrollView  *scView;
    
    NSMutableArray *arrBtn;
    
    NSArray *orderDtlListArr;
    
    NSString *strAllSel;
}

@property(nonatomic, strong)UIImageView *productImgView;  //商品图片

@property(nonatomic, strong)UILabel *productNameLabel;  //商品名称

@property(nonatomic, strong)UILabel *productDescLabel;    //商品描述

@property(nonatomic, strong)UILabel *productPriceLabel;   //商品价格

@property(nonatomic, strong)UILabel *productNumLabel;   //商品数量

@end




@implementation RefundRequstSecond

#pragma mark --- lifecylce
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    
    [self layoutNaviBarViewWithTitle:@"售后服务"];
    
    [self getShopListFormWeb];
    
    //[self layoutUI];
}

-(void) initData
{
    arrBtn = [[NSMutableArray alloc] init];
    
}


#pragma mark --- 布局UI
-(void) layoutUI
{
    NSLog(@"dicParmas:%@",_dicParams);

    //orderDtlListArr = [_dicParams objectForKey:@"orderDtlList"];
    if (orderDtlListArr.count == 0)
     {
        return;
     }
    
    int iTopY = NavHeight;
    int iLeftX = 15;
    
    UIView *viewAllCheck = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, 40)];
    [self.view addSubview:viewAllCheck];
    viewAllCheck.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, 5, 30, 30)];
    [viewAllCheck addSubview:btnLeft];
    [btnLeft setImage:[UIImage imageNamed:@"od_gou1"] forState:UIControlStateNormal];
    [btnLeft setImage:[UIImage imageNamed:@"od_gou2"] forState:UIControlStateSelected];
    [btnLeft addTarget:self action:@selector(selectAllClick:) forControlEvents:UIControlEventTouchUpInside];
    btnLeft.selected = NO;
    
    UILabel *labelAll = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + btnLeft.width + 10, 0, 200, viewAllCheck.height)];
    [viewAllCheck addSubview:labelAll];
    labelAll.textColor = [ResourceManager color_1];
    labelAll.font = [UIFont systemFontOfSize:14];
    labelAll.text = @"全选";
    
//    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
//    [viewAllCheck addSubview:viewFG];
//    viewFG.backgroundColor = [ResourceManager color_5];
    
    UIView *viewFG2 = [[UIView alloc] initWithFrame:CGRectMake(15, viewAllCheck.height - 1, SCREEN_WIDTH- 30, 1)];
    [viewAllCheck addSubview:viewFG2];
    viewFG2.backgroundColor = [ResourceManager color_5];
    
    
    iTopY += viewAllCheck.height;
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, iTopY, SCREEN_WIDTH, SCREEN_HEIGHT - iTopY - 60)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 300);
    //scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [ResourceManager viewBackgroundColor];
    
    
    UIColor *color_1 = [ResourceManager color_1];
    UIColor *color_2 = [ResourceManager color_6];
    UIFont *font_1 = [UIFont systemFontOfSize:13];
    UIFont *font_2 = [UIFont systemFontOfSize:12];
    
    iTopY = 0;
    int iCellLeftX = 15;
    int iCellTopY = 0;
    for (int i = 0; i < orderDtlListArr.count; i++) {
        
        NSDictionary *dic = orderDtlListArr[i];
        UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, orderCellHeight)];
        [scView addSubview:viewCell];
        viewCell.backgroundColor = [UIColor whiteColor];
        viewCell.userInteractionEnabled = YES;
        
        
        iCellTopY = 15;
        iCellLeftX = 15;
        
        UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, 30, 30)];
        [viewCell addSubview:btnLeft];
        [btnLeft setImage:[UIImage imageNamed:@"od_gou1"] forState:UIControlStateNormal];
        [btnLeft setImage:[UIImage imageNamed:@"od_gou2"] forState:UIControlStateSelected];
        [btnLeft addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btnLeft.tag = i;
        btnLeft.selected = NO;
        
        [arrBtn addObject:btnLeft];
        
        
        iCellLeftX += btnLeft.width + 5;
        _productImgView = [[UIImageView alloc]initWithFrame:CGRectMake(iCellLeftX, iCellTopY, 70, 70)];
        [viewCell addSubview:_productImgView];
        _productImgView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        [_productImgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"goodsUrl"]]];
        
        _productNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_productImgView.frame) + 10, CGRectGetMinY(_productImgView.frame) + 5, 200, 20)];
        [viewCell addSubview:_productNameLabel];
        _productNameLabel.font = font_1;
        _productNameLabel.textColor = color_1;
        _productNameLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"goodsName"]];
        
        _productDescLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_productImgView.frame) + 10, CGRectGetMaxY(_productNameLabel.frame) + 5, 200, 20)];
        [viewCell addSubview:_productDescLabel];
        _productDescLabel.font = font_2;
        _productDescLabel.textColor = color_2;
        _productDescLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"skuDesc"]];
        
        _productPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, CGRectGetMinY(_productImgView.frame) + 5, 143, 20)];
        [viewCell addSubview:_productPriceLabel];
        _productPriceLabel.textAlignment = NSTextAlignmentRight;
        _productPriceLabel.font = font_1;
        _productPriceLabel.textColor = color_2;
        _productPriceLabel.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"price"]];
        
        _productNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, CGRectGetMaxY(_productPriceLabel.frame) + 5, 143, 20)];
        [viewCell addSubview:_productNumLabel];
        _productNumLabel.textAlignment = NSTextAlignmentRight;
        _productNumLabel.font = font_2;
        _productNumLabel.textColor = color_2;
        _productNumLabel.text = [NSString stringWithFormat:@"x%@",[dic objectForKey:@"num"]];
        
        
        UIView *lineViewX = [[UIView alloc]initWithFrame:CGRectMake(0, orderCellHeight -10, SCREEN_WIDTH, 10)];
        [viewCell addSubview:lineViewX];
        lineViewX.backgroundColor = [ResourceManager viewBackgroundColor];

        iTopY += orderCellHeight;
    }
    
    scView.contentSize =  CGSizeMake(0, iTopY);
    
    
    UIButton *btnCommit = [[UIButton alloc] initWithFrame:CGRectMake(15, SCREEN_HEIGHT - 50, SCREEN_WIDTH - 30, 45)];
    [self.view addSubview:btnCommit];
    [btnCommit setTitle:@"提交申请" forState:UIControlStateNormal];
    btnCommit.cornerRadius = 3;
    [btnCommit setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    btnCommit.titleLabel.font = [UIFont systemFontOfSize:14];
    btnCommit.borderColor = [ResourceManager mainColor];
    btnCommit.borderWidth = 1;
    btnCommit.backgroundColor = [UIColor whiteColor];
    [btnCommit addTarget:self action:@selector(actionCommit) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) btnAllUnCheck
{

    for (int i= 0; i< [arrBtn count]; i++)
     {
        UIButton  *btnTemp = arrBtn[i];
        btnTemp.selected = NO;
     }
}

-(void) btnAllCheck
{
    
    for (int i= 0; i< [arrBtn count]; i++)
     {
        UIButton  *btnTemp = arrBtn[i];
        btnTemp.selected = YES;
     }
}

#pragma mark --- action
-(void) selectBtnClick:(UIButton*) sender
{
    BOOL curSelState = sender.selected;
    
    [self btnAllUnCheck];
    
    sender.selected = !curSelState;
}

-(void) selectAllClick:(UIButton*) sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected)
     {
        [self btnAllCheck];
     }
    else
     {
        [self btnAllUnCheck];
     }
}


-(void) actionCommit
{
    NSString *strAll = @"";
    for (int i= 0; i< [arrBtn count]; i++)
     {
        UIButton  *btnTemp = arrBtn[i];
        NSDictionary *obj = orderDtlListArr[i];
        if (btnTemp.selected)
         {
            //[arrSel addObject:@(i)];
            strAll = [strAll stringByAppendingString:obj[@"subOrderNo"]];
            strAll = [strAll stringByAppendingString:@","];
         }
     }
    
    strAll = [strAll substringToIndex:strAll.length - 1];
    
    if (strAll.length <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请选择商品" toView:self.view];
        return;
     }

    [self getUIDataFormWeb:strAll];
    
    
}

#pragma mark  --- 网络请求
-(void) getShopListFormWeb
{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = _dicParams[@"orderNo"];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString], kURLrefundGoodsList];
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
    operation.tag = 999;
}



-(void) getUIDataFormWeb:(NSString *) strValue
{
    strAllSel = strValue;
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = _dicParams[@"orderNo"];
    params[@"subOrderNos"] = strValue;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString], kURLselectRefundGoods];
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
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

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    if (999 == operation.tag)
     {
        orderDtlListArr = operation.jsonResult.rows;
        [self layoutUI];
     }
    
    if (1000 == operation.tag)
     {
        RefundCommitVC  *VC = [[RefundCommitVC alloc] init];
        VC.dicParams = [[NSDictionary alloc] init];
        VC.dicParams =  _dicParams;
        VC.subOrderNo = strAllSel;
        VC.iCommitType = _iCommitType;
        [self.navigationController pushViewController:VC animated:YES];
     }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}

@end
