//
//  SelCouponVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/5.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "SelCouponVC.h"

@interface SelCouponVC ()
{
    UIScrollView *scView;
    
    UIButton *btnUnse;
    
    NSMutableArray *arrBtn;
}
@end

#define    CheckImg         @"od_gou2"
#define    UnCheckImg       @"od_gou1"

@implementation SelCouponVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"选择券"];
    
    [self initData];
    
    [self layoutUI];
}

-(void) initData
{
    arrBtn = [[NSMutableArray alloc] init];
}

#pragma mark  ---  布局UI
-(void) layoutUI
{
    UIView *viewHead = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, 40)];
    [self.view addSubview:viewHead];
    viewHead.backgroundColor = [UIColor whiteColor];
    
    int iTopY = 10;
    int iLeftX = 15;
    UILabel *labelUnuse  = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, 20)];
    [viewHead addSubview:labelUnuse];
    labelUnuse.textColor = [ResourceManager color_1];
    labelUnuse.font = [UIFont systemFontOfSize:14];
    labelUnuse.text = @"不使用券";
    
    btnUnse = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 45, iTopY+5, 18, 18)];
    [viewHead addSubview:btnUnse];
    [btnUnse setImage:[UIImage imageNamed:UnCheckImg] forState:UIControlStateNormal];
    [btnUnse setImage:[UIImage imageNamed:CheckImg] forState:UIControlStateSelected];
    btnUnse.selected = NO;
    btnUnse.userInteractionEnabled = NO;
    
    
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionUnuse)];
    gesture.numberOfTapsRequired  = 1;
    [viewHead addGestureRecognizer:gesture];
    
    iTopY = NavHeight + viewHead.height;
    scView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, SCREEN_HEIGHT - iTopY)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 1000);
    
    iTopY = 10;
    iLeftX = 10;
    int iCellHeight = 90;
    for (int i = 0; i < [_arrCoupon count ]; i ++)
     {
        NSDictionary *_dataDicionary = _arrCoupon[i];
        iLeftX = 10;

        UIImageView* imgCellBG = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH-2*iLeftX, iCellHeight)];
        [scView addSubview:imgCellBG];
        imgCellBG.userInteractionEnabled = YES;
        imgCellBG.image = [UIImage imageNamed:@"od_quan"];
        imgCellBG.tag = i;
        
        
        UIButton *btnUse = [[UIButton alloc] initWithFrame:CGRectMake(imgCellBG.width - 35, 20, 18, 18)];
        [imgCellBG addSubview:btnUse];
        [btnUse setImage:[UIImage imageNamed:UnCheckImg] forState:UIControlStateNormal];
        [btnUse setImage:[UIImage imageNamed:CheckImg] forState:UIControlStateSelected];
        btnUse.selected = NO;
        btnUse.userInteractionEnabled = NO;
        
        [arrBtn addObject:btnUse];
        
        
        NSString* curCustPromocardId = [NSString stringWithFormat:@"%@",_dataDicionary[@"custPromocardId"]];
        if ([curCustPromocardId isEqualToString:_custPromocardId])
         {
            btnUse.selected =YES;
         }
        
        int iCellTopY = 15;
        UILabel *labelPrice  = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iCellTopY, 100, 40)];
        [imgCellBG addSubview:labelPrice];
        //labelPrice.backgroundColor = [UIColor blueColor];
        labelPrice.textColor = [ResourceManager mainColor];
        labelPrice.textAlignment = NSTextAlignmentCenter;
        
        NSString *titleStr = [NSString stringWithFormat:@"%@元",[_dataDicionary objectForKey:@"promocardValue"]];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]
                                              initWithString:titleStr];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:40] range:NSMakeRange(0, titleStr.length - 1)];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(titleStr.length - 1, 1)];
        labelPrice.attributedText = attrStr;
        
        
        iLeftX += labelPrice.width + 30;
        iCellTopY = 15;
        UILabel *lablelUse = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iCellTopY, imgCellBG.width - iLeftX-10, 20)];
        [imgCellBG addSubview:lablelUse];
        lablelUse.font = [UIFont systemFontOfSize:12];
        lablelUse.textColor = [ResourceManager color_1];
        lablelUse.text = [_dataDicionary objectForKey:@"useDesc"]?[_dataDicionary objectForKey:@"useDesc"]: @"全场通用";
        
        iCellTopY += lablelUse.height;
        UILabel *lablelAtLeast = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iCellTopY, imgCellBG.width - iLeftX-10, 10)];
        [imgCellBG addSubview:lablelAtLeast];
        lablelAtLeast.font = [UIFont systemFontOfSize:10];
        lablelAtLeast.textColor = [ResourceManager midGrayColor];
        NSString *useRemark = _dataDicionary[@"useRemark"];
        lablelAtLeast.text = useRemark?useRemark:@"";
        
        
        iCellTopY += lablelAtLeast.height+15;
        iLeftX = 10;
        UILabel *labelStatu  = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iCellTopY, 100, 12)];
        [imgCellBG addSubview:labelStatu];
        labelStatu.textColor = [ResourceManager priceColor];
        labelStatu.font = [UIFont systemFontOfSize:11];
        labelStatu.textAlignment = NSTextAlignmentCenter;
        labelStatu.text =  [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"desc"]];
        
        iLeftX += labelPrice.width + 30;
        UILabel *lablelvalidTlme = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iCellTopY, imgCellBG.width - iLeftX-10, 10)];
        [imgCellBG addSubview:lablelvalidTlme];
        lablelvalidTlme.font = [UIFont systemFontOfSize:10];
        lablelvalidTlme.textColor = [ResourceManager midGrayColor];
        lablelvalidTlme.text = [NSString stringWithFormat:@"有效期%@-%@",[_dataDicionary objectForKey:@"validStartDate"],[_dataDicionary objectForKey:@"validEndDate"]];;
        

        
        UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionUse:)];
        gesture.numberOfTapsRequired  = 1;
        [imgCellBG addGestureRecognizer:gesture];
        
        
        iTopY += iCellHeight+10;
     }
    
    
    scView.contentSize = CGSizeMake(0, iTopY);
    
    
}
-(void) AllUnCheck
{
    btnUnse.selected = NO;
    for (int i= 0; i < [arrBtn count]; i++)
     {
        UIButton *btnTemp = arrBtn[i];
        btnTemp.selected = NO;
     }
}


#pragma mark ---  action
-(void) actionUnuse
{
    
    [self AllUnCheck];
    btnUnse.selected = YES;
    
    if(_sel_bolck)
     {
        _sel_bolck(nil);
     }
    
    [self.navigationController popViewControllerAnimated:YES];
    //[self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];// 延迟执行

    
}

-(void) actionUse:(UITapGestureRecognizer*) reg
{
    [self AllUnCheck];
    
    int iTag = (int)reg.view.tag;
    if (iTag < [_arrCoupon count])
     {
        UIButton *btnTemp = arrBtn[iTag];
        btnTemp.selected = YES;
        
        NSDictionary *dicObj = _arrCoupon[iTag];
        
        
        if(_sel_bolck)
         {
            _sel_bolck(dicObj);
         }
     }
    
    
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
    //[self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.1];// 延迟执行
    
}

-(void) delayMethod
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
