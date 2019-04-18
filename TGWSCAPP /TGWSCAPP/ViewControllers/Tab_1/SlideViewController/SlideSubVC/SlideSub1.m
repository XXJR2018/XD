//
//  SlideSub1.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/14.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "SlideSub1.h"
#import "CKSlideMenu.h"
#import "SDCycleScrollView.h"
#import "ShopListView.h"
#import "AdvertingShopListView.h"
#import "ShopDetailVC.h"
#import "ProductListViewController.h"
#import "ShopMoreVC.h"
#import "ShopMoreAtTimeVC.h"
#import "ShopActiveView.h"
#import "ShopAllVC.h"

#define  BANNER_HEIGHT       (170*ScaleSize)      // Banner的高度

@interface SlideSub1 ()<SDCycleScrollViewDelegate,AdvertingShopListViewDelegate,ShopListViewDelegate,ShopActiveViewDelegate>
{
    UIScrollView *scView;
    
    SDCycleScrollView *_scrollView;      // 头部banner
    NSMutableArray *_bannerUrlArr;
    NSMutableArray *_bannerTitleArr;
    NSMutableArray *_bannerJumpType;
    
    ShopModel *myClickObj;
}
@end

@implementation SlideSub1

#pragma mark --- lifecylce
-(void)viewWillAppear:(BOOL)animated
{
    [self getUIformWeb];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifScroll) name:SliedScrollNotification object:nil];
    //NSLog(@"SlideSub1  frame:%f", self.view.frame.size.height);
    
    
    // 首页只有一个sub时， 从此函数布局UI
    //self.view.height = SCREEN_HEIGHT - 70  - TabbarHeight;
    
    
    
    [self getUIformWeb];
    
    //[self layoutUI];
}


#pragma mark --- 布局UI

 //使用本地数据来布局UI
- (void)darwUIOfLcalUI
{
    // 先用本地缓存的数据 来刷新UI
    NSDictionary *dicUI = [CommonInfo getKeyOfDic:K_Home_TJ_UIData];
    if (dicUI)
     {
        [self layoutUIByData:dicUI];
     }
}

// view 已经布局其 Subviews
- (void)viewDidLayoutSubviews
{
    NSLog(@"SlideSub1 viewDidLayoutSubviews");
    //[self getUIformWeb];
    
    //[self layoutUI];
    
    [self darwUIOfLcalUI];
}


