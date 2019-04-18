//
//  TabViewController_2.m
//  XXJR
//
//  Created by xxjr03 on 2018/9/4.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "TabViewController_2.h"

#import "ProductCollectionViewCell.h"
#import "HistorySearchVC.h"
#import "MenuViewController.h"
#import "ProductListViewController.h"
#import "BrandListViewController.h"

#define  leftListWidth   80
#define  rightListWidth  [UIScreen mainScreen].bounds.size.width - 80

@interface TabViewController_2 ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    UIScrollView *_scView;
    UIButton *_sortFirstBtn;
    UIView *_sortFristView;
    NSMutableArray *_sortFirstBtnArr;
    
    UITableView *_tableView;
    UICollectionView *_collectView;
    NSInteger cellCount;   //当前的cell是第几个
    
    NSString *_leftMenuStr;
    NSString *_cateCode;
    NSInteger _cateId;
    
}
@end

@implementation TabViewController_2

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/category/queryCateList",[PDAPI getBaseUrlString]]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
    operation.tag = 1000;
}

-(void)CateListUrl{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_cateCode.length > 0 && _cateId > 0) {
        params[@"cateCode"] = _cateCode;
    }
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/category/queryMinCateList",[PDAPI getBaseUrlString]]
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
    if (operation.tag == 1000) {
        if (operation.jsonResult.rows.count > 0) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:operation.jsonResult.rows];
            [self scViewUI];
            [_tableView reloadData];
        }
    }else if (operation.tag == 1001) {
        MenuViewController *ctl = [[MenuViewController alloc]init];
        ctl.sortDataArr = operation.jsonResult.rows;
        ctl.titleStr = _leftMenuStr;
        ctl.cateId = _cateId;
        [self.navigationController pushViewController:ctl animated:YES];
    }
    
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"分类"];
    //没有数据时切换页面重新请求接口
    if (self.dataArray.count == 0) {
        [self loadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"分类"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    _sortFirstBtnArr = [NSMutableArray array];
    
    [self searchViewUI];
    [self layoutUI];
    
}

#pragma mark- 顶部搜索功能
-(void)searchViewUI{
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(15 , StatusBarHeight + 5, SCREEN_WIDTH - 30, NavHeight - StatusBarHeight - 10)];
    [self.view addSubview:searchView];
    searchView.cornerRadius = 5;
    searchView.backgroundColor = [ResourceManager viewBackgroundColor];
    
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 170, searchView.frame.size.height)];
    [searchView addSubview:searchBtn];
    [searchBtn setTitle:@"百里挑一的好商品" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [searchBtn setImage:[UIImage imageNamed:@"Tab1_Search"] forState:UIControlStateNormal];
    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    searchBtn.userInteractionEnabled = NO;
    
    UITapGestureRecognizer * gestureSearch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(searchTouch)];
    gestureSearch.numberOfTapsRequired  = 1;
    [searchView addGestureRecognizer:gestureSearch];
    
    UIView *viewX = [[UIView alloc] initWithFrame:CGRectMake(0 , NavHeight - 0.5, SCREEN_WIDTH, 0.5)];
    [self.view addSubview:viewX];
    viewX.backgroundColor = [ResourceManager color_5];
}

-(void)scViewUI{
    [_scView removeFromSuperview];
    [_sortFirstBtnArr removeAllObjects];
    _scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavHeight, leftListWidth, SCREEN_HEIGHT - NavHeight - TabbarHeight)];
    [self.view addSubview:_scView];
    _scView.backgroundColor = [UIColor whiteColor];
    _scView.bounces = NO;
    _scView.pagingEnabled = NO;
    _scView.showsVerticalScrollIndicator = NO;
    
    UIView *viewX = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_scView.frame) - 0.5, 0, 0.5, CGRectGetMaxY(_scView.frame))];
    [_scView addSubview:viewX];
    viewX.backgroundColor = [ResourceManager color_5];
    
    for (int i = 0; i < self.dataArray.count; i ++) {
        NSDictionary *dic = self.dataArray[i];
        _sortFirstBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 50 * i, leftListWidth, 50)];
        [_scView addSubview:_sortFirstBtn];
        _sortFirstBtn.tag = i;
        
        NSString *title = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cateName"]];
        [_sortFirstBtn setTitle:title forState:UIControlStateNormal];
        [_sortFirstBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        [_sortFirstBtn setTitleColor:[ResourceManager mainColor] forState:UIControlStateSelected];
        _sortFirstBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sortFirstBtn addTarget:self action:@selector(sortFirstTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        [_sortFirstBtnArr addObject:_sortFirstBtn];
    }
    
    _scView.contentSize =CGSizeMake(0, CGRectGetMaxY(_sortFirstBtn.frame) + 10);
    ((UIButton *)_sortFirstBtnArr[0]).selected = YES;
    _sortFristView = [[UIView alloc]initWithFrame:CGRectMake(0, (50 - 20)/2, 2, 20)];
    [_scView addSubview:_sortFristView];
    _sortFristView.backgroundColor = [ResourceManager mainColor];
    NSDictionary *dic = self.dataArray[0];
    _leftMenuStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cateName"]];
    _cateCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cateCode"]];
    NSLog(@"cateCode = %@",_cateCode);
}

