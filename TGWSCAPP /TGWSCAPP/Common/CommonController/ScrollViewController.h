//
//  ScrollViewController.h
//  DDGAPP
//
//  Created by ddgbank on 15/11/11.
//  Copyright © 2015年 Cary. All rights reserved.
//

#import "CommonViewController.h"
#import "RefreshTableView.h"

#define MENU_HEIGHT 34.0
//#define MENU_BUTTON_WIDTH 107

#define MIN_MENU_FONT  12.f
#define MAX_MENU_FONT  14.f

@interface ScrollViewController : CommonViewController<UIScrollViewDelegate,RefreshTableViewDelegate,RefreshTableViewDataSource>
{
    UIScrollView *_navScrollView;
}

@property (nonatomic,strong) UIScrollView *navScrollView;

@property (nonatomic,strong) UIScrollView *contentScrollView;

@property (nonatomic,strong) NSArray *titleArray;

-(void)layoutScrollView;
/*
 *  子类必须实现
 */
-(void)layoutContentViews;

- (void)actionbtn:(UIButton *)btn;


@end