-(void) layoutUI
{
    //NSLog(@"SlideSub1  frame:%f", self.view.frame.size.height);
    
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, self.view.frame.size.height)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 2000);
    //scView.pagingEnabled = NO;
    //scView.bounces = NO;
   // scView.showsVerticalScrollIndicator = FALSE;
    //scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [UIColor whiteColor];//[ResourceManager viewBackgroundColor];
    
    
    
    
    
    // banner （商品）
    int iTopY = 0;
    int iLeftX = 0;
    if (!_scrollView){
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH, BANNER_HEIGHT) imageNamesGroup:@[@"Tab1_Banner",@"Tab1_Banner"]];
        [scView addSubview:_scrollView];
    }
    _bannerTitleArr = [NSMutableArray arrayWithArray:@[@"商品1",@"商品2"]];
    _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _scrollView.delegate = self;
    _scrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    
    // 底部商品说明
    iTopY += _scrollView.height;
    UIImage *imgSPSM = [UIImage imageNamed:@"Tab1_SPSM"];
    float fImgHeight = imgSPSM.size.height;
    NSLog(@"imgTest.size.height: %f, imgTest.size.width: %f" ,imgSPSM.size.height,imgSPSM.size.width);
    
    UIImageView *imgViewSPSM = [[UIImageView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, fImgHeight *ScaleSize)];
    [scView addSubview:imgViewSPSM];
    imgViewSPSM.image = imgSPSM;

    
    // 推荐商品
    iTopY += imgViewSPSM.height;
    //NSArray *arrImg =@[@"Tab1_TJSP",@"Tab1_TJSP",@"Tab1_TJSP",@"Tab1_TJSP"];
    NSMutableArray  *tempArr = [[NSMutableArray alloc] init];
    for (int i = 0;  i < 6; i++)
     {
        ShopModel *sModel = [[ShopModel alloc] init];
        sModel.iShopID = i;
        sModel.strGoodsImgUrl = @"Tab1_TJSP";
        [tempArr addObject:sModel];
     }
    //NSArray *arrImg =@[@"Tab1_TJSP",@"Tab1_TJSP"];
    AdvertingShopListView  *adListView = [[AdvertingShopListView alloc] initWithTitle:@"推荐商品" itemArray:tempArr origin_Y:iTopY];
    [scView addSubview:adListView];
    adListView.delegate = self;
    
    
    // 热销商品
    NSMutableArray  *tempArr1 = [[NSMutableArray alloc] init];
    for (int i = 0;  i < 6; i++)
     {
        ShopModel *sModel = [[ShopModel alloc] init];
        sModel.iShopID = i;
        sModel.strGoodsImgUrl = @"Tab1_RMSP";
        sModel.strGoodsName = @"凯尔德乐婴儿";
        sModel.strMaxPrice = @"¥ 13.90";
        [tempArr1 addObject:sModel];
     }
    iTopY += adListView.height;
    ShopListView  *shopListView1 = [[ShopListView alloc] initWithTitle:@"热销商品" itemArray:tempArr1  columnCount:3  origin_Y:iTopY];
    [scView addSubview:shopListView1];
    shopListView1.delegate = self;
    
    
    // 热销商品
    NSMutableArray  *tempArr2 = [[NSMutableArray alloc] init];
    for (int i = 0;  i < 6; i++)
     {
        ShopModel *sModel = [[ShopModel alloc] init];
        sModel.iShopID = i;
        sModel.strGoodsImgUrl = @"Tab1_RMSP";
        sModel.strGoodsName = @"凯尔德乐婴儿凯尔德乐婴儿凯尔德乐婴儿凯尔德乐婴儿";
        sModel.strMaxPrice = @"¥ 13.90";
        [tempArr2 addObject:sModel];
     }
    iTopY += shopListView1.height;
    ShopListView  *shopListView2 = [[ShopListView alloc] initWithTitle:@"新品发售" itemArray:tempArr2  columnCount:3  origin_Y:iTopY];
    [scView addSubview:shopListView2];
    shopListView2.delegate = self;
    
    
    
    iTopY += shopListView2.height;
    scView.contentSize = CGSizeMake(0, iTopY);
    
    

}


