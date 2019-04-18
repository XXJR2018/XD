//
//  UIViewController+DDGExtras.m
//  ddgBank
//
//  Created by Cary on 14/12/30.
//  Copyright (c) 2014年 com.ddg. All rights reserved.
//

#import "UIViewController+DDGExtras.h"


@implementation UIViewController (DDGExtras)

#pragma mark ==== customBarButton
- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showOptionCtl{

}

#pragma mark ==== customBarButton
-(UIBarButtonItem *)customLeftBarButton{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"return"] style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    return item;
}

-(UIBarButtonItem *)customRightBarButton{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]  initWithImage:[UIImage imageNamed:@"option"] style:UIBarButtonItemStylePlain target:self action:@selector(showOptionCtl)];
    return item;
}


- (void)handleApplicationDidBecomeActiveNotification:(NSNotification *)notification
{
    [self.view endEditing:YES];
}


@end
