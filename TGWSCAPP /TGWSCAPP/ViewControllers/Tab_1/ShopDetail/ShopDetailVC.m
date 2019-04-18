//
//  ShopDetailVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/21.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "ShopDetailVC.h"
#import <AVFoundation/AVFoundation.h>
#import "TSVideoPlayback.h"
#import "PopSelShopView.h"
#import "LZCartViewController.h"
#import "AllAppraiseListViewController.h"
#import "ShowBigJpgView.h"
#import "ShowBannerJpegView.h"
#import "ShareShopJpegView.h"
#import "ChatViewController.h"


//#define   BannerHeight     300
#define   BannerHeight     SCREEN_WIDTH
#define   ShopRedColor     UIColorFromRGB(0x9f1421)

@interface ShopDetailVC ()<TSVideoPlaybackDelegate,UIScrollViewDelegate>
{
    UIScrollView *scView;
    UIImageView *imgShouCang;
    UILabel *labelCartNum;  // 购物车数量
    
    CustomNavigationBarView *nav;
    
    UIView *viewPopShare;  // 分享的弹框
    
    NSMutableArray *arrTopIMG; // 顶部的 视频和图片 数组
    int iTopType;    //   0 - 表示全图片，  1 -  表示为首张为视频，剩下的为图片
    
    NSMutableArray *activityList; // 优惠活动的 数组
    
    int  iTailViewTopY; // 底部图片Top坐标
    NSMutableArray *arrTailIMG;   // 底部的图片数组
    
    NSArray *arrSku;
    NSArray *arrSkuShow;
    
    NSArray *arrDetailJpgUrl; // 详情图片数组
    
    int  maxPostFree;  // 包邮免费金额
    bool isFavorite;   // 是否收藏
    NSString *qrcodeUrl;
    
    int   userCommCount;  // 用户评价量
    NSString *goodsRate;  // 用户满意度
}

@property (strong, nonatomic)AVPlayer *myPlayer;//播放器
@property (strong, nonatomic)AVPlayerItem *item;//播放单元
@property (strong, nonatomic)AVPlayerLayer *playerLayer;//播放界面（layer
@property (nonatomic,assign) int type;  // 0  图片，  1  视频和图片混合
@property (nonatomic,strong) TSVideoPlayback *video;

@end

@implementation ShopDetailVC

#pragma mark --- lifecylce
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    nav = [self layoutNaviBarViewWithTitle:@"商品详情"];
    
    int iBtnTopY = IS_IPHONE_X_MORE? 50:30;
    UIButton *btnHome = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 -30 - 25, iBtnTopY, 30, 30)];
    [nav addSubview:btnHome];
    [btnHome setImage:[UIImage imageNamed:@"com_home2"] forState:UIControlStateNormal];
    [btnHome addTarget:self action:@selector(actionHome) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *btnShare = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 -30, iBtnTopY, 30, 30)];
    [nav addSubview:btnShare];
    [btnShare setImage:[UIImage imageNamed:@"com_share2"] forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(actionShare) forControlEvents:UIControlEventTouchUpInside];
    
    [self initData];
    
    [self getDataFromWeb];
    
    // 购物车需要更新的通知函数 注册
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDateCartCount:) name:DDGCartUpdateNotification object:nil];
    
    // 滚到详情页面的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoInfo) name:DDGGotoInfoNotification object:nil];
    
    
}

-(void) initData
{
    arrTopIMG = [[NSMutableArray alloc] init];
    arrTailIMG = [[NSMutableArray alloc] init];
    
    activityList = [[NSMutableArray alloc] init];
    
    arrSku = nil;
    arrSkuShow = nil;
    
    iTailViewTopY = 0;
    
    isFavorite = false;
    
    qrcodeUrl = @"";
    
    userCommCount = 0;
    goodsRate = @"";
}

//清除缓存必须写
-(void)dealloc
{
    [self.video clearCache];
}

