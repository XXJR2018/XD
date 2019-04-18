//
//  PayResultVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/5.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "PayResultVC.h"
#import "OrderViewController.h"
#import "XcodeWebVC.h"

@interface PayResultVC ()
{
    UIView *viewFail;
    UIView *viewSuccess;
}
@end



@implementation PayResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"付款结果"];
    
    [self layoutUI];
    
}

#pragma mark --- 布局UI
-(void) layoutUI
{
    [self layoutSuccess];
    
    [self layoutFail];
    
    if (_isSuceess)
     {
        viewFail.hidden = YES;
     }
}

-(void) layoutSuccess
{
    viewSuccess = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight)];
    [self.view addSubview:viewSuccess];
    viewSuccess.backgroundColor = [UIColor whiteColor];
    
    int  iIMGWdiht = 50;
    int iTopY = 20;
    int iLeftX = (SCREEN_WIDTH - iIMGWdiht)/2;
    UIImageView  *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iIMGWdiht, iIMGWdiht)];
    [viewSuccess addSubview:imgView];
    imgView.image = [UIImage imageNamed:@"pay_success"];

    iTopY += imgView.height + 20;
    UILabel *labelFKCG = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [viewSuccess addSubview:labelFKCG];
    labelFKCG.textColor = [ResourceManager greenColor];
    labelFKCG.font = [UIFont systemFontOfSize:20];
    labelFKCG.textAlignment = NSTextAlignmentCenter;
    labelFKCG.text = @"付款成功";
    
    iTopY += labelFKCG.height + 25;
    int iBtnWidth = 90;
    iLeftX = (SCREEN_WIDTH - 2 *iBtnWidth  - 20)/2;
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iBtnWidth, 30)];
    [viewSuccess addSubview:btnLeft];
    [btnLeft setTitle:@"查看订单" forState:UIControlStateNormal];
    [btnLeft setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    btnLeft.titleLabel.font = [UIFont systemFontOfSize:14];
    btnLeft.borderColor = [ResourceManager lightGrayColor];
    btnLeft.borderWidth = 1;
    btnLeft.cornerRadius = 3;
    [btnLeft addTarget:self action:@selector(actionLookOrder) forControlEvents:UIControlEventTouchUpInside];
    
    iLeftX += iBtnWidth + 20;
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iBtnWidth, 30)];
    [viewSuccess addSubview:btnRight];
    [btnRight setTitle:@"继续逛" forState:UIControlStateNormal];
    [btnRight setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:14];
    btnRight.borderColor = [ResourceManager lightGrayColor];
    btnRight.borderWidth = 1;
    btnRight.cornerRadius = 3;
    [btnRight addTarget:self action:@selector(actionLook) forControlEvents:UIControlEventTouchUpInside];
    
    iTopY += btnLeft.height + 30;
    UIButton  *btnBottom = [[UIButton alloc] initWithFrame:CGRectMake(15, iTopY, SCREEN_WIDTH - 30, 80)];
    [viewSuccess addSubview:btnBottom];
    [btnBottom setBackgroundImage:[UIImage imageNamed:@"Tab_4-9"] forState:UIControlStateNormal];
    [btnBottom addTarget:self action:@selector(actionSigin) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

-(void) layoutFail
{
    viewFail = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT-NavHeight)];
    [self.view addSubview:viewFail];
    viewFail.backgroundColor = [UIColor whiteColor];
    
    int  iIMGWdiht = 50;
    int iTopY = 20;
    int iLeftX = (SCREEN_WIDTH - iIMGWdiht)/2;
    UIImageView  *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iIMGWdiht, iIMGWdiht)];
    [viewFail addSubview:imgView];
    imgView.image = [UIImage imageNamed:@"pay_fail"];
    
    iTopY += imgView.height + 20;
    UILabel *labelFKCG = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [viewFail addSubview:labelFKCG];
    labelFKCG.textColor = [ResourceManager priceColor];
    labelFKCG.font = [UIFont systemFontOfSize:20];
    labelFKCG.textAlignment = NSTextAlignmentCenter;
    labelFKCG.text = @"支付失败";
    
    iTopY += labelFKCG.height + 15;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 15)];
    [viewFail addSubview:label1];
    label1.textColor = [ResourceManager color_1];
    label1.font = [UIFont systemFontOfSize:12];
    label1.textAlignment = NSTextAlignmentCenter;
  
    
    NSString *strAll = @"请在 30分钟 内完成支付";
    NSString *strSub = @" 30分钟 ";
    NSRange range = [strAll rangeOfString:strSub];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strAll];
    [str addAttribute:NSForegroundColorAttributeName value:[ResourceManager priceColor] range:range]; //设置字体颜色
    //[str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:30.0] range:range]; //设置字体字号和字体类别
    label1.attributedText = str;
    
    iTopY += label1.height +5;
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 15)];
    [viewFail addSubview:label2];
    label2.textColor = [ResourceManager color_1];
    label2.font = [UIFont systemFontOfSize:12];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"超时订单会被系统取消";
    
    iTopY += label1.height + 25;
    int iBtnWidth = 90;
    iLeftX = (SCREEN_WIDTH - 2 *iBtnWidth  - 20)/2;
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iBtnWidth, 30)];
    [viewFail addSubview:btnLeft];
    [btnLeft setTitle:@"查看订单" forState:UIControlStateNormal];
    [btnLeft setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    btnLeft.titleLabel.font = [UIFont systemFontOfSize:14];
    btnLeft.borderColor = [ResourceManager lightGrayColor];
    btnLeft.borderWidth = 1;
    btnLeft.cornerRadius = 3;
    [btnLeft addTarget:self action:@selector(actionLookOrder) forControlEvents:UIControlEventTouchUpInside];
    
    iLeftX += iBtnWidth + 20;
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iBtnWidth, 30)];
    [viewFail addSubview:btnRight];
    [btnRight setTitle:@"重新付款" forState:UIControlStateNormal];
    [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnRight.backgroundColor = [ResourceManager priceColor];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:14];