// 根据网络 或者本地数据，画UI
-(void) layoutUIByData:(NSDictionary*) dicUI
{
    NSLog(@"SlideSub1  frame:%f", self.view.frame.size.height);
    NSLog(@"Draw Home  Begin");
    
    if (scView)
     {
        [scView removeAllSubviews];
     }
    
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, 0.f, SCREEN_WIDTH, self.view.frame.size.height)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 1000);
    scView.pagingEnabled = NO;
    //scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [UIColor whiteColor];//[ResourceManager viewBackgroundColor];
    
    
    scView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getUIformWeb)];
    
    //scView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getUIformWeb)];
    
    
    // banner （商品）
    int iTopY = 0;
    int iLeftX = 0;
    if (!_scrollView){
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH, BANNER_HEIGHT) imageNamesGroup:@[@"Tab1_Banner",@"Tab1_Banner"]];
        [scView addSubview:_scrollView];
    }
    _bannerTitleArr = [NSMutableArray arrayWithArray:@[@"商品1",@"商品2"]];
    _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _scrollView.delegate = self;
    _scrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    
    NSArray *arrBannr = dicUI[@"bannerList"];
    
    [self layoutScrollViewAfter:arrBannr];
    
    
    // 底部商品说明
    iTopY += _scrollView.height;
    NSString *strSPSM = dicUI[@"dissemImg"];
    strSPSM = strSPSM ? strSPSM:@"Tab1_SPSM";
    
    
    UIImage *imgSPSM = [ToolsUtlis getImgFromStr:strSPSM];
    
    //CGFloat fixelW = CGImageGetWidth(imgSPSM.CGImage);
    CGFloat fixelH = CGImageGetHeight(imgSPSM.CGImage);
    float fImgHeight = fixelH*FixelScaleSize;
    
    UIImageView *imgViewSPSM = [[UIImageView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, fImgHeight *ScaleSize)];
    [scView addSubview:imgViewSPSM];
    imgViewSPSM.image = imgSPSM;

    
    // 各种商品列表
    iTopY += imgViewSPSM.height;
    NSArray *arrTypeList =  dicUI[@"typeList"];
    if (!arrTypeList ||
        [arrTypeList count] <= 0)
     {
        return;
     }
    
    for (int i = 0; i < [arrTypeList count]; i++)
     {
        NSDictionary *dicType = arrTypeList[i];
        
        int iShowType = [dicType[@"showType"] intValue]; //展示内容类型0-商品1-类目 2-活动 3-品牌
        
        NSString  *strTypeTitle = [NSString stringWithFormat:@"%@",dicType[@"typeTitle"]]; // 类别标题
        NSString  *strTypeCode = [NSString stringWithFormat:@"%@",dicType[@"typeCode"]];    // 类别code
        
        int iColumnOneCount = [dicType[@"oneRowStyle"] intValue];  // 第一行的元素个数
        int iColumnTwoCount = [dicType[@"twoRowStyle"] intValue];  // 第二行之后的元素个数
        
        
        // 显示数组为空， continue
        NSArray *arrShowList  = dicType[@"showIdList"];
        //arrShowList = nil;
        if (!arrShowList ||
            [arrShowList count] == 0)
         {
            continue;
         }

        // 获取每种类型需要显示的商品list
        NSMutableArray  *tempArr = [[NSMutableArray alloc] init];

        for (int i = 0;  i < [arrShowList count]; i++)
         {
            NSDictionary *dicObject = arrShowList[i];
            ShopModel *sModel = [[ShopModel alloc] init];
            sModel.iShopID = i;
            //sModel.strGoodsImgUrl = @"Tab1_TJSP";
            sModel.strGoodsImgUrl =  [NSString stringWithFormat:@"%@",dicObject[@"imgUrl"]];
            sModel.strMinPrice = [NSString stringWithFormat:@"%@", [ToolsUtlis getnumber:[dicObject objectForKey:@"minPrice"]]];
            sModel.strMaxPrice = [NSString stringWithFormat:@"%@",[ToolsUtlis getnumber:[dicObject objectForKey:@"maxPrice"]]];
            sModel.strGoodsCode = [NSString stringWithFormat:@"%@",dicObject[@"goodsCode"]];
            sModel.strGoodsName = [NSString stringWithFormat:@"%@",dicObject[@"goodsName"]];
            sModel.strGoodsSubName = [NSString stringWithFormat:@"%@",dicObject[@"goodsSubName"]];
            sModel.strCateCode = [NSString stringWithFormat:@"%@",dicObject[@"cateCode"]];
            sModel.strCateName = [NSString stringWithFormat:@"%@",dicObject[@"cateName"]];
            sModel.iIsSellOut = [dicObject[@"isSellOut"] intValue];
            sModel.iSaleStatus = [dicObject[@"isSellOut"] intValue];
            
            // 活动时，特别添加的字段
            sModel.iSkipType = [dicObject[@"skipType"] intValue];
            sModel.strSkipUrl = [NSString stringWithFormat:@"%@",dicObject[@"skipUrl"]];;
            
            
            [tempArr addObject:sModel];
         }

        //展示内容类型0-商品1-类目 2-活动 3-品牌
        // 目前，只有 商品 和  类目 两种  商品就是全部显示图片
        // 活动  和 商品是一样的，全部显示图片
       if (0 == iShowType)
 
         {
            ShopListView  *shopListView = [[ShopListView alloc] initWithTitle:strTypeTitle itemArray:tempArr origin_Y:iTopY
                                                                               columnOneCount:iColumnOneCount  columnTwoCount:iColumnTwoCount];
            [scView addSubview:shopListView];
            ShopModel *sModel = [[ShopModel alloc] init];
            sModel.strTypeName = strTypeTitle;
            sModel.strTypeCode = strTypeCode;
            shopListView.delegate = self;
            shopListView.shopModel = sModel;
            iTopY += shopListView.height;
            
            UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 10)];
            [scView addSubview:viewFG];
            viewFG.backgroundColor = [ResourceManager viewBackgroundColor];
            iTopY += viewFG.height;
         }
        else  if (1 == iShowType)
         {
            AdvertingShopListView  *adListView = [[AdvertingShopListView alloc] initWithTitle:strTypeTitle itemArray:tempArr origin_Y:iTopY
                                                                               columnOneCount:iColumnOneCount  columnTwoCount:iColumnTwoCount];
            [scView addSubview:adListView];
            ShopModel *sModel = [[ShopModel alloc] init];
            sModel.strTypeName = strTypeTitle;
            sModel.strTypeCode = strTypeCode;
            adListView.delegate = self;
            adListView.shopModel = sModel;
            iTopY += adListView.height +10;
            
            UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 10)];
            [scView addSubview:viewFG];
            viewFG.backgroundColor = [ResourceManager viewBackgroundColor];
            iTopY += viewFG.height;
         }
        else if (2 == iShowType)
         {
            ShopActiveView  *adListView = [[ShopActiveView alloc] initWithTitle:strTypeTitle itemArray:tempArr origin_Y:iTopY
                                                                               columnOneCount:iColumnOneCount  columnTwoCount:iColumnTwoCount];
            [scView addSubview:adListView];
            ShopModel *sModel = [[ShopModel alloc] init];
            sModel.strTypeName = strTypeTitle;
            sModel.strTypeCode = strTypeCode;
            adListView.delegate = self;
            adListView.shopModel = sModel;
            iTopY += adListView.height +10;
            
            UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 10)];
            [scView addSubview:viewFG];
            viewFG.backgroundColor = [ResourceManager viewBackgroundColor];
            iTopY += viewFG.height;
         }

     }
    
    
   

    scView.contentSize = CGSizeMake(0, iTopY);
    
    NSLog(@"Draw Home  End");
    
}