#pragma mark  ---   布局UI
-(void) layoutUI:(NSDictionary*) dicUI
{
    int iTopY = 40;
    iTopY = 0;//NavHeight;
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    //scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, iTopY, SCREEN_WIDTH, SCREEN_HEIGHT- NavHeight - 60 )];
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, iTopY, SCREEN_WIDTH, SCREEN_HEIGHT - 60 )];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 2000);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.delegate = self;
    scView.backgroundColor = [UIColor whiteColor];//[ResourceManager viewBackgroundColor];
    
    // 布局头部banner
    [self initialControlUnit:dicUI];
    
    // 布局头部返回， 并布局滚动时的头部
    [self layoutHead];
    
    // 布局底部的tabbar
    [self layoutTabber];
    
    
    NSDictionary *dicBaseGoods = dicUI[@"baseGoods"];
    if(!dicBaseGoods ||
       [dicBaseGoods count] == 0)
     {
        return;
     }
    
    
    // 设置标题
    iTopY =  BannerHeight + 10;
    int iLeftX = 15;
    UILabel *lableTitle = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 25)];
    [scView addSubview:lableTitle];
    lableTitle.font = [UIFont systemFontOfSize:16];
    lableTitle.textColor = [ResourceManager color_1];
    lableTitle.text = dicBaseGoods[@"goodsName"];
    
    // 设置副标题
    iTopY += lableTitle.height + 10;
    UILabel *lableSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 15)];
    [scView addSubview:lableSubTitle];
    lableSubTitle.font = [UIFont systemFontOfSize:12];
    lableSubTitle.textColor = [ResourceManager midGrayColor];
    lableSubTitle.text = dicBaseGoods[@"goodsSubName"];
    
    // 设置价格
    iTopY += lableSubTitle.height + 10;
    int iPriceHeight = 25;
    UILabel *labelFH =  [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY+1, 10, iPriceHeight)];
    [scView addSubview:labelFH];
    labelFH.font = [UIFont systemFontOfSize:18];
    labelFH.textColor = ShopRedColor;
    labelFH.text = @"¥";
    
    UILabel *lablePrice = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+15, iTopY, SCREEN_WIDTH - 2*iLeftX, iPriceHeight)];
    [scView addSubview:lablePrice];
    lablePrice.font = [UIFont systemFontOfSize:iPriceHeight];
    lablePrice.textColor = ShopRedColor;
    //lablePrice.text = dicBaseGoods[@"goodsSubName"];
    
    NSString *strMinPrice = [NSString stringWithFormat:@"%@", [ToolsUtlis getnumber:dicBaseGoods[@"minPrice"]]];
    NSString *strMaxPrice = [NSString stringWithFormat:@"%@", [ToolsUtlis getnumber:dicBaseGoods[@"maxPrice"]]];
    if ([strMinPrice isEqualToString:strMaxPrice])
     {
        lablePrice.text = [NSString stringWithFormat:@"%@",strMinPrice];
     }
    else
     {
        lablePrice.text = [NSString stringWithFormat:@"%@-%@",strMinPrice,strMaxPrice];
     }
    
    
    iTopY += lablePrice.height +10;
    
    //设置原价
    id  marketPrice =  dicBaseGoods[@"marketPrice"];
    //NSString *strMarketPrice = [NSString stringWithFormat:@"¥%@",dicBaseGoods[@"marketPrice"]];
    NSString *strMarketPrice = [NSString stringWithFormat:@"¥%@",[ToolsUtlis getnumber:marketPrice]];
    if (marketPrice &&
        ![strMarketPrice isEqualToString:@"¥0"])
     {
        iTopY -= 5;
        
        UILabel *labelMarketPrice = [[UILabel alloc]  initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 20)];
        [scView addSubview:labelMarketPrice];
        labelMarketPrice.font = [UIFont systemFontOfSize:17];
        labelMarketPrice.textColor = [ResourceManager midGrayColor];
        
        //下划线
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:strMarketPrice attributes:attribtDic];
        labelMarketPrice.attributedText = attribtStr;

        iTopY += labelMarketPrice.height + 10;
     }
    
    // 设置分割线
    UIView *viewFG1 = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY-1, SCREEN_WIDTH - 2*iLeftX, 1)];
    [scView addSubview:viewFG1];
    viewFG1.backgroundColor = [ResourceManager color_5];
    
    // 设置包邮的价格
    iTopY += 10;
    UILabel *labelBY = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY+3, 31, 15)];
    [scView addSubview:labelBY];
    labelBY.layer.masksToBounds = YES;
    labelBY.layer.cornerRadius = 3;
    labelBY.backgroundColor = [ResourceManager mainColor];
    labelBY.font = [UIFont systemFontOfSize:10];
    labelBY.textColor = [UIColor whiteColor];
    labelBY.text = @"  包邮";

    UILabel *labelBYJG = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + 35, iTopY, 200, 20)];
    [scView addSubview:labelBYJG];
    labelBYJG.textColor = [ResourceManager color_1];
    labelBYJG.font = [UIFont systemFontOfSize:15];
    labelBYJG.text =  [NSString stringWithFormat:@"满%@元包邮", dicUI[@"maxPostFree"]];
    
    // 分割块
    iTopY += labelBY.height + 15;
    UIView *viewFGK1 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 10)];
    [scView addSubview:viewFGK1];
    viewFGK1.backgroundColor = [ResourceManager viewBackgroundColor];
    
    // 优惠布局
    iTopY += viewFGK1.height + 10;
    UILabel *labelYHTitle = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY+1, 40, 20)];
    [scView addSubview:labelYHTitle];
    labelYHTitle.textColor = [ResourceManager midGrayColor];
    labelYHTitle.font = [UIFont systemFontOfSize:13];
    labelYHTitle.text = @"优惠:";
    
    if (activityList.count > 0)
     {
        iLeftX = 15 + 40;
        for (int i = 0; i < activityList.count; i++)
         {
            NSLog(@"SCREEN_WIDTH:%f",SCREEN_WIDTH);
            
            NSString *strYHHD = activityList[i];
            int iWidth =  [ToolsUtlis getSizeWithString:strYHHD withFrame:CGRectMake(0, 0, SCREEN_WIDTH - 15 + 40 - 30, 20) withFontSize:14].width + 10;
            
            if ( (iLeftX + iWidth ) >  SCREEN_WIDTH)
             {
                iLeftX = 15 + 40;
                iTopY += 25;
             }
            
            UILabel *labelYHHD = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY , iWidth, 20)];
            [scView addSubview:labelYHHD];
            labelYHHD.backgroundColor = [ResourceManager priceColor];
            labelYHHD.textColor = [UIColor whiteColor];
            labelYHHD.font = [UIFont systemFontOfSize:13];
            labelYHHD.textAlignment = NSTextAlignmentCenter;
            labelYHHD.text = strYHHD;
            
            iLeftX += iWidth + 10;
         }
        
        iTopY += 25;
     }
    
    iLeftX = 15 + 40;
    UILabel *labelYH = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY+3, 31, 15)];
    [scView addSubview:labelYH];
    //labelYH.layer.masksToBounds = YES;
    labelYH.layer.cornerRadius = 3;
    labelYH.borderColor = ShopRedColor;
    labelYH.borderWidth = 1;
    //labelYH.backgroundColor = [ResourceManager mainColor];
    labelYH.font = [UIFont systemFontOfSize:10];
    labelYH.textColor = ShopRedColor;
    labelYH.text = @"  积分";
    
    UILabel *labelGMJG = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX + 35, iTopY, 200, 20)];
    [scView addSubview:labelGMJG];
    labelGMJG.textColor = [ResourceManager color_1];
    labelGMJG.font = [UIFont systemFontOfSize:15];
    labelGMJG.text =  [NSString stringWithFormat:@"购买可得%d积分",  [dicBaseGoods[@"maxPrice"] intValue]];
    

