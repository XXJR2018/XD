//
//  ProductListViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/20.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "ProductListViewController.h"

#import "SortProductCollectionViewCell.h"
#import "ShopDetailVC.h"

@interface ProductListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UIButton *_sortBtn;
    NSMutableArray *_sortBtnArr;
    UIView *_sortViewX;
}

@property(nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableDictionary *cellDic;



@end


@implementation ProductListViewController

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"cateCode"] = self.cateCode;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/goods/queryGoodsList",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
}

#pragma mark 数据操作
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [_collectionView.mj_header endRefreshing];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:operation.jsonResult.rows];
    [_collectionView reloadData];
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [_collectionView.mj_header endRefreshing];
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"分类列表点击"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"分类列表点击"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cellDic = [[NSMutableDictionary alloc] init];
    [self layoutUI];
   
}

-(void)layoutUI{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight - 50) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //以xib方式注册cell
    [_collectionView registerNib:[UINib nibWithNibName:@"SortProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SortProductCell_ID"];
    _collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   return self.dataArray.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
     return  1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SortProductCollectionViewCell *cell = (SortProductCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SortProductCell_ID" forIndexPath:indexPath];
    
    cell.dataDicionary = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark- FlowDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
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
    NSDictionary *dic = self.dataArray[indexPath.row];
    NSString *goodsCode = [NSString stringWithFormat:@"%@",[dic objectForKey:@"goodsCode"]];
    if (goodsCode.length > 0) {
        ShopDetailVC *VC  = [[ShopDetailVC alloc] init];
        VC.shopModel = [[ShopModel alloc] init];
        VC.shopModel.strGoodsCode = goodsCode;
        VC.esi = @"category";
        VC.esi = self.cateCode;
        [self.navigationController pushViewController:VC animated:YES];
    }
}


@end