/**
 *  banner 请求完成之后做布局
 */
-(void)layoutScrollViewAfter:(NSArray*)arr
{
    
    if (arr.count == 0) {
        return;
    }
    
    //请求接口后banner加载后台数据
    [_scrollView removeAllSubviews];
    _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, BANNER_HEIGHT) delegate:nil placeholderImage:[UIImage imageNamed:@"Tab1_Banner"]];
    [scView addSubview:_scrollView];
    
    NSMutableArray *imgArr = [[NSMutableArray alloc] init];
    _bannerTitleArr = [[NSMutableArray alloc] init];
    _bannerUrlArr = [[NSMutableArray alloc] init];
    _bannerJumpType = [[NSMutableArray alloc] init];
    
    for (NSDictionary * dic in arr)
     {
        NSString *name = dic[@"bannerName"];
        NSString *imgUrl = dic[@"imgUrl"];
        NSString *skipUrl = dic[@"targetUrl"];
        NSNumber *iJumpType = dic[@"jumpType"];
        [imgArr addObject:imgUrl];
        if (name)
         {
            [_bannerTitleArr addObject:name];
         }
        if (skipUrl)
         {
            [_bannerUrlArr addObject:skipUrl];
         }
        [_bannerJumpType addObject:iJumpType];
        
     }
    _scrollView.imageURLStringsGroup = imgArr;
    _scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _scrollView.delegate = self;
    _scrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
}