//    UIImageView *imgRight1 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20, iTopY+3, 10, 15)];
//    [scView addSubview:imgRight1];
//    imgRight1.image = [UIImage imageNamed:@"arrow_right"];
    
    UIButton *btnYH = [[UIButton alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [scView addSubview:btnYH];
    //btnYH.backgroundColor = [UIColor blueColor];
    [btnYH addTarget:self action:@selector(actionYHSM) forControlEvents:UIControlEventTouchUpInside];
    
    // 分割块
    iTopY += labelGMJG.height + 10;
    UIView *viewFGK2 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 10)];
    [scView addSubview:viewFGK2];
    viewFGK2.backgroundColor = [ResourceManager viewBackgroundColor];
    
    // 已选布局
    iTopY += viewFGK1.height + 10;
    iLeftX = 15;
    UILabel *labelYXTitle = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY+1, 150, 20)];
    [scView addSubview:labelYXTitle];
    labelYXTitle.textColor = [ResourceManager color_1];
    labelYXTitle.font = [UIFont systemFontOfSize:13];
    labelYXTitle.text = @"请选择规格和数量";
    iLeftX += 40;
    UILabel *labelYX = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - iLeftX - 20, 20)];
    [scView addSubview:labelYX];
    //labelYX.backgroundColor = [UIColor yellowColor];
    labelYX.textColor = [ResourceManager color_1];
    labelYX.font = [UIFont systemFontOfSize:15];
    labelYX.text = @""; //[NSString stringWithFormat:@"购买可得%d积分",  [dicBaseGoods[@"maxPrice"] intValue]];
    
    UIImageView *imgRight2 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20, iTopY+3, 10, 15)];
    [scView addSubview:imgRight2];
    imgRight2.image = [UIImage imageNamed:@"arrow_right"];
    
    UIButton *btnSelModel = [[UIButton alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [scView addSubview:btnSelModel];
    //btnYH.backgroundColor = [UIColor blueColor];
    [btnSelModel addTarget:self action:@selector(actionSelModel) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 分割块
    iTopY += labelYX.height + 10;
    UIView *viewFGK3 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 10)];
    [scView addSubview:viewFGK3];
    viewFGK3.backgroundColor = [ResourceManager viewBackgroundColor];
    
    
    // 已选布局
    iTopY += viewFGK3.height + 10;
    iLeftX = 15;
    UILabel *labelSMTitle = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY+1, 40, 20)];
    [scView addSubview:labelSMTitle];
    labelSMTitle.textColor = [ResourceManager midGrayColor];
    labelSMTitle.font = [UIFont systemFontOfSize:13];
    labelSMTitle.text = @"说明:";
    iLeftX += 40;
    
    UIImageView *imgSM = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 20, 20)];
    [scView addSubview:imgSM];
    imgSM.image = [UIImage imageNamed:@"com_gou2"];
    
    iLeftX += imgSM.width + 5;
    UILabel *labelSM = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - iLeftX - 20, 20)];
    [scView addSubview:labelSM];
    //labelYX.backgroundColor = [UIColor yellowColor];
    labelSM.textColor = [ResourceManager color_1];
    labelSM.font = [UIFont systemFontOfSize:15];
    labelSM.text =  [NSString stringWithFormat:@"支持%d天无理由退货",  7];
    
    
    UIImageView *imgRight3 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20, iTopY+3, 10, 15)];
    [scView addSubview:imgRight3];
    imgRight3.image = [UIImage imageNamed:@"arrow_right"];
    
    UIButton *btnShuoMing = [[UIButton alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 20)];
    [scView addSubview:btnShuoMing];
    //btnYH.backgroundColor = [UIColor blueColor];
    [btnShuoMing addTarget:self action:@selector(actionShuoMing) forControlEvents:UIControlEventTouchUpInside];
    
    // 分割块
    iTopY += labelSM.height + 10;
    UIView *viewFGK4 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 10)];
    [scView addSubview:viewFGK4];
    viewFGK4.backgroundColor = [ResourceManager viewBackgroundColor];

    
    
    iTopY += 10;
    // 给底部的详情图片，分配顶部左边
    iTailViewTopY = iTopY;
    
    scView.contentSize = CGSizeMake(0, iTopY);
    //[self layoutTailJPG:dicUI atTop:iTopY];
    
    [self layoutShareUI];
    
    // 需要刷新购物车下标
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGCartNeedCountNotification object:nil];
    
}

-(void) layoutHead
{
    
    // 布局头部返回按钮 !!!!!!!!!!!!!!!!!
    int iBtnTopY =  IS_IPHONE_X_MORE? 40:20;
    UIButton *btnBack = [[UIButton alloc] initWithFrame:CGRectMake(15, iBtnTopY, 30, 30)];
    [scView addSubview:btnBack];
    [btnBack setImage:[UIImage imageNamed:@"com_back"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(actionBack) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *btnHome = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 -30 -40, iBtnTopY, 30, 30)];
    [scView addSubview:btnHome];
    [btnHome setImage:[UIImage imageNamed:@"com_home"] forState:UIControlStateNormal];
    [btnHome addTarget:self action:@selector(actionHome) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btnShare = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 10 -30, iBtnTopY, 30, 30)];
    [scView addSubview:btnShare];
    [btnShare setImage:[UIImage imageNamed:@"com_share"] forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(actionShare) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:nav];
    //nav.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
    nav.hidden = YES;
    
}

-(void)initialControlUnit:(NSDictionary*) dicUI
{
    
    NSArray *arrMediaList  = dicUI[@"mediaList"];
    iTopType = 0;
    [arrTopIMG removeAllObjects];
    if (arrMediaList &&
        [arrMediaList count] > 0)
     {
        for (int i = 0; i < [arrMediaList count]; i++)
         {
            NSDictionary *dicObj = arrMediaList[i];
            NSString *strImgUrl = dicObj[@"imgUrl"];
            if (i == 0)
             {
                iTopType = [dicObj[@"mediaType"] intValue];
             }
            
            [arrTopIMG addObject:strImgUrl];
         }
     }
    
    
    self.video = [[TSVideoPlayback alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BannerHeight) ];
    self.video.delegate = self;
    self.type = iTopType;
    self.video.parentVC = self;
    if (self.type == 0)
     {
        //self.title = @"纯图片详情";
        //[self.video setWithIsVideo:TSDETAILTYPEIMAGE andDataArray:[self imgArray]];
        [self.video setWithIsVideo:TSDETAILTYPEIMAGE andDataArray:arrTopIMG];
     }
    else
     {
        //self.title = @"视频图片详情";
        //[self.video setWithIsVideo:TSDETAILTYPEVIDEO andDataArray:[self bannerArray]];
        [self.video setWithIsVideo:TSDETAILTYPEVIDEO andDataArray:arrTopIMG];
     }
    [scView addSubview:self.video];
    
    int iLabelYXJWidth = 90;
    UILabel *labelYXJ = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-iLabelYXJWidth)/2, (BannerHeight-iLabelYXJWidth)/2, iLabelYXJWidth, iLabelYXJWidth)];
    [scView addSubview:labelYXJ];
    labelYXJ.clipsToBounds = YES;
    labelYXJ.layer.cornerRadius = labelYXJ.height/2;
    labelYXJ.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    labelYXJ.textAlignment = NSTextAlignmentCenter;
    labelYXJ.text = @"已经下架";
    labelYXJ.textColor = [UIColor whiteColor];
    labelYXJ.hidden = YES;
    
    // 0 saleStatus  已下架 1 出售中
    if (0 ==  _shopModel.iSaleStatus)
     {
        labelYXJ.hidden = NO;
     }
    

}

-(NSArray *)bannerArray
{
    return @[
             @"http://img.ptocool.com/video/2018-06-30_RGq4iDnu.mov",
             @"http://img.ptocool.com/3332-1518523974126-29",
             @"http://img.ptocool.com/3332-1518523974125-28",
             @"http://img.ptocool.com/3332-1518523974125-27",
             @"http://img.ptocool.com/3332-1518523974124-26"];
}
-(NSArray *)imgArray
{
    return @[
             @"http://img.ptocool.com/3332-1518523974126-29",
             @"http://img.ptocool.com/3332-1518523974125-28",
             @"http://img.ptocool.com/3332-1518523974125-27",
             @"http://img.ptocool.com/3332-1518523974124-26"];
}


