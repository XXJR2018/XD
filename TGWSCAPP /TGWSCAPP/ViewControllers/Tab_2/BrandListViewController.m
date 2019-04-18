//
//  BrandListViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/3/26.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "BrandListViewController.h"

#import "SortProductCollectionViewCell.h"
#import "ShopDetailVC.h"


@interface BrandListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
{
    UIButton *_sortBtn;
    NSMutableArray *_sortBtnArr;
    UIView *_sortViewX;
    UIView *_naviView;
    NSString *_bannerImgStr;
}

@property(nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableDictionary *cellDic;

@end

@implementation BrandListViewController

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
    if ([operation.jsonResult.attr objectForKey:@"bannerUrl"]) {
        _bannerImgStr = [NSString stringWithFormat:@"%@",[operation.jsonResult.attr objectForKey:@"bannerUrl"]];
    }
    if (_bannerImgStr.length == 0) {
        [self layoutNaviBarViewWithTitle:self.titleStr];
        _collectionView.frame = CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight);
    }
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
    [MobClick beginLogPageView:@"品牌列表点击"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"品牌列表点击"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cellDic = [[NSMutableDictionary alloc] init];
    [self layoutNaviUI];
    [self layoutUI];
    
}

-(void)layoutNaviUI{
    _naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NavHeight)];
    _naviView.backgroundColor = [UIColor whiteColor];
    
    UIButton *clickBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, NavHeight - 40, 50, 40)];
    [_naviView addSubview:clickBtn];
    [clickBtn setImage:[ResourceManager arrow_return] forState:UIControlStateNormal];
    [clickBtn addTarget:self action:@selector(clickNavButton) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, NavHeight - 40, SCREEN_WIDTH - 60 * 2, 35)];
    [_naviView addSubview:titleLabel];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [ResourceManager color_1];
    titleLabel.text = self.titleStr;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, NavHeight - 0.5, SCREEN_WIDTH, 0.5)];
    [_naviView addSubview:lineView];
    lineView.backgroundColor = [ResourceManager color_5];
    
    _naviView.hidden = YES;
}

-(void)clickNavButton{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)layoutUI{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //以xib方式注册cell
    [_collectionView registerNib:[UINib nibWithNibName:@"SortProductCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"brandSortProductCell_ID"];
    //注册头视图，相当于段头
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"brandHeaderView"];
    
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

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"brandHeaderView" forIndexPath:indexPath];
        if (_bannerImgStr.length > 0) {
            UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150 * ScaleSize)];
            imgView.backgroundColor = UIColorFromRGB(0xF6F6F6);
            imgView.userInteractionEnabled = YES;
            [imgView sd_setImageWithURL:[NSURL URLWithString:_bannerImgStr]];
            [header addSubview:imgView];
            UIButton *clickBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, NavHeight - 40, 50, 40)];
            [imgView addSubview:clickBtn];
            [clickBtn setImage:[UIImage imageNamed:@"com_back"] forState:UIControlStateNormal];
            [clickBtn addTarget:self action:@selector(clickNavButton) forControlEvents:UIControlEventTouchUpInside];
        }
        return header;
    }
    return nil;
}

//段头高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeZero;
     if (_bannerImgStr.length > 0) {
         size =  CGSizeMake(SCREEN_WIDTH, 150 * ScaleSize);
     }
    return size;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SortProductCollectionViewCell *cell = (SortProductCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"brandSortProductCell_ID" forIndexPath:indexPath];
    
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

#pragma mark- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_bannerImgStr.length > 0) {
        if (_collectionView.contentOffset.y >= NavHeight) {
            _naviView.hidden = NO;
            [self.view addSubview:_naviView];
        }else{
            _naviView.hidden = YES;
        }
    }
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