#pragma mark --- 网络通讯
-(void)getUIformWeb
{
    //NSString *strUrl = [PDAPI getBannerAPI];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLqueryShowTypeList];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                                                                                    [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 1000;
    [operation start];
}

-(void)queryTypeMoreInfoList:(NSString*) strTypeCode
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"typeCode"] = strTypeCode;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLqueryTypeMoreInfoList];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 1001;
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    
    if (operation.tag == 1000)
     {

        [scView.mj_header endRefreshing];
        
        NSDictionary *dicUI = operation.jsonResult.attr;
        
        NSDictionary *dicLocalUI = [CommonInfo getKeyOfDic:K_Home_TJ_UIData];
        
        if (dicLocalUI &&
            [dicLocalUI isEqual:dicUI])
         {
            // 如果网络数据 和 本地数据一摸一样， 直接退出，不再刷新UI 
            return;
         }
        
        
        if (dicUI)
         {
            [CommonInfo setKey:K_Home_TJ_UIData withDicValue:dicUI];
            [self layoutUIByData:dicUI];
         }
        else
         {
            [MBProgressHUD showErrorWithStatus:@"数据加载失败，请检查网络配置" toView:self.view];
         }
        
     }
    
    if (1001 == operation.tag)
     {
        NSDictionary *dic = operation.jsonResult.attr;
        if (dic)
         {
            int isShowTime = [dic[@"isShowTime"] intValue];
            if (1 == isShowTime)
             {
                
                ShopMoreAtTimeVC *ctl = [[ShopMoreAtTimeVC alloc] init];
                ctl.strTypeCode = [NSString stringWithFormat:@"%@",myClickObj.strTypeCode];
                ctl.strTypeName = myClickObj.strTypeName;
                [self.navigationController pushViewController:ctl animated:YES];
                
                return;
             }
         }
        
        
        ShopMoreVC *ctl = [[ShopMoreVC alloc] init];
        ctl.strTypeCode = [NSString stringWithFormat:@"%@",myClickObj.strTypeCode];
        ctl.strTypeName = myClickObj.strTypeName;
        [self.navigationController pushViewController:ctl animated:YES];
        
        
     }
    

}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    
    [scView.mj_header endRefreshing];
    
}


#pragma mark - delegate
//SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (index >= [_bannerTitleArr count])
     {
        return;
     }
    
    if (index >= [_bannerUrlArr count])
     {
        return;
     }
    
    //`jumpType` int(2) DEFAULT '0' COMMENT '跳转类型 0-不跳转 1-跳转本地 2-跳H5页面',
    NSNumber *iJumpType = (NSNumber *)_bannerJumpType[index];
    if (0 == [iJumpType intValue])
     {
        return;
     }
    