-(void) layoutTailJPG:(NSDictionary *)dicUI   atTop:(int)iCurTop
{
     __block int  iTopY = iCurTop;
    __block  NSMutableArray *_bArrImg = arrTailIMG;
    __block  UIScrollView *_bSCView = scView;
    
    
    
    userCommCount = [dicUI[@"userCommCount"]  intValue];
    if (userCommCount > 0)
     {
        // 有用户评论， 开始画 评论UI
        iTopY += 10;
        int iLeftX = 15;
        UILabel *labelPL = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 200, 20)];
        [scView addSubview:labelPL];
        labelPL.text = [NSString stringWithFormat:@"用户评论(%d)",userCommCount];
        labelPL.textColor = [ResourceManager color_1];
        labelPL.font = [UIFont systemFontOfSize:14];
        
        
        UIImageView *imgRight2 = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 20, iTopY+3, 10, 15)];
        [scView addSubview:imgRight2];
        imgRight2.image = [UIImage imageNamed:@"arrow_right"];
        
        
        goodsRate = dicUI[@"goodsRate"];
        UILabel *labelMYD = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 200, iTopY, 175, 20)];
        [scView addSubview:labelMYD];
        labelMYD.textAlignment = NSTextAlignmentRight;
        labelMYD.textColor = [ResourceManager mainColor];
        labelMYD.font = [UIFont systemFontOfSize:14];
        labelMYD.text = goodsRate;
        
        // 加入分割线
        iTopY += labelPL.height + 10;
        UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 1)];
        [scView addSubview:viewFG];
        viewFG.backgroundColor = [ResourceManager color_5];
        
        
        // 第一条评论的信息
        NSDictionary  *dicGoodsComm = dicUI[@"goodsCommList"];
        if (dicGoodsComm)
         {
            // 头像
            iTopY += 10;
            UIImageView *imgHead = [[UIImageView alloc]  initWithFrame:CGRectMake(iLeftX, iTopY, 35, 35)];
            [scView addSubview:imgHead];
            imgHead.layer.masksToBounds = YES;
            imgHead.layer.cornerRadius = imgHead.height/2;
            NSString *strHeadUrl = dicGoodsComm[@"headImgUrl"];
            [imgHead sd_setImageWithURL:[NSURL URLWithString:strHeadUrl] placeholderImage:[UIImage imageNamed:@"Tab_4-2"]];
            
            iLeftX += imgHead.width + 10;
            UILabel *labelName = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY+10, 200, 15)];
            [scView addSubview:labelName];
            labelName.textColor = [ResourceManager color_1];
            labelName.font = [UIFont systemFontOfSize:14];
            labelName.text = dicGoodsComm[@"nickName"];
            [labelName sizeToFit];
            
            iLeftX += labelName.width + 10;
            int goodsGrade = [dicGoodsComm[@"goodsGrade"] intValue];
            for (int i = 0; i < goodsGrade; i++)
             {
                UIImageView  *imgStar = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY+13, 10, 10)];
                [scView addSubview:imgStar];
                imgStar.image = [UIImage imageNamed:@"Tab_4-37"];
                
                iLeftX += imgStar.width + 5;
             }
            
            // 日期
            iLeftX = 15;
            iTopY += imgHead.height + 7;
            UILabel *labelDate = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - iLeftX - 10, 12)];
            [scView addSubview:labelDate];
            labelMYD.textAlignment = NSTextAlignmentRight;
            labelDate.textColor = [ResourceManager lightGrayColor];
            labelDate.font = [UIFont systemFontOfSize:10];
            labelDate.text = [NSString stringWithFormat:@"%@   %@", dicGoodsComm[@"createTime"], dicGoodsComm[@"skuDesc"]];
            
            // 评论
            iTopY += labelDate.height + 10;
            UILabel *labelComm = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX , 100)];
            [scView addSubview:labelComm];
            labelComm.textColor = [ResourceManager color_1];
            labelComm.font = [UIFont systemFontOfSize:14];
            labelComm.numberOfLines = 0;
            labelComm.text = dicGoodsComm[@"commentText"];
            [labelComm sizeToFit];
            
            iTopY += labelComm.height +10;
            
            // 加入图片
            NSString *imgUrl = dicGoodsComm[@"imgUrl"];
            if (imgUrl &&
                imgUrl.length > 0)
             {
                NSArray *arrImg = [imgUrl componentsSeparatedByString:@","];
                if (arrImg &&
                    arrImg.count > 0)
                 {
                    int iImgWidth = (SCREEN_WIDTH - 2*iLeftX - 4*10)/5;
                    // 设置图片的顶点高度
                    iTopY += labelDate.height + 10;
                    
                    for (int i = 0; i < arrImg.count; i++)
                     {
                        UIImageView *imgJpg = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iImgWidth, iImgWidth)];
                        [scView addSubview:imgJpg];
                        [imgJpg sd_setImageWithURL:[NSURL URLWithString:arrImg[i]]];
                        imgJpg.backgroundColor = [UIColor yellowColor];
                        
                        iLeftX += iImgWidth +10;
                     }
                    // 设置评论控件的当前高度(加上图片的高度)
                    iTopY += iImgWidth +10;
                 }
             }
            
         }
        
        
        
        UIButton *btnShowPL = [[UIButton alloc] initWithFrame:CGRectMake(0, iCurTop, SCREEN_WIDTH, iTopY - iCurTop)];
        [scView addSubview:btnShowPL];
        [btnShowPL addTarget:self action:@selector(actionShowPL) forControlEvents:UIControlEventTouchUpInside];
        
        // 分割块
        UIView *viewFGK4 = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 10)];
        [scView addSubview:viewFGK4];
        viewFGK4.backgroundColor = [ResourceManager viewBackgroundColor];
        
        iTopY += viewFGK4.height;
        
     }
    
    NSDictionary *detailGoods = dicUI[@"detailGoods"];
    NSArray *arrImgList = detailGoods[@"imageList"];
    arrDetailJpgUrl = arrImgList;
    
    if (!arrImgList ||
        0 == [arrImgList count])
     {
        scView.contentSize = CGSizeMake(0, iTopY);
        return;
     }
    
    scView.contentSize = CGSizeMake(0, iTopY+300);
    __block  UIView *viewShowLoad = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, iTopY, SCREEN_WIDTH/2, 200)];
    [scView addSubview:viewShowLoad];
    [MBProgressHUD showWithStatus:@"正在加载图片" toView:viewShowLoad];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 线程中国中 加载图片
        for (int i = 0; i < [arrImgList count]; i++)
         {
            NSDictionary *dicObj = arrImgList[i];
            NSString *strImgUrl = dicObj[@"url"];
            
            // 异步方式加载图片
            UIImage *imgTemp =  [ToolsUtlis getImgFromStr:strImgUrl];
            
            if (imgTemp)
             {
                
                CGFloat fixelH = CGImageGetHeight(imgTemp.CGImage);
                //CGFloat fixelW = CGImageGetWidth(imgTemp.CGImage);
                float fImgHeight = fixelH *FixelScaleSize*ScaleSize;
                //float fImgWidth = fixelW *FixelScaleSize*ScaleSize;
                
                [_bArrImg addObject:@(fImgHeight)];
                
             }
            else
             {
                [_bArrImg addObject:@(0)];
             }
            
            
         }
        
        
        //跳回主队列执行
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // 必须在主线程中隐藏 加载动画
            [MBProgressHUD hideHUDForView:viewShowLoad animated:YES];
            
            for (int i = 0; i < [arrImgList count]; i++)
             {
                NSDictionary *dicObj = arrImgList[i];
                NSString *strImgUrl = dicObj[@"url"];
                float  fImgHeight =  [_bArrImg[i] floatValue];
                
                UIImageView *imgViewTemp = [[UIImageView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, fImgHeight)];
                [_bSCView addSubview:imgViewTemp];
                [imgViewTemp sd_setImageWithURL:[NSURL URLWithString:strImgUrl]];
                imgViewTemp.tag = i;
                
                iTopY += imgViewTemp.height;
                
                imgViewTemp.userInteractionEnabled = YES;
                UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionDetailJPG:)];
                gesture.numberOfTapsRequired  = 1;
                [imgViewTemp addGestureRecognizer:gesture];
                
                _bSCView.contentSize = CGSizeMake(0, iTopY);
             }

            
        });
        
        
        
        
    });
            
            

        
    
    
    //scView.contentSize = CGSizeMake(0, iTopY);
    
}

