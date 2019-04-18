//
//  BrandProductViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/3/22.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "BrandProductViewController.h"

#import "ProductListViewController.h"
#import "HistorySearchVC.h"


@interface BrandProductViewController ()

@end

@implementation BrandProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CustomNavigationBarView *naviView = [self layoutNaviBarViewWithTitle:self.titleStr];
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 45,NavHeight - 39, 31, 33)];
    [naviView addSubview:searchBtn];
    [searchBtn setImage:[UIImage imageNamed:@"Tab1_Search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchProduct) forControlEvents:UIControlEventTouchUpInside];
    
    [self layoutUI];
}

-(void)layoutUI{
    
   
}


#pragma mark- 顶部搜索框触发事件
-(void)searchProduct{
    
    HistorySearchVC *searShopVC = [HistorySearchVC alloc];
    //(1)点击分类 (2)用户点击键盘"搜索"按钮  (3)点击历史搜索记录
    [searShopVC beginSearch:^(NaviBarSearchType searchType,NBSSearchShopCategoryViewCellP *categorytagP,UILabel *historyTagLabel,LLSearchBar *searchBar) {
        NSLog(@"historyTagLabel:%@--->searchBar:%@--->categotyTitle:%@--->%@",historyTagLabel.text,searchBar.text,categorytagP.categotyTitle,categorytagP.categotyID);
        searShopVC.searchBarText = @"你选择的搜索内容显示到这里";
    }];
    
    //点击了即时匹配选项
    [searShopVC resultListViewDidSelectedIndex:^(UITableView *tableView, NSInteger index) {
        NSLog(@"点击了即时搜索内容第%zd行的%@数据",index,searShopVC.resultListArray[index]);
    }];
    
    //执行即时搜索匹配
    NSArray *tempArray = @[@"Java", @"Python"];
    [searShopVC searchbarDidChange:^(NaviBarSearchType searchType, LLSearchBar *searchBar, NSString *searchText) {
        //FIXME:这里模拟网络请求数据!!!
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            searShopVC.resultListArray = tempArray;
        });
    }];
    
    [self.navigationController pushViewController:searShopVC animated:YES];
    
}
@end