#pragma mark-一级菜单点击事件
-(void)sortFirstTouch:(UIButton *)sender{
    if (sender.selected) {
        return;
    }
    ((UIButton *)_sortFirstBtnArr[0]).selected = NO;
    if (sender != _sortFirstBtn) {
        _sortFirstBtn.selected = NO;
        _sortFirstBtn = sender;
    }
    _sortFirstBtn.selected = YES;
    _sortFristView.frame = CGRectMake(0, (50 - 20)/2 + (sender.tag) * 50, 2, 20);
    [_tableView reloadData];
    /* 滚动指定段的指定row  到 指定位置*/
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    cellCount = sender.tag;
    NSDictionary *dic = self.dataArray[cellCount];
    _leftMenuStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cateName"]];
    _cateCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"cateCode"]];
    NSLog(@"cateCode = %@",_cateCode);
}

#pragma mark- 顶部搜索框触发事件
-(void)searchTouch{
    
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

#pragma mark- 右边商品列表布局
-(void)layoutUI{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(leftListWidth, NavHeight, rightListWidth, SCREEN_HEIGHT - TabbarHeight - NavHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    [_tableView setTableFooterView:[UIView new]];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, -20, 0, 0)];
    [_tableView setSeparatorColor:[UIColor clearColor]];
    
    //初始化加载显示第0个cell
    cellCount = 0;
}

-(void)collectionViewUI{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = (SCREEN_WIDTH - 100 - 210 * ScaleSize)/6;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, rightListWidth, SCREEN_HEIGHT - NavHeight - TabbarHeight) collectionViewLayout:flowLayout];
    _collectView.backgroundColor = [UIColor whiteColor];
    _collectView.delegate = self;
    _collectView.dataSource = self;

    //以xib方式注册cell
    [_collectView registerNib:[UINib nibWithNibName:@"ProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ProductCell_ID"];
    //注册头视图，相当于段头
    [_collectView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
    
//    _collectView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self pullDown];
//    }];
    //设置特殊样式的下拉刷新控件
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(pullDown)];
    // 设置菊花样式颜色
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    // 设置提示文字颜色
    header.stateLabel.textColor = [UIColor clearColor];
    // 隐藏上次刷新时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置header
    _collectView.mj_header = header;
    
//    _collectView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [self SlideUp];
//    }];
    //设置特殊样式的上拉加载控件
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(SlideUp)];
    // 设置菊花样式颜色
    footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    // 设置提示文字颜色
    footer.stateLabel.textColor = [UIColor clearColor];
    // 设置footer
    _collectView.mj_footer = footer;
    
}

#pragma mark === UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  SCREEN_HEIGHT - NavHeight - TabbarHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = [NSString stringWithFormat:@"%ld_cell",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
  
    [cell.contentView removeAllSubviews];
    [self collectionViewUI];
    [cell.contentView addSubview:_collectView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //（这种是没有点击后的阴影效果)
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}