-(void) layoutTabber
{
    int iTopY = SCREEN_HEIGHT - 60;
    UIView *viewTabber = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 60)];
    [self.view addSubview:viewTabber];
    //viewTabber.backgroundColor = [UIColor yellowColor];
    
    iTopY = 0;
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    [viewTabber addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager color_5];
    
    
    NSArray *arrTitle =  @[@"客 服",@"收 藏",@"购物车"];
    NSArray *arrImg =  @[@"Shop_kf",@"Shop_shoucang",@"Shop_che"];
    
    if (isFavorite)
     {
        arrImg =  @[@"Shop_kf",@"Shop_shoucang2",@"Shop_che"];
     }
    
    int iLeftX = 12;
    int iIcomBtnWidth = 40;
    iTopY = 13;
    for (int i = 0; i < [arrTitle count]; i++)
     {
        UIImageView *imgKF = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 18, 18)];
        [viewTabber addSubview:imgKF];
        imgKF.image = [UIImage imageNamed:arrImg[i]];
        
        // 购物车数量
        if (2 == i)
         {
            labelCartNum = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX+10, iTopY-5, 15, 15)];
            [viewTabber addSubview:labelCartNum];
            labelCartNum.layer.masksToBounds = YES;
            labelCartNum.layer.cornerRadius = labelCartNum.height/2;
            labelCartNum.backgroundColor = [ResourceManager priceColor];
            labelCartNum.textColor = [UIColor whiteColor];
            labelCartNum.font = [UIFont systemFontOfSize:8];
            labelCartNum.textAlignment = NSTextAlignmentCenter;
            labelCartNum.hidden = YES;
            
         }
        
        // 收藏图标 赋值
        if (1 == i)
         {
            imgShouCang = imgKF;
         }
        
        UILabel *labelKF = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX - 10 , iTopY + 20, 40 , 15)];
        [viewTabber addSubview:labelKF];
        //labelKF.backgroundColor = [UIColor blueColor];
        labelKF.font = [UIFont systemFontOfSize:11];
        labelKF.textAlignment = NSTextAlignmentCenter;
        labelKF.textColor = [ResourceManager color_1];
        labelKF.text = arrTitle[i];
        
        UIButton *btnTemp = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX - 10, iTopY, 33, 40)];
        [viewTabber addSubview:btnTemp];
        //btnTemp.backgroundColor = [UIColor blueColor];
        btnTemp.tag = i;
        [btnTemp addTarget:self action:@selector(actionBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        iLeftX +=  iIcomBtnWidth;//36;
        
     }
    
    
    int iSaleStatus = _shopModel.iSaleStatus; // // 0 saleStatus  已下架 1 出售中
    if (iSaleStatus == 0)
     {
        int iBtnWidth =  (SCREEN_WIDTH - iLeftX  - 10);
        UIButton *btnSellOut = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, 10, iBtnWidth, 40)];
        [viewTabber addSubview:btnSellOut];
        btnSellOut.cornerRadius = btnSellOut.height/2;
        btnSellOut.backgroundColor = [ResourceManager lightGrayColor];
        [btnSellOut setTitle:@"已经下架" forState:UIControlStateNormal];
        [btnSellOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnSellOut.titleLabel.font = [UIFont systemFontOfSize:15];
        return;
     }
    
    int iIsSellOut = _shopModel.iIsSellOut; //  "isSellOut": 0 代表售罄 1代表尚有库存
    if (iIsSellOut == 0)
     {
        int iBtnWidth =  (SCREEN_WIDTH - iLeftX  - 10);
        UIButton *btnSellOut = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, 10, iBtnWidth, 40)];
        [viewTabber addSubview:btnSellOut];
        btnSellOut.cornerRadius = btnSellOut.height/2;
        btnSellOut.backgroundColor = [ResourceManager lightGrayColor];
        [btnSellOut setTitle:@"已经售罄" forState:UIControlStateNormal];
        [btnSellOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnSellOut.titleLabel.font = [UIFont systemFontOfSize:15];
     }
    else
     {
        int iBtnWidth =  (SCREEN_WIDTH - iLeftX  - 2*10) /2;
        UIButton *btnLJGM = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, 10, iBtnWidth, 40)];
        [viewTabber addSubview:btnLJGM];
        btnLJGM.layer.borderColor = [ResourceManager mainColor].CGColor;
        btnLJGM.layer.borderWidth = 1;
        btnLJGM.cornerRadius = btnLJGM.height/2;
        [btnLJGM setTitle:@"购买" forState:UIControlStateNormal];
        [btnLJGM setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
        btnLJGM.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnLJGM addTarget:self action:@selector(actionLJGM) forControlEvents:UIControlEventTouchUpInside];
        
        iLeftX += iBtnWidth + 10;
        UIButton *btnJRGWC = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, 10, iBtnWidth, 40)];
        [viewTabber addSubview:btnJRGWC];
        //btnLJGM.layer.borderColor = [ResourceManager mainColor].CGColor;
        //btnLJGM.layer.borderWidth = 1;
        btnJRGWC.cornerRadius = btnJRGWC.height/2;
        btnJRGWC.backgroundColor = ShopRedColor;
        [btnJRGWC setTitle:@"分享" forState:UIControlStateNormal];
        [btnJRGWC setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnJRGWC.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnJRGWC addTarget:self action:@selector(actionShare) forControlEvents:UIControlEventTouchUpInside];
     }
    
    
    
    
}