//    NSString *titleStr = _bannerTitleArr[index];
//    if ([titleStr isEqualToString:@"抢单规则"]) {
//        [self ljqdAction];
//
//        return;
//    }else if ([titleStr isEqualToString:@"邀请好友"]){
//
//        if ([[DDGAccountManager sharedManager] isLoggedIn]) {
//            SharePrize *ctl = [[SharePrize alloc] init];
//            [self.navigationController pushViewController:ctl animated:YES];
//            return;
//        }else {
//            [DDGUserInfoEngine engine].parentViewController = self;
//            [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
//            return;
//        }
//
//
//    }
//    else if ([titleStr isEqualToString:@"充值"]) {
//        if ([[DDGAccountManager sharedManager] isLoggedIn]) {
//            VIPViewController *adVC = [[VIPViewController alloc] init];
//            NSDictionary *dic = [DDGAccountManager sharedManager].userInfo;
//            adVC.vipGrade = [[dic objectForKey:@"vipGrade"] integerValue];
//            adVC.usableAmount = [NSString stringWithFormat:@"%@",[dic objectForKey:@"usableAmount"]];
//            adVC.vipEndDate = [NSString stringWithFormat:@"%@",[dic objectForKey:@"vipEndDate"]];
//            adVC.name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"realName"]];
//            adVC.imageUrl = [NSString stringWithFormat:@"%@",[dic objectForKey:@"userImage"]];
//            [self.navigationController pushViewController:adVC animated:YES];
//            return;
//        }else {
//            [DDGUserInfoEngine engine].parentViewController = self;
//            [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
//            return;
//        }
//
//    }
    
    if (1 == [iJumpType  intValue])
     {
        NSString *strURL = _bannerUrlArr[index];
        NSData *jsonData = [strURL dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err = nil;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        
        if(err) {
            NSLog(@"json解析失败：%@",err);
            //return nil;
        }
        
        if (dic)
         {
            NSString *strIosClassName = dic[@"iosClassName"];
            NSString *strInitparams = dic[@"initparams"];
            // 跳转商品详情页面
            if ([strIosClassName isEqualToString:@"ShopDetailVC"] &&
                strInitparams)
             {
                // 多个参数 用#来分割
                //NSArray *strarray = [strInitparams componentsSeparatedByString:@"#"];
                
                NSArray *arrParams = [strInitparams componentsSeparatedByString:@"|"];
                if (arrParams.count >= 2 )
                 {
                     ShopDetailVC *VC  = [[ShopDetailVC alloc] init];
                     ShopModel *tempObj = [[ShopModel alloc] init];
                     tempObj.strGoodsCode = arrParams[1];
                     VC.shopModel = tempObj;
                     VC.est = @"category";
                     VC.esi = arrParams[1];
                     [self.navigationController pushViewController:VC animated:YES];
                     return;
                     
                 }
                
             }
         }
     }
    else
     {
        //如果不是以上两个，跳转相应h5页面
        [CCWebViewController showWithContro:self withUrlStr:_bannerUrlArr[index] withTitle:_bannerTitleArr[index]];
     }
}


// AdvertingShopListViewDelegate
-(void)didClickButtonAtObejct:(ShopModel*)clickObj
{
    if ([clickObj  isKindOfClass:[ShopModel class]])
     {
        int iShopID = clickObj.iShopID;
        // 点击更多按钮
        if (-1 == iShopID)
         {
            NSLog(@"Click More");
            NSLog(@"strGoodsName:%@  strTypeCode:%@", clickObj.strTypeCode,clickObj.strTypeName);
            //[self queryTypeMoreInfoList:clickObj.strTypeCode];
            
            ShopMoreVC *ctl = [[ShopMoreVC alloc] init];
            ctl.strTypeCode = [NSString stringWithFormat:@"%@",clickObj.strTypeCode];
            ctl.strTypeName = clickObj.strTypeName;
            [self.navigationController pushViewController:ctl animated:YES];
         }
        else
         {
            NSLog(@"ShopID:%d", iShopID);
            NSLog(@"strCateCode:%@  strCateName:%@", clickObj.strCateCode,clickObj.strCateName);
            
            
            ShopMoreVC *ctl = [[ShopMoreVC alloc] init];
            ctl.strTypeCode = [NSString stringWithFormat:@"%@",clickObj.strCateCode];
            ctl.strTypeName = clickObj.strCateName;
            ctl.isGoodType = true;
            [self.navigationController pushViewController:ctl animated:YES];
         }
        
        
//        //开始登录
//        if (![[DDGAccountManager sharedManager] isLoggedIn])
//         {
//            [DDGUserInfoEngine engine].parentViewController = self;
//            [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
//            return;
//         }

        
     }
}



// ShopListViewDelegate
-(void)didShopClickButtonAtObejct:(ShopModel*)clickObj
{
    if ([clickObj  isKindOfClass:[ShopModel class]])
     {
        int iShopID = clickObj.iShopID;
        // 点击更多按钮
        if (-1 == iShopID)
         {
            myClickObj = clickObj;
            
            NSLog(@"Click More ");
            NSLog(@"strGoodsName:%@  strTypeCode:%@", clickObj.strTypeCode,clickObj.strTypeName);
            [self queryTypeMoreInfoList:clickObj.strTypeCode];

         }
        else
         {
            NSLog(@"ShopID:%d", iShopID);
            NSLog(@"strGoodsName:%@ strGoodsSubName:%@  strGoodsCode:%@", clickObj.strGoodsName,clickObj.strGoodsSubName,clickObj.strGoodsCode);
            
            ShopDetailVC *VC  = [[ShopDetailVC alloc] init];
            VC.shopModel = clickObj;
            VC.est = @"category";
            VC.esi = clickObj.strCateCode;
            [self.navigationController pushViewController:VC animated:YES];
            
         }
        
     }
}

