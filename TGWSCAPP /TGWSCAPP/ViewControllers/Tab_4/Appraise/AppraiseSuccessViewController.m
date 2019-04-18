//
//  AppraiseSuccessViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/15.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "AppraiseSuccessViewController.h"
#import "IssueAppraiseViewController.h"
#import "ShopDetailVC.h"

#import "AppraiseSuccessCell.h"
#import "AppraiseSuccessCollectionViewCell.h"

@interface AppraiseSuccessViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UIView *_headerView;
    UITableView *_tableView;
    UICollectionView *_collectionView;
}
@end

@implementation AppraiseSuccessViewController

-(void)clickNavButton:(UIButton *)button{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"评价"];
    
    [self headerViewUI];
    
    if (self.appraiseDataDic.count > 0) {
        if ([[self.appraiseDataDic objectForKey:@"isComment"] intValue] == 0) {
            //推荐商品列表
            NSArray *showGoodsList = [self.appraiseDataDic objectForKey:@"showGoodsList"];
            if (showGoodsList.count > 0) {
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:showGoodsList];
            }
            
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            flowLayout.minimumLineSpacing = 0;
            flowLayout.minimumInteritemSpacing = 0;
            flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
            
            _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight) collectionViewLayout:flowLayout];
            _collectionView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_collectionView];
            _collectionView.delegate = self;
            _collectionView.dataSource = self;
            //注册头视图，相当于段头
            [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"appraiseHeaderView"];
            //以xib方式注册cell
            [_collectionView registerNib:[UINib nibWithNibName:@"AppraiseSuccessCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ASCVCell_ID"];
            
        }else if ([[self.appraiseDataDic objectForKey:@"isComment"] intValue] == 1) {
            //未评论商品列表
            NSArray *orderDtlList = [self.appraiseDataDic objectForKey:@"orderDtlList"];
            if (orderDtlList.count > 0) {
                [self.dataArray removeAllObjects];
                [self.dataArray addObjectsFromArray:orderDtlList];
            }
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
            [self.view addSubview:_tableView];
            _tableView.backgroundColor = [UIColor whiteColor];
            _tableView.delegate = self;
            _tableView.dataSource = self;
            [_tableView setTableHeaderView:_headerView];
            [_tableView setTableFooterView:[UIView new]];
            [_tableView registerNib:[UINib nibWithNibName:@"AppraiseSuccessCell" bundle:nil] forCellReuseIdentifier:@"AppraiseSuccess_tableView_cell"];
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
            [_tableView setSeparatorColor:[ResourceManager color_5]];
        }
        
    }
    
}

-(void)headerViewUI{
    [_headerView removeFromSuperview];
    _headerView = [[UIView alloc]init];
    _headerView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 156 * ScaleSize)];
    [_headerView addSubview:bgImgView];
    bgImgView.image = [UIImage imageNamed:@"Tab_4-41"];
    bgImgView.userInteractionEnabled = YES;
    
    UIButton *appraiseSuccessBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 150)/2, 20, 150, 30)];
    [bgImgView addSubview:appraiseSuccessBtn];
    [appraiseSuccessBtn setTitle:@"评价成功" forState:UIControlStateNormal];
    [appraiseSuccessBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [appraiseSuccessBtn setImage:[UIImage imageNamed:@"Tab_4-42"] forState:UIControlStateNormal];
    appraiseSuccessBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [appraiseSuccessBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(appraiseSuccessBtn.frame) + 5, SCREEN_WIDTH, 40)];
    [bgImgView addSubview:titleLabel];
    titleLabel.numberOfLines = 2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"非常感谢您的评价\n您的评价是对我们最好的帮助和鼓励";
    if ([[self.appraiseDataDic objectForKey:@"commScore"] intValue] > 0) {
        titleLabel.text = [NSString stringWithFormat:@"已获得%@积分\n坚持写有图评价，赚更多积分吧~",[self.appraiseDataDic objectForKey:@"commScore"]];
    }
    
    UIButton *backHomeBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 110, CGRectGetMaxY(titleLabel.frame) + 10, 100, 35)];
    [bgImgView addSubview:backHomeBtn];
    backHomeBtn.layer.cornerRadius = 35/2;
    backHomeBtn.layer.borderWidth = 0.5;
    backHomeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    backHomeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [backHomeBtn setTitle:@"返回首页" forState:UIControlStateNormal];
    [backHomeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backHomeBtn addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *checkAppraiseBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 10, CGRectGetMaxY(titleLabel.frame) + 10, 100, 35)];
    [bgImgView addSubview:checkAppraiseBtn];
    checkAppraiseBtn.layer.cornerRadius = 35/2;
    checkAppraiseBtn.layer.borderWidth = 0.5;
    checkAppraiseBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    checkAppraiseBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [checkAppraiseBtn setTitle:@"查看评价" forState:UIControlStateNormal];
    [checkAppraiseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [checkAppraiseBtn addTarget:self action:@selector(checkAppraise) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 250)/2, CGRectGetMaxY(bgImgView.frame) + 30 - 0.5, 250, 0.5)];
    [_headerView addSubview:lineView];
    lineView.backgroundColor = [ResourceManager mainColor];
    
    UILabel *subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 120)/2, CGRectGetMidY(lineView.frame) - 20, 120, 40)];
    [_headerView addSubview:subTitleLabel];
    subTitleLabel.backgroundColor = [UIColor whiteColor];
    subTitleLabel.textAlignment = NSTextAlignmentCenter;
    subTitleLabel.font = [UIFont systemFontOfSize:14];
    subTitleLabel.textColor = [ResourceManager color_1];
    
    if ([[self.appraiseDataDic objectForKey:@"isComment"] intValue] == 0) {
        //推荐商品列表
      subTitleLabel.text = @"你可能还想买";
    }else if ([[self.appraiseDataDic objectForKey:@"isComment"] intValue] == 1) {
        //未评论商品列表
      subTitleLabel.text = @"接着评论下去吧";
    }
    
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, CGRectGetMaxY(subTitleLabel.frame));
}

//返回首页
-(void)backHome{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(1)}];
}

//查看评价
-(void)checkAppraise{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(4),@"index":@(1)}];
}


#pragma mark === UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppraiseSuccessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppraiseSuccess_tableView_cell"];
    if (!cell) {
        cell = [[AppraiseSuccessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AppraiseSuccess_tableView_cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.appraiseBlock = ^{
        //评价
        IssueAppraiseViewController *ctl = [[IssueAppraiseViewController alloc]init];
        ctl.orderDataDic = dic;
        [self.navigationController pushViewController:ctl animated:YES];
    };
    
    cell.dataDicionary = dic;
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
    return self.dataArray.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"appraiseHeaderView" forIndexPath:indexPath];
        
        //头视图添加view
        [header addSubview:_headerView];
        return header;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = CGSizeZero;
    size = CGSizeMake(SCREEN_WIDTH, _headerView.frame.size.height);
    return size;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AppraiseSuccessCollectionViewCell *cell = (AppraiseSuccessCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ASCVCell_ID" forIndexPath:indexPath];
    
    cell.dataDicionary = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark- FlowDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH/3, SCREEN_WIDTH/3 + 70);
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
        VC.esi =  [dic objectForKey:@"cateCode"];
        [self.navigationController pushViewController:VC animated:YES];
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