#pragma mark ---- 布局分享按钮
-(void) layoutShareUI
{
    int iviewPopShareHeight =  170;
    viewPopShare = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - iviewPopShareHeight, SCREEN_WIDTH, iviewPopShareHeight)];
    viewPopShare.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
    [self.view addSubview:viewPopShare];
    viewPopShare.userInteractionEnabled = YES;
    
    int iTopY = 10;
    
    
    UIColor *color1 =  [UIColor whiteColor];


    int iIMGWdith = 50;
    int iViewWdith = SCREEN_WIDTH/3;
    int iLeftX = SCREEN_WIDTH/ (3 *2);
    
    // 微信图片和按钮
    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iViewWdith, 100)];
    [viewPopShare addSubview:view1];
    
    UIImageView *imag1 = [[UIImageView alloc] initWithFrame:CGRectMake((iViewWdith-iIMGWdith)/2, 20, iIMGWdith, iIMGWdith)];
    [view1 addSubview:imag1];
    imag1.image = [UIImage imageNamed:@"com_wechat"];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20+iIMGWdith, iViewWdith, 20)];
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = color1;
    label1.text = @"微信";
    label1.textAlignment = NSTextAlignmentCenter;
    [view1 addSubview:label1];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionWeChat)];
    [view1 addGestureRecognizer:singleTap];
    
    // 朋友圈图片和按钮
    UIView * view2 = [[UIView alloc] initWithFrame:CGRectMake(iLeftX + iViewWdith, iTopY, iViewWdith, 100)];
    [viewPopShare addSubview:view2];
    
    UIImageView *imag2 = [[UIImageView alloc] initWithFrame:CGRectMake((iViewWdith-iIMGWdith)/2, 20, iIMGWdith, iIMGWdith)];
    [view2 addSubview:imag2];
    imag2.image = [UIImage imageNamed:@"com_wepyq"];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20+iIMGWdith, iViewWdith, 20)];
    label2.font = [UIFont systemFontOfSize:12];
    label2.textColor = color1;
    label2.text = @"朋友圈";
    label2.textAlignment = NSTextAlignmentCenter;
    [view2 addSubview:label2];
    
    UITapGestureRecognizer* singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionWePYQ)];
    [view2 addGestureRecognizer:singleTap2];
    
    
    //    // 保存到本地图片和按钮
    //    UIView * view3 = [[UIView alloc] initWithFrame:CGRectMake(iViewWdith*2, iTopY, iViewWdith, 100)];
    //    [viewPopShare addSubview:view3];
    //
    //    UIImageView *imag3 = [[UIImageView alloc] initWithFrame:CGRectMake((iViewWdith-iIMGWdith)/2, 30, iIMGWdith, iIMGWdith)];
    //    [view3 addSubview:imag3];
    //    imag3.image = [UIImage imageNamed:@"com_save"];
    //
    //    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30+iIMGWdith, iViewWdith, 20)];
    //    label3.font = [UIFont systemFontOfSize:12];
    //    label3.textColor = color1;
    //    label3.text = @"保存到本地";
    //    label3.textAlignment = NSTextAlignmentCenter;
    //    [view3 addSubview:label3];
    //
    //    UITapGestureRecognizer* singleTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sharSave)];
    //    [view3 addGestureRecognizer:singleTap3];
    
    // 取消按钮
    iTopY += view1.height + 5;

    iLeftX = (SCREEN_WIDTH - 30)/2;
    UIButton * btnBack = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 30, 30)];
    [viewPopShare addSubview:btnBack];
    [btnBack setImage:[UIImage imageNamed:@"com_colse3"] forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
    
    
    viewPopShare.hidden = YES;
}


//
-(UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0, 0, 1.0f, 1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 开启上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(ref, color.CGColor);
    // 渲染上下文
    CGContextFillRect(ref, rect);
    // 从上下文中获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark --- 网络通讯
-(void) getDataFromWeb
{
    [self queryGoodsBaseInfo];
    
    [self queryGoodsDetailInfo];
    
    [self querySkuProList];

    [self querySkuList];

    [self getShareQrcode];

}


// 获取商品基本信息
-(void) queryGoodsBaseInfo
{
    [MBProgressHUD showHUDAddedTo:self.view];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"goodsCode"] = _shopModel.strGoodsCode;
    params[@"est"] = _est;
    params[@"esi"] = _esi;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLqueryGoodsBaseInfo];
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

// 获取商品附加信息
-(void) queryGoodsDetailInfo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"goodsCode"] = _shopModel.strGoodsCode;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLqueryGoodsDetailInfo];
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

// 查询商品SKU展示规格列表 （展示）
-(void) querySkuProList
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"goodsCode"] = _shopModel.strGoodsCode;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLquerySkuProList];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 1002;
    [operation start];
}




// 查询商品SKU所有列表
-(void) querySkuList
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"goodsCode"] = _shopModel.strGoodsCode;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLquerySkuList];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 1003;
    [operation start];
}

// 添加收藏
-(void) addFavorite
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"goodsCode"] = _shopModel.strGoodsCode;
    
    //状态status参数， 添加收藏 status = 1   取消就是 status=0
    if (!isFavorite)
     {
        params[@"status"] = @(1);
     }
    else
     {
        params[@"status"] = @(0);
     }
    
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLaddFavorite];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    if (!isFavorite)
     {
        operation.tag = 1005;
     }
    else
     {
        operation.tag = 1006;
     }
    [operation start];
}


// 得到商品的分享的图片 （带二维码）
-(void) getShareQrcode
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"goodsCode"] = _shopModel.strGoodsCode;
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLgetShareQrcode];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 1007;
    //[operation start];
    
    
    qrcodeUrl = [operation.URL absoluteString];
}





