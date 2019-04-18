//
//  ShopMoreAtTimeVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/27.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "ShopMoreAtTimeVC.h"
#import "HistorySearchVC.h"
#import "SortProductCollectionViewCell.h"
#import "HeaderCollectionReusableView.h"
#import "ShopDetailVC.h"

#define  CollectionView  @"HeaderCollectionReusableView"

@interface ShopMoreAtTimeVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *arrHeadName;
    NSMutableArray *arrDate;  // 每个日期下面的数据
    
    NSDictionary *dicPlace;  // 占位字典
}
@property(nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableDictionary *cellDic;

@end


@implementation ShopMoreAtTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CustomNavigationBarView *naviView = [self layoutNaviBarViewWithTitle:_strTypeName];
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 45,NavHeight - 39, 31, 33)];
    [naviView addSubview:searchBtn];
    [searchBtn setImage:[UIImage imageNamed:@"Tab1_Search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchProduct) forControlEvents:UIControlEventTouchUpInside];
    
    [self initData];
    
    [self layoutUI];
}

-(void)  initData
{
    
    arrHeadName = [[NSMutableArray alloc] init];
    arrDate = [[NSMutableArray alloc] init];
    
    dicPlace = [[NSDictionary alloc] init];
    
    _cellDic = [[NSMutableDictionary alloc] init];
}

#pragma mark --- 布局UI
-(void)layoutUI{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //以xib方式注册cell
    [_collectionView registerNib:[UINib nibWithNibName:@"SortProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SortProductCell_ID"];
    
    [_collectionView registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CollectionView];

    
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
}

#pragma mark  ---  action
-(void) searchProduct
{
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
    
    //[self.navigationController presentViewController:searShopVC animated:nil completion:nil];
    [self.navigationController pushViewController:searShopVC animated:YES];
}

#pragma mark 网络请求
-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"typeCode"] = _strTypeCode;
    params[@"cateCode"] = _strTypeCode;
    
    NSString *strURL = [NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],kURLqueryTypeMoreInfoList];
    if (_isGoodType)
     {
        strURL = [NSString stringWithFormat:@"%@appMall/goods/queryGoodsList",[PDAPI getBaseUrlString]];
     }
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strURL
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
}


-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [_collectionView.mj_header endRefreshing];
    //[self.dataArray removeAllObjects];
    //[self.dataArray addObjectsFromArray:operation.jsonResult.rows];
    NSArray *arrTemp = operation.jsonResult.rows;
    if (arrTemp )
     {
        [arrDate removeAllObjects];
        [arrHeadName removeAllObjects];
        for (int i = 0; i < [arrTemp count]; i++)
         {
            NSDictionary *dicTemp = arrTemp[i];
            if (dicTemp[@"onSaleDate"])
             {
                [arrHeadName addObject:dicTemp[@"onSaleDate"]];
             }
            if (dicTemp[@"saleList"])
             {
                [arrDate addObject:dicTemp[@"saleList"]];
             }
         }
     }
    
    [_collectionView reloadData];
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [_collectionView.mj_header endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}


#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //return self.dataArray.count;
    if (section < [arrDate count] )
     {
        return [arrDate[section] count];
     }
    return 0;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return   [arrHeadName count]; //3;  // 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //SortProductCollectionViewCell *cell = (SortProductCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SortProductCell_ID" forIndexPath:indexPath];
    
    // 防止复用时出问题
    // 每次先从字典中根据IndexPath取出唯一标识符
    NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"%@%@", @"ShoMoreAtTimeVC", [NSString stringWithFormat:@"%@", indexPath]];
        [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        
        //以xib方式注册cell
        [_collectionView registerNib:[UINib nibWithNibName:@"SortProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    }
    
    SortProductCollectionViewCell *cell = (SortProductCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    
    cell.dataDicionary = dicPlace;//self.dataArray[indexPath.row];
    if (indexPath.section < [arrDate count])
     {
        NSArray *arrTemp = arrDate[indexPath.section];
        
        if (indexPath.row < [arrTemp count])
         {
            cell.dataDicionary = arrTemp[indexPath.row];
         }
     }
    
   
    return cell;
}


#pragma mark --- Header的大小 size

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(SCREEN_WIDTH, 50);
    
    
}

#pragma mark --- 自定义分区头

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
     {
        HeaderCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CollectionView forIndexPath:indexPath];
        
        [headerView setSHCollectionReusableViewHearderTitle:arrHeadName[indexPath.section]];
        
        headerView.backgroundColor = [UIColor clearColor];
        
        reusableview = headerView;
        
     }
    return reusableview;
}


#pragma mark- FlowDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //return CGSizeMake(SCREEN_WIDTH/2, 230 * ScaleSize);
    return CGSizeMake(SCREEN_WIDTH/2, SCREEN_WIDTH/2 + 50);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//返回这个UICollectioncell是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    
    NSDictionary *dicSel = [[NSDictionary alloc] init];
    if (indexPath.section < [arrDate count])
     {
        NSArray *arrTemp = arrDate[indexPath.section];
        
        if (indexPath.row < [arrTemp count])
         {
            dicSel = arrTemp[indexPath.row];
         }
     }
    
    
    NSString *goodsCode = [NSString stringWithFormat:@"%@",[dicSel objectForKey:@"goodsCode"]];
    if (goodsCode.length > 0) {
        [self.view endEditing:YES];
        
        ShopDetailVC *VC  = [[ShopDetailVC alloc] init];
        VC.shopModel = [[ShopModel alloc] init];
        VC.shopModel.strGoodsCode = goodsCode;
        if (_isGoodType)
         {
            VC.est = @"category";
            VC.esi = _strTypeCode;
         }
        else
         {
            VC.est = @"showType";
            VC.esi = _strTypeCode;
         }
        [self.navigationController pushViewController:VC animated:YES];
        
    }
}


@end
