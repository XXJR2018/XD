//
//  RefundRequstFrist.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/9.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "RefundRequstFrist.h"
#import "RefundRequstSecond.h"

@interface RefundRequstFrist ()

@end

@implementation RefundRequstFrist

#pragma mark  ---  lifecylce

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"售后服务"];
    
    [self layoutUI];
}


#pragma mark --- 布局UI
-(void) layoutUI
{
    self.view.backgroundColor = [ResourceManager viewBackgroundColor];
    

    int iCellHeight = 80;
    int iTopY = NavHeight + 10;
    
    NSArray *arrName = @[@"退货退款",@"仅退款"];
    NSArray *arrSubTitle = @[@"因为质量、错发等问题需要退货退款，或因漏发需要退款",@"拒收包裹或者未收到包裹"];
    NSArray *arrImg = @[@"Refund_tui",@"Refund_qian"];
    
    
    for (int i = 0; i < [arrName count]; i++)
     {
        UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, iCellHeight)];
        [self.view addSubview:viewCell];
        viewCell.tag = i;
        viewCell.backgroundColor = [UIColor whiteColor];
        
        int iCellTopY = 20;
        int iCellLeftX = 15;
        
        UIImageView *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY+5, 30, 30)];
        [viewCell addSubview:imgLeft];
        imgLeft.image = [UIImage imageNamed:arrImg[i]];
        
        iCellLeftX += imgLeft.width + 10;
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, 200, 20)];
        [viewCell addSubview:label1];
        label1.textColor = [ResourceManager color_1];
        label1.font = [UIFont systemFontOfSize:16];
        label1.text = arrName[i];
        
        iCellTopY += label1.height+ 10;
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, SCREEN_WIDTH - iCellLeftX - 30, 12)];
        [viewCell addSubview:label2];
        label2.textColor = [ResourceManager midGrayColor];
        label2.font = [UIFont systemFontOfSize:11];
        label2.text = arrSubTitle[i];
        
        UIImageView *imgRight = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20, (iCellHeight - 19*ScaleSize)/2, 11*ScaleSize, 19*ScaleSize)];
        [viewCell addSubview:imgRight];
        imgRight.image = [UIImage imageNamed:@"arrow_right"];
        
        if (i == 0)
         {
            UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, iCellHeight-1, SCREEN_WIDTH, 1)];
            [viewCell addSubview:viewFG];
            viewFG.backgroundColor = [ResourceManager color_5];
         }
        
        
        //添加手势点击空白处隐藏键盘
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionView:)];
        gesture.numberOfTapsRequired  = 1;
        viewCell.userInteractionEnabled = YES;
        [viewCell addGestureRecognizer:gesture];
        
        iTopY += iCellHeight;
     }
    
}

#pragma mark --- action
-(void) actionView:(UITapGestureRecognizer*) reg
{
    int iTag = (int)reg.view.tag;
    NSLog(@"actionView :%d ",iTag);
    
    if (0 == iTag)
     {
        //  退款退货
        RefundRequstSecond  *VC = [[RefundRequstSecond alloc] init];
        VC.dicParams = [[NSDictionary alloc] init];
        VC.dicParams =  _dicParams;
        VC.iCommitType = 2;
        [self.navigationController pushViewController:VC animated:YES];
     }
    else if (1 == iTag)
     {
        // 退款
        RefundRequstSecond  *VC = [[RefundRequstSecond alloc] init];
        VC.dicParams = [[NSDictionary alloc] init];
        VC.dicParams =  _dicParams;
        VC.iCommitType = 1;
        [self.navigationController pushViewController:VC animated:YES];
     }
}

@end