-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    
    if (operation.tag == 1000)
     {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *dicUI = operation.jsonResult.attr;
        if (!dicUI)
         {
            [MBProgressHUD showErrorWithStatus:@"服务器忙，请稍后" toView:self.view];
            return;
         }
        
        isFavorite = [dicUI[@"isFavorite"] boolValue];
        maxPostFree = [dicUI[@"maxPostFree"] intValue];
        
        NSArray *arrActivity = dicUI[@"activityList"];
        
        if ([arrActivity isKindOfClass:[NSArray class]] &&
            arrActivity.count > 0)
         {
            [activityList removeAllObjects];
            for (int i = 0; i < arrActivity.count; i++)
             {
                NSString *strTile = arrActivity[i][@"title"];
                if (strTile)
                 {
                    NSLog(@"strTile:%@",strTile);
                    [activityList addObject:strTile];
                 }
             }
         }
        
        // 必须这样赋值一遍，外面传入参数有可能不完整，只传入了goodsCode
        NSDictionary *baseGoods = dicUI[@"baseGoods"];
        if (baseGoods &&
            [baseGoods count] > 0)
         {
            NSDictionary *dicObject = baseGoods;
            ShopModel *sModel = [[ShopModel alloc] init];

            sModel.strGoodsImgUrl =  [NSString stringWithFormat:@"%@",dicObject[@"imgUrl"]];
            sModel.strMinPrice = [NSString stringWithFormat:@"%@",[ToolsUtlis getnumber:dicObject[@"minPrice"]]];
            sModel.strMaxPrice = [NSString stringWithFormat:@"%@",[ToolsUtlis getnumber:dicObject[@"maxPrice"]]];
            sModel.strGoodsCode = [NSString stringWithFormat:@"%@",dicObject[@"goodsCode"]];
            sModel.strGoodsName = [NSString stringWithFormat:@"%@",dicObject[@"goodsName"]];
            sModel.strGoodsSubName = [NSString stringWithFormat:@"%@",dicObject[@"goodsSubName"]];
            sModel.strCateCode = [NSString stringWithFormat:@"%@",dicObject[@"cateCode"]];
            sModel.strCateName = [NSString stringWithFormat:@"%@",dicObject[@"cateName"]];
            sModel.iIsSellOut = [dicObject[@"isSellOut"] intValue];
            sModel.iSaleStatus = [dicObject[@"saleStatus"] intValue];
            _shopModel = sModel;
         }
        
        [self layoutUI:dicUI];

     }
    else if (operation.tag == 1001)
     {
        
        NSDictionary *dicTemp = operation.jsonResult.attr;
        if (!dicTemp)
         {
            return;
         }
        
        NSDictionary *detailGoods = dicTemp[@"detailGoods"];
        if (!detailGoods)
         {
            return;
         }
        
        if  (iTailViewTopY)
         {
            [self layoutTailJPG:dicTemp atTop:iTailViewTopY];
         }
        else
         {
            [self performSelector:@selector(delayMethod:) withObject:dicTemp afterDelay:2.0];// 延迟执行
         }
    }
    else if (1002 == operation.tag)
     {
        arrSkuShow =  operation.jsonResult.rows;
     }
    else if (1003 == operation.tag)
     {
        arrSku = operation.jsonResult.rows;
     }
    else if (1005 == operation.tag)
     {
        isFavorite = true;
        imgShouCang.image = [UIImage imageNamed:@"Shop_shoucang2"];
        [MBProgressHUD showSuccessWithStatus:@"收藏成功" toView:self.view];
     }
    else if (1006 == operation.tag)
     {
        isFavorite = false;
        imgShouCang.image = [UIImage imageNamed:@"Shop_shoucang"];
        [MBProgressHUD showErrorWithStatus:@"取消收藏" toView:self.view];
     }
    else if (1007 == operation.tag)
     {
        NSDictionary *dic = operation.jsonResult.attr;
        if (dic)
         {
            qrcodeUrl = dic[@"qrcodeUrl"];
         }
     }
    
}

-(void) delayMethod:(NSDictionary*)dic
{
    [self layoutTailJPG:dic atTop:iTailViewTopY];
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    if (1000 == operation.tag ||
        1005 == operation.tag ||
        1006 == operation.tag ||
        1007 == operation.tag)
     {
        [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
     }
}



#pragma mark - delegate
//TSVideoPlaybackDelegate  点击图片或者相片时，相应函数
-(void)videoView:(TSVideoPlayback *)view didSelectItemAtIndexPath:(NSInteger)index
{
    NSLog(@"%ld",(long)index);
    
    if (![CommonInfo isLoggedIn]) {
        [DDGUserInfoEngine engine].parentViewController = self;
        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
        return;
    }
    
    if(iTopType == 1)
     {
        // 有视频时的处理方式
        NSMutableArray *arrTemp = arrTopIMG;
        [arrTemp removeObjectAtIndex:0];

        ShowBannerJpegView  *View = [[ShowBannerJpegView alloc] initWithArrImg:arrTemp  withNo:(int)index];
        View.shopModel = _shopModel;
        [self.view addSubview:View];
     }
    else
     {
        // 纯图片的处理方式
        ShowBannerJpegView  *View = [[ShowBannerJpegView alloc] initWithArrImg:arrTopIMG  withNo:(int)index];
        View.shopModel = _shopModel;
        [self.view addSubview:View];
     }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    if(scrollView.contentOffset.y <= 50) {
        
        nav.hidden = YES;
        
    }else{
        
        nav.hidden = NO;

        CGFloat alpha=  scrollView.contentOffset.y/BannerHeight>1.0f?1:scrollView.contentOffset.y/BannerHeight;
        //把颜色生成图片
        UIColor *alphaColor = [UIColor colorWithWhite:1 alpha:alpha];
        //把颜色生成图片
        //UIImage *alphaImage = [self imageWithColor:alphaColor];
        
        nav.backgroundColor = alphaColor;
        
        //[nav setBackgroundImage:alphaImage forBarMetrics:UIBarMetricsDefault];
        
    }
    
    
}

#pragma mark --- action
-(void) actionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) actionHome
{
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(1),@"index":@(0)}];

}

-(void) actionShare
{
    //viewPopShare.hidden = NO;
    //return;
    
    if (![CommonInfo isLoggedIn]) {
        [DDGUserInfoEngine engine].parentViewController = self;
        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
        return;
    }
    
    if(iTopType == 1)
     {
        // 有视频时的处理方式
        NSMutableArray *arrTemp = arrTopIMG;
        [arrTemp removeObjectAtIndex:0];
        
        ShareShopJpegView  *View = [[ShareShopJpegView alloc] initWithArrImg:arrTemp  withNo:(int)1  withShopModel:_shopModel];
        [self.view addSubview:View];
     }
    else
     {
        // 纯图片的处理方式
        ShareShopJpegView  *View = [[ShareShopJpegView alloc] initWithArrImg:arrTopIMG  withNo:(int)1 withShopModel:_shopModel];
        [self.view addSubview:View];
     }

}

-(void) actionShowPL
{
    NSLog(@"actionShowPL");
    AllAppraiseListViewController  *VC = [[AllAppraiseListViewController alloc] init];
    VC.goodsCode = _shopModel.strGoodsCode;
    [self.navigationController pushViewController:VC animated:YES];
}

-(void) actionCancel
{
    viewPopShare.hidden = YES;
}