//    btnRight.borderColor = [ResourceManager lightGrayColor];
//    btnRight.borderWidth = 1;
    btnRight.cornerRadius = 3;
    [btnRight addTarget:self action:@selector(actionRepay) forControlEvents:UIControlEventTouchUpInside];
    
    iTopY += btnLeft.height + 20;
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 10)];
    [viewFail addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager viewBackgroundColor];
    
    iTopY += viewFG.height + 20;
    iLeftX = 15;
    //订单金额
    UILabel *labelT1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 80, 20)];
    [viewFail addSubview:labelT1];
    labelT1.textColor = [ResourceManager midGrayColor];
    labelT1.font = [UIFont systemFontOfSize:14];
    labelT1.text = @"订单金额";
    
    UILabel *labelT1Value = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+80, iTopY, SCREEN_WIDTH - iLeftX - 110, 20)];
    [viewFail addSubview:labelT1Value];
    labelT1Value.textColor = [ResourceManager midGrayColor];
    labelT1Value.font = [UIFont systemFontOfSize:14];
    labelT1Value.text =  [NSString stringWithFormat:@"¥%@",_dicPayResult[@"totalOrderAmt"]];
    
    iTopY += labelT1.height + 10;
    //订单编码
    UILabel *labelT2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 80, 20)];
    [viewFail addSubview:labelT2];
    labelT2.textColor = [ResourceManager midGrayColor];
    labelT2.font = [UIFont systemFontOfSize:14];
    labelT2.text = @"订单编码";
    
    UILabel *labelT2Value = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+80, iTopY, SCREEN_WIDTH - iLeftX - 110, 20)];
    [viewFail addSubview:labelT2Value];
    labelT2Value.textColor = [ResourceManager midGrayColor];
    labelT2Value.font = [UIFont systemFontOfSize:14];
    labelT2Value.text = _dicPayResult[@"orderNo"];
    
    iTopY += labelT2.height + 10;
    //订单地址
//    UILabel *labelT3 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 80, 20)];
//    [viewFail addSubview:labelT3];
//    labelT3.textColor = [ResourceManager midGrayColor];
//    labelT3.font = [UIFont systemFontOfSize:14];
//    labelT3.text = @"订单地址";
//    
//    UILabel *labelT3Value = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+80, iTopY, SCREEN_WIDTH - iLeftX - 110, 40)];
//    [viewFail addSubview:labelT3Value];
//    labelT3Value.textColor = [ResourceManager midGrayColor];
//    labelT3Value.font = [UIFont systemFontOfSize:14];
//    labelT3Value.numberOfLines = 0;
//    labelT3Value.text = @"138198239183918391 asdflkjaslkf;asl;fkjas;lfajs;lfkwqiopueroipqwrueopiwqeuralsjdfl;ksadfajs;";
    
    
    

}

#pragma mark  ---   action
-(void) actionLook
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(1),@"index":@(0)}];
}


-(void) actionLookOrder
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(4),@"index":@(0)}];
}

-(void) actionRepay
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void) actionSigin
{
    XcodeWebVC  *vc = [[XcodeWebVC alloc] init];
    vc.homeUrl = @"webMall/score";
    vc.titleStr = @"我的积分";
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)clickNavButton:(UIButton *)button{
//    if (_isSuceess)
//     {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//        return;
//     }
//    [self.navigationController popViewControllerAnimated:YES];
    
    OrderViewController *ctl = [[OrderViewController alloc]init];
    ctl.orderIndex = 0;
    if (_isSuceess)
     {
        ctl.orderIndex = 1;
     }
    [self.navigationController pushViewController:ctl animated:YES];
}

@end
