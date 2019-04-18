//
//  RefundScheduleVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/9.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "RefundScheduleVC.h"

@interface RefundScheduleVC ()
{
    UIScrollView *scView;
}
@end

@implementation RefundScheduleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"售后进度"];
    
    [self getUIDataFromWeb];
}

-(void) layoutUI:(NSArray*) arrUI
{
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 500);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [ResourceManager viewBackgroundColor];
    
    
    UIView *lineLeft = [[UIView alloc] initWithFrame:CGRectMake(25, 0, 1, SCREEN_HEIGHT)];
    [scView addSubview:lineLeft];
    lineLeft.backgroundColor = [ResourceManager lightGrayColor];
    
    int iTopY = 15;
    int iLeftX = lineLeft.left + 20;
    for (int i = 0; i < arrUI.count; i++)
     {
        NSDictionary *dic = arrUI[i];
        
        UIImageView  *imgLeft = [[UIImageView alloc] initWithFrame:CGRectMake(20, iTopY + 10, 10, 10)];
        [scView addSubview:imgLeft];
        imgLeft.image = [UIImage imageNamed:@"Refund_unsel_yuan"];
        
        if (0 == i)
         {
            imgLeft.frame = CGRectMake(18, iTopY + 10, 15, 15);
            imgLeft.image = [UIImage imageNamed:@"Refund_sel_yuan"];
         }
        
        UIView *viewTemp = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - iLeftX - 15, 100)];
        [scView addSubview:viewTemp];
        viewTemp.backgroundColor = [UIColor whiteColor];
        
        int iCellTopY = 15;
        int iCellLeftX = 15;
        int iCellWidth = viewTemp.width - iCellLeftX - 5;
        UILabel *labelTime = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, iCellWidth, 15)];
        [viewTemp addSubview:labelTime];
        labelTime.textColor = [ResourceManager midGrayColor];
        labelTime.font = [UIFont systemFontOfSize:12];
        labelTime.text = dic[@"createTime"];
        
        iCellTopY += labelTime.height + 10;
        
        NSString *statusDesc = dic[@"statusDesc"];
        if ([statusDesc isKindOfClass:[NSString class]] &&
            statusDesc.length > 0)
         {
            UILabel *labe1 = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, iCellWidth, 15)];
            [viewTemp addSubview:labe1];
            labe1.textColor = [ResourceManager mainColor];
            labe1.font = [UIFont systemFontOfSize:13];
            labe1.text = dic[@"statusDesc"];
            
            iCellTopY += labe1.height + 5;
         }
        
        UILabel *labe2 = [[UILabel alloc] initWithFrame:CGRectMake(iCellLeftX, iCellTopY, iCellWidth, 45)];
        [viewTemp addSubview:labe2];
        labe2.textColor = [ResourceManager color_1];
        labe2.font = [UIFont systemFontOfSize:13];
        labe2.numberOfLines = 0;
        labe2.text = dic[@"saleDesc"];
        [labe2 sizeToFit];
        
        iCellTopY += labe2.height+10;
        viewTemp.height = iCellTopY;

        
        iTopY +=viewTemp.height + 15;
        
     }
    
    if (iTopY > lineLeft.height)
     {
        lineLeft.height = iTopY;
     }
    scView.contentSize = CGSizeMake(0, iTopY);
    
    
    
}

#pragma mark  ---  网络请求
-(void)getUIDataFromWeb{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"refundNo"] = _dicParams[@"refundNo"];
    //params[@"subOrderNo"] = _dicParams[@"subOrderNo"];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kURLquerySaleSchedule];
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


-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    if (1000 == operation.tag)
     {
        NSArray* arrUI = operation.jsonResult.rows;
        if ([arrUI isKindOfClass:[NSArray class] ] &&
            arrUI.count > 0)
         {
            [self layoutUI:arrUI];
         }
     }
    
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}

@end