-(void) actionWeChat
{
    NSMutableDictionary *parmams = [[NSMutableDictionary alloc] init];
    parmams[@"strUrl"] = [NSString stringWithFormat:@"/pages/product/product?goodsCode=%@&goodsName=%@",_shopModel.strGoodsCode,_shopModel.strGoodsName];
    parmams[@"strImgUrl"] = _shopModel.strGoodsImgUrl;
    parmams[@"strDesc"] = _shopModel.strGoodsName;
    parmams[@"strName"] = _shopModel.strGoodsName;
    
    [[DDGShareManager shareManager] weChatShareXCX:parmams];
    
    [[DDGShareManager  shareManager] setBlock:^(id obj) {
        
        NSDictionary *dic = (NSDictionary *)obj;
        if ([[dic objectForKey:@"success"] boolValue]) {
            [MBProgressHUD showSuccessWithStatus:@"分享成功" toView:self.view];
        }else{
            [MBProgressHUD showErrorWithStatus:@"分享失败" toView:self.view];
        }
    }];
}

-(void) actionWePYQ
{

    if (qrcodeUrl.length <= 0)
     {
        [self getShareQrcode];
        return;
     }
    
    UIImage *image = [ToolsUtlis getImgFromStr:qrcodeUrl];
    if (!image)
     {
        [MBProgressHUD showErrorWithStatus:@"请求分享图片失败" toView:self.view];
        return;
     }
    
    NSData *data=  UIImageJPEGRepresentation(image,0.5);
    

    NSMutableDictionary *parmams = [[NSMutableDictionary alloc] init];
    parmams[@"image"] = data;
    [[DDGShareManager shareManager] weChatShare:parmams shareScene:1];
    
    [[DDGShareManager  shareManager] setBlock:^(id obj) {
        
        NSDictionary *dic = (NSDictionary *)obj;
        if ([[dic objectForKey:@"success"] boolValue]) {
            [MBProgressHUD showSuccessWithStatus:@"分享成功" toView:self.view];
        }else{
            [MBProgressHUD showErrorWithStatus:@"分享失败" toView:self.view];
        }
    }];
}

-(void) actionDetailJPG:(UITapGestureRecognizer*) tag
{
    if (![CommonInfo isLoggedIn]) {
        [DDGUserInfoEngine engine].parentViewController = self;
        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
        return;
    }
    
    UIView *view = tag.view;
    int iTag = (int)view.tag;
    
    float  fImgHeight =  [arrTailIMG[iTag] floatValue];
    NSDictionary *dicObj = arrDetailJpgUrl[iTag];
    NSString *strImgUrl = dicObj[@"url"];
    
    ShowBigJpgView *bigView = [[ShowBigJpgView alloc] initWithImgUrl:strImgUrl height:fImgHeight];
    [self.view addSubview:bigView];
    
    
    
}

-(void) actionBtn:(UIButton*) sender
{
    if (![CommonInfo isLoggedIn]) {
        [DDGUserInfoEngine engine].parentViewController = self;
        [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
        return;
    }
    
    int iTag = (int)sender.tag;
    NSLog(@"iTag :%d", iTag);
    
    //NSArray *arrTitle =  @[@"客 服",@"收 藏",@"购物车"];
    if (0 == iTag)
     {
        // 客服聊天
         ChatViewController  *VC = [[ChatViewController alloc] init];
         [self.navigationController  pushViewController:VC animated:YES];
     }
    else if (1 == iTag)
     {
        //收藏 或者 取消收藏
        [self addFavorite];
       
     }
    else if (2 == iTag)
     {
        // 购物车
        LZCartViewController *VC = [[LZCartViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
     }
}

// 立即购买
-(void) actionLJGM
{
//    if (!arrSku ||
//        !arrSkuShow)
//     {
//        [self querySkuList];
//        [self querySkuProList];
//        [MBProgressHUD showErrorWithStatus:@"获取规格参数失败，请稍后再试" toView:self.view];
//        return;
//     }
//
//    PopSelShopView  *popView = [[PopSelShopView alloc] init];
//    popView.shopModel = _shopModel;
//    popView.arrSku = arrSku;
//    popView.arrSkuShow = arrSkuShow;
//    popView.parentVC = self;
//    [popView show];
    if (!arrSku ||
        !arrSkuShow)
     {
        [self querySkuList];
        [self querySkuProList];
        [MBProgressHUD showErrorWithStatus:@"获取规格参数失败，请稍后再试" toView:self.view];
        return;
     }
    
    PopSelShopView  *popView = [[PopSelShopView alloc] init];
    popView.shopModel = _shopModel;
    popView.arrSku = arrSku;
    popView.arrSkuShow = arrSkuShow;
    popView.parentVC = self;
    [popView show];
}

// 加入购物车
-(void) actionJRGWC
{
    if (!arrSku ||
        !arrSkuShow)
     {
        [self querySkuList];
        [self querySkuProList];
        [MBProgressHUD showErrorWithStatus:@"获取规格参数失败，请稍后再试" toView:self.view];
        return;
     }
    
    PopSelShopView  *popView = [[PopSelShopView alloc] init];
    popView.shopModel = _shopModel;
    popView.arrSku = arrSku;
    popView.arrSkuShow = arrSkuShow;
    popView.parentVC = self;
    [popView show];
}

// 优惠说明
-(void) actionYHSM
{
    
}

// 选择规格
-(void) actionSelModel
{
    if (!arrSku ||
        !arrSkuShow)
     {
        [self querySkuList];
        [self querySkuProList];
        [MBProgressHUD showErrorWithStatus:@"获取规格参数失败, 请稍后再试" toView:self.view];
        return;
     }
    
    PopSelShopView  *popView = [[PopSelShopView alloc] init];
    popView.shopModel = _shopModel;
    popView.arrSku = arrSku;
    popView.arrSkuShow = arrSkuShow;
    popView.parentVC = self;
    [popView show];
    
}


// 说明
-(void) actionShuoMing
{
    NSString *url = [NSString stringWithFormat:@"%@webMall/returnPolicy",[PDAPI WXSysRouteAPI]];
    [CCWebViewController showWithContro:self withUrlStr:url withTitle:@"退换货说明"];
}


#pragma mark notification
-(void)upDateCartCount:(NSNotification *)notification
{
    NSLog(@"user info is %@",notification.object);
    NSDictionary *dic = notification.object;
    
    int iCount =  [dic[@"count"] intValue];

    labelCartNum.width = 15;
    if (iCount < 10)
     {
        labelCartNum.font = [UIFont systemFontOfSize:10];
     }
    else
     {
        labelCartNum.font = [UIFont systemFontOfSize:8];
     }
    if (iCount <= 0)
     {
        labelCartNum.hidden = YES;
     }
    else
     {
        labelCartNum.hidden = NO;
     }
    labelCartNum.text = [NSString stringWithFormat:@"%d", iCount];
    
    if (iCount >99)
     {
        labelCartNum.width = 20;
        labelCartNum.text = @"99+";
     }
}

-(void) gotoInfo
{
    //  滚动详情图片的位置
    [scView setContentOffset:CGPointMake(0, iTailViewTopY) animated:NO];
}
@end
