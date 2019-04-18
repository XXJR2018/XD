//
//  MenuViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/21.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "MenuViewController.h"

#import "ProductListViewController.h"
#import "LSPPageView.h"
#import "HistorySearchVC.h"


@interface MenuViewController ()<LSPPageViewDelegate>

@end

@implementation MenuViewController

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
    
    NSMutableArray *titleArray = [NSMutableArray array];
    for (NSDictionary *dic in self.sortDataArr) {
        [titleArray addObject:[dic objectForKey:@"cateName"]];
    }

    NSMutableArray *childVcArray = [NSMutableArray array];
    for (int i = 0; i < self.sortDataArr.count; i++) {
        ProductListViewController *ctl = [[ProductListViewController alloc] init];
        NSDictionary *dic = self.sortDataArr[i];
        ctl.cateCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cateCode"]];
        [childVcArray addObject:ctl];
    }
    LSPPageView *pageView = [[LSPPageView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight) titles:titleArray.mutableCopy style:nil childVcs:childVcArray.mutableCopy parentVc:self];
    pageView.delegate = self;
    pageView.backgroundColor = [ResourceManager viewBackgroundColor];
    [self.view addSubview:pageView];

    NSInteger count = 0;
    for (NSDictionary *dic in self.sortDataArr) {
        if ([[dic objectForKey:@"cateId"] intValue] == self.cateId) {
             [pageView setToIndex:count];
        }
        count ++;
    }
    
}

#pragma mark - LSPPageViewDelegate
- (void)pageViewScollEndView:(LSPPageView *)pageView WithIndex:(NSInteger)index{
    NSLog(@"第%zd个",index);
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