#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSDictionary *firstDataDic = self.dataArray[cellCount];
    NSArray *secondDataArr = [firstDataDic objectForKey:@"subCate"];
    if ([[firstDataDic objectForKey:@"havSubCount"] intValue] == 2) {
        NSDictionary *dic = secondDataArr[section];
        NSArray *arr = [dic objectForKey:@"subCate"];
        return  arr.count;
    }else{
        return secondDataArr.count;
    }
    
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    NSDictionary *firstDataDic = self.dataArray[cellCount];
    NSArray *secondDataArr = [firstDataDic objectForKey:@"subCate"];
    if ([[firstDataDic objectForKey:@"havSubCount"] intValue] == 2) {
        return secondDataArr.count;
    }else{
        return  1;
    }
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        //防止段头下拉复用显示bug
        for (UIView *view in header.subviews) {
            [view removeFromSuperview];
        }
        
        NSDictionary *firstDataDic = self.dataArray[cellCount];
        NSArray *secondDataArr = [firstDataDic objectForKey:@"subCate"];
        if ([[firstDataDic objectForKey:@"havSubCount"] intValue] == 2) {
            NSDictionary *thirdDic = secondDataArr[indexPath.section];
             //三级菜单头视图
            if (indexPath.section == 0) {
                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, rightListWidth - 29, 90 * ScaleSize)];
                [header addSubview:imgView];
                imgView.backgroundColor = UIColorFromRGB(0xf6f6f6);
                [imgView sd_setImageWithURL:[NSURL URLWithString:[firstDataDic objectForKey:@"imgUrl"]]];
                
                UILabel*titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(imgView.frame) + 10, 150, 30)];
                titleLabel.text = [NSString stringWithFormat:@"%@",[thirdDic objectForKey:@"cateName"]];
                titleLabel.font= [UIFont boldSystemFontOfSize:15];
                titleLabel.textColor = [ResourceManager color_1];
                [header addSubview:titleLabel];
                
                UIView *viewX = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame) - 0.5, rightListWidth - 29, 0.5)];
                [header addSubview:viewX];
                viewX.backgroundColor = [ResourceManager color_5];
            }else{
                UILabel*titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 150, 30)];
                titleLabel.text = [NSString stringWithFormat:@"%@",[thirdDic objectForKey:@"cateName"]];;
                titleLabel.font= [UIFont boldSystemFontOfSize:15];
                titleLabel.textColor = [ResourceManager color_1];
                [header addSubview:titleLabel];
                
                UIView *viewX = [[UIView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame) - 0.5, rightListWidth - 29, 0.5)];
                [header addSubview:viewX];
                viewX.backgroundColor = [ResourceManager color_5];
            }
        }else{
            //二级菜单头视图
            if ([firstDataDic objectForKey:@"imgUrl"]) {
                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, rightListWidth - 29, 90 * ScaleSize)];
                [header addSubview:imgView];
                imgView.backgroundColor = UIColorFromRGB(0xf6f6f6);
                [imgView sd_setImageWithURL:[NSURL URLWithString:[firstDataDic objectForKey:@"imgUrl"]]];
            }
        }
        return header;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeZero;
    NSDictionary *firstDataDic = self.dataArray[cellCount];
    if ([[firstDataDic objectForKey:@"havSubCount"] intValue] == 2) {
        if (section == 0) {
            size = CGSizeMake(rightListWidth, 90 * ScaleSize + 55);
        }else{
            size = CGSizeMake(rightListWidth, 30);
        }
    }else{
        if ([firstDataDic objectForKey:@"imgUrl"]) {
            size = CGSizeMake(rightListWidth, 90 * ScaleSize + 20);
        }
    }
    
    return size;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ProductCollectionViewCell * cell;
    cell = (ProductCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ProductCell_ID" forIndexPath:indexPath];
    
    NSDictionary *firstDataDic = self.dataArray[cellCount];
    NSArray *secondDataArr = [firstDataDic objectForKey:@"subCate"];
    if ([[firstDataDic objectForKey:@"havSubCount"] intValue] == 2) {
        NSDictionary *thirdDic = secondDataArr[indexPath.section];
        NSArray *arr = [thirdDic objectForKey:@"subCate"];
        cell.dataDicionary = arr[indexPath.row];
    }else{
        NSDictionary *dic = secondDataArr[indexPath.row];
        cell.dataDicionary = dic;
    }
    
    return cell;
    
}

#pragma mark- FlowDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(60, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if ([_leftMenuStr isEqualToString:@"品牌专区"] || [_leftMenuStr isEqualToString:@"品牌"]) {
        return UIEdgeInsetsMake(10, (SCREEN_WIDTH - 100 - 60 * 4)/8, 5, (SCREEN_WIDTH - 100 - 60 * 4)/8);
    }
    return UIEdgeInsetsMake(10, (SCREEN_WIDTH - 100 - 60 * 3)/6, 5, (SCREEN_WIDTH - 100 - 60 * 3)/6);
}

//返回这个UICollectioncell是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ProductCollectionViewCell * cell = (ProductCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    NSDictionary *selectDataDic;
    NSDictionary *firstDataDic = self.dataArray[cellCount];
    NSArray *secondDataArr = [firstDataDic objectForKey:@"subCate"];
    if ([[firstDataDic objectForKey:@"havSubCount"] intValue] == 2) {
        NSDictionary *thirdDic = secondDataArr[indexPath.section];
        NSArray *arr = [thirdDic objectForKey:@"subCate"];
        selectDataDic = arr[indexPath.row];
    }else{
        selectDataDic = secondDataArr[indexPath.row];
    }
    
    _cateId = [[selectDataDic objectForKey:@"cateId"] intValue];
    if ([[selectDataDic objectForKey:@"brandFlag"] intValue] == 1) {
        BrandListViewController *ctl = [[BrandListViewController alloc]init];
        ctl.titleStr = [NSString stringWithFormat:@"%@",[selectDataDic objectForKey:@"cateName"]];
        ctl.cateCode = [NSString stringWithFormat:@"%@",[selectDataDic objectForKey:@"cateCode"]];
        [self.navigationController pushViewController:ctl animated:YES];
    }else{
       [self CateListUrl];
    }
   
}


#pragma mark-上下滑动collectView跳至相应cell
-(void)pullDown{
     [_collectView.mj_header endRefreshing]; // 结束刷新
    if (cellCount > 0) {
        NSLog(@"跳到上一个cell");
        cellCount = cellCount - 1;
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:cellCount inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self sortFirstTouch:_sortFirstBtnArr[cellCount]];
    }else{
        [self loadData];
    }
}

-(void)SlideUp{
     [_collectView.mj_footer endRefreshing]; // 结束刷新
    if (cellCount < self.dataArray.count - 1) {
        NSLog(@"跳到下一个cell");
        cellCount = cellCount + 1;
        [self sortFirstTouch:_sortFirstBtnArr[cellCount]];
    }
}



-(void)addButtonView{
    [self.view addSubview:self.tabBar];
}




@end