// ShopActiveViewDelegate
-(void)didShopActiveClickButtonAtObejct:(ShopModel*)clickObj
{
    if ([clickObj  isKindOfClass:[ShopModel class]])
     {
        int iShopID = clickObj.iShopID;
        // 点击更多按钮
        if (-1 == iShopID)
         {
            myClickObj = clickObj;
            
            NSLog(@"Click More ");
            NSLog(@"strGoodsName:%@  strTypeCode:%@", clickObj.strTypeCode,clickObj.strTypeName);
            
            ShopAllVC *VC  = [[ShopAllVC alloc] init];
            VC.strTypeCode = [NSString stringWithFormat:@"%@",myClickObj.strTypeCode];
            VC.strTypeName = myClickObj.strTypeName;
            [self.navigationController pushViewController:VC animated:YES];
            return;
            
         }
        else
         {
            NSLog(@"ShopID:%d", iShopID);
            NSLog(@"strGoodsName:%@ strGoodsSubName:%@  strGoodsCode:%@", clickObj.strGoodsName,clickObj.strGoodsSubName,clickObj.strGoodsCode);
            
            int iSkipType = clickObj.iSkipType;  //  0 - 不跳转， 1 - 跳转本地页面，  2 - 跳转URL
            
            if (1 == iSkipType)
             {
                NSData *jsonData = [clickObj.strSkipUrl dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err = nil;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:&err];
                
                if(err) {
                    NSLog(@"json解析失败：%@",err);
                    //return nil;
                }
                
                if (dic)
                 {
                    NSString *strIosClassName = dic[@"iosClassName"];
                    NSString *strInitparams = dic[@"initparams"];
                    // 跳转商品详情页面
                    if ([strIosClassName isEqualToString:@"ShopDetailVC"] &&
                        strInitparams)
                     {
                        // 多个参数 用#来分割
                        //NSArray *strarray = [strInitparams componentsSeparatedByString:@"#"];
                        
                        NSArray *arrParams = [strInitparams componentsSeparatedByString:@"|"];
                        if (arrParams.count >= 2 )
                         {                            
                            ShopDetailVC *VC  = [[ShopDetailVC alloc] init];
                            ShopModel *tempObj = [[ShopModel alloc] init];
                            tempObj.strGoodsCode = arrParams[1];
                            VC.shopModel = tempObj;
                            VC.est = @"category";
                            VC.esi = clickObj.strGoodsCode;
                            [self.navigationController pushViewController:VC animated:YES];
                            return;
                            
                         }
                        
                     }
                 }
        
                
             }
            else if (2 == iSkipType)
             {
                NSString *url = clickObj.strSkipUrl;
                [CCWebViewController showWithContro:self withUrlStr:url withTitle:@"详情"];
             }
            
            //010103003、010101023、080102001、080101001
            NSArray *arrID = @[@"010103003",@"010101023",@"080102001",@"080101001"];
            if (clickObj.iShopID < 4)
             {
                ShopDetailVC *VC  = [[ShopDetailVC alloc] init];
                clickObj.strGoodsCode = arrID[clickObj.iShopID];
                VC.shopModel = clickObj;
                VC.est = @"category";
                VC.esi = clickObj.strCateCode;
                [self.navigationController pushViewController:VC animated:YES];
                return;
             }
            
            
         }
        
     }
}

#pragma mark  ---  Notification
-(void) notifScroll
{
    [self getUIformWeb];
}









@end
