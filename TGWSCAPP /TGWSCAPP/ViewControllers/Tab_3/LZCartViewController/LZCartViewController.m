//
//  LZCartViewController.m
//  LZCartViewController
//
//  Created by LQQ on 16/5/18.
//  Copyright © 2016年 LQQ. All rights reserved.
//  https://github.com/LQQZYY/CartDemo
//  http://blog.csdn.net/lqq200912408
//  QQ交流: 302934443

#import "LZCartViewController.h"
#import "LZConfigFile.h"
#import "LZCartTableViewCell.h"
#import "LZCartModel.h"
#import "ShopDetailVC.h"
#import "SKAutoScrollLabel.h"
#import "CDWAlertView.h"
#import "OrderDetialVC.h"

@interface LZCartViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UILabel *labelBY;  //包邮label
    UIView *viewYH;    // 优惠view
    SKAutoScrollLabel *labelYH;  //优惠label
    UIButton *btnAddShop1;  // 去凑单按钮1
    UIButton *btnAddShop2;  // 去凑单按钮2
    UIButton *btnTail;    // 底部的按钮。 下单/删除
    
    UIButton *rightNavBtn;     //导航右边按钮
    
    BOOL  isChildView ;  // 是否属于子页面
    BOOL  isHasTabBarController;
    BOOL  isEdit;      // 是否编辑
    
    NSString *promocardId;     // 用户优惠券ID
    NSString *custPromocardId; // 优惠券ID
    
}

@property (strong,nonatomic)NSMutableArray *selectedArray;

@property (strong,nonatomic)NSMutableArray *dataArrayUnUse;  // 失效的数据
@property (strong,nonatomic)NSMutableArray *lastDataArrayUnUse;  // 失效的数据(上一次)
@property (strong,nonatomic)NSMutableArray *lastDataArr;
@property (strong,nonatomic)UITableView *myTableView;
@property (strong,nonatomic)UIButton *allSellectedButton;
@property (strong,nonatomic)UILabel *totlePriceLabel;


@property (strong,nonatomic)NSIndexPath *delIndexPath;  // 删除的IndexPath

@end

@implementation LZCartViewController

#pragma mark - viewController life cicle
- (void)viewWillAppear:(BOOL)animated {
    
    
    
    //当进入购物车的时候判断是否有已选择的商品,有就清空
    //主要是提交订单后再返回到购物车,如果不清空,还会显示
//    if (self.selectedArray.count > 0) {
//        for (LZCartModel *model in self.selectedArray) {
//            model.select = NO;//这个其实有点多余,提交订单后的数据源不会包含这些,保险起见,加上了
//        }
//        [self.selectedArray removeAllObjects];
//    }

//    //初始化显示状态
//    _allSellectedButton.selected = NO;
//    _totlePriceLabel.attributedText = [self LZSetString:@"￥0.00"];
    
    if ([CommonInfo isLoggedIn])
     {
        [self loadData];
     }
}

-(void)creatData {
    for (int i = 0; i < 10; i++) {
        LZCartModel *model = [[LZCartModel alloc]init];
        
        model.nameStr = [NSString stringWithFormat:@"测试数据%d",i];
        model.price = @"100.00";
        model.number = 1;
        model.imageStr = @"";//[UIImage imageNamed:@"aaa.jpg"];
        model.dateStr = @"2016.02.18";
        model.sizeStr = @"18*20cm";
        
        [self.dataArray addObject:model];
    }
}

-(void) allUnSel
{
    //当进入购物车的时候判断是否有已选择的商品,有就清空
    //主要是提交订单后再返回到购物车,如果不清空,还会显示
    if (self.selectedArray.count > 0) {
        for (LZCartModel *model in self.selectedArray) {
            model.select = NO;//这个其实有点多余,提交订单后的数据源不会包含这些,保险起见,加上了
        }
        [self.selectedArray removeAllObjects];
    }
    
    //初始化显示状态
    _allSellectedButton.selected = NO;
    _totlePriceLabel.attributedText = [self LZSetString:@"￥0.00"];
}



- (LZCartViewController*)initWithVar:(BOOL)isChild
{
    self = [super init];

    self.hideBackButton = YES;
    isChildView = YES;
    isHasTabBarController = YES;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    CustomNavigationBarView *nav = [self layoutNaviBarViewWithTitle:@"购物车"];
    
    float fRightBtnTopY =  NavHeight - 36;
    if (IS_IPHONE_X_MORE)
     {
        fRightBtnTopY = NavHeight - 36;
     }
    
    //导航右边按钮
    rightNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 60.f,fRightBtnTopY,60.f, 35.0f)];
    [rightNavBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[ResourceManager navgationTitleColor] forState:UIControlStateNormal];
    [rightNavBtn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
    [rightNavBtn addTarget:self action:@selector(actionEidt) forControlEvents:UIControlEventTouchUpInside];
    rightNavBtn.titleLabel.font = [ResourceManager font_7];
    [nav addSubview:rightNavBtn];
    
    [self initData];

    if (self.dataArray.count > 0) {
        
        [self setupCartView];
    } else {
        [self setupCartEmptyView];
    }
    
#warning 加载网络数据,会有延迟
    if ([CommonInfo isLoggedIn])
     {
        [self loadData];
     }
    else
     {
        [self setupCartEmptyView];
     }

}

-(void) initData
{
    isEdit = FALSE;
    promocardId = @"";
    custPromocardId = @"";
}




- (void)viewWillDisappear:(BOOL)animated {
//    if (_isHiddenNavigationBarWhenDisappear == YES) {
//        self.navigationController.navigationBarHidden = NO;
//    }
}

#pragma mark --- 计算所选组合的 商品价格，标题
-(void)countPrice
{
    double totlePrice = 0.0;
    
    for (LZCartModel *model in self.selectedArray) {
        
        double price = [model.price doubleValue];
        
        totlePrice += price*model.number;
    }
    NSString *string = [NSString stringWithFormat:@"￥%.2f",totlePrice];
    self.totlePriceLabel.attributedText = [self LZSetString:string];
    
    [self getTitleFromWeb];
}

#pragma mark - 初始化数组
- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArray;
}

- (NSMutableArray *)selectedArray {
    if (_selectedArray == nil) {
        _selectedArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _selectedArray;
}



- (NSMutableArray *)dataArrayUnUse {
    if (_dataArrayUnUse == nil) {
        _dataArrayUnUse = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataArrayUnUse;
}


- (NSMutableArray *)lastDataArr {
    if (_lastDataArr == nil) {
        _lastDataArr = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _lastDataArr;
}

- (NSMutableArray *)lastDataArrayUnUse {
    if (_lastDataArrayUnUse == nil) {
        _lastDataArrayUnUse = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _lastDataArrayUnUse;
}


#pragma mark - 布局页面视图
#pragma mark -- 自定义底部视图 
- (void)setupCustomBottomView {
    
    UIView *backgroundView = [[UIView alloc]init];
    backgroundView.backgroundColor = [UIColor whiteColor];//LZColorFromRGB(245, 245, 245);
    backgroundView.tag = TAG_CartEmptyView + 1;
    [self.view addSubview:backgroundView];
    
    //当有tabBarController时,在tabBar的上面
    if (isHasTabBarController == YES)
    {
        backgroundView.frame = CGRectMake(0, LZSCREEN_HEIGHT -  LZTabBarHeight - TabbarHeight, LZSCREEN_WIDTH, LZTabBarHeight);
    } else {
        backgroundView.frame = CGRectMake(0, LZSCREEN_HEIGHT -  LZTabBarHeight, LZSCREEN_WIDTH, LZTabBarHeight);
    }
    
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = CGRectMake(0, 0, LZSCREEN_WIDTH, 1);
    lineView.backgroundColor = [ResourceManager color_5];
    [backgroundView addSubview:lineView];
    
    //全选按钮
    UIButton *selectAll = [UIButton buttonWithType:UIButtonTypeCustom];
    selectAll.titleLabel.font = [UIFont systemFontOfSize:14];
    selectAll.frame = CGRectMake(10, 5, 80, LZTabBarHeight - 10);
    [selectAll setTitle:@" 全选" forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:lz_Bottom_UnSelectButtonString] forState:UIControlStateNormal];
    [selectAll setImage:[UIImage imageNamed:lz_Bottom_SelectButtonString] forState:UIControlStateSelected];
    [selectAll setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    [selectAll addTarget:self action:@selector(selectAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:selectAll];
    self.allSellectedButton = selectAll;
    
    //结算按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [ResourceManager priceColor];
    btn.frame = CGRectMake(LZSCREEN_WIDTH - 120, 0, 120, LZTabBarHeight);
    [btn setTitle:@"下单" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(goToPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:btn];
    btnTail = btn;
    
    //合计
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [ResourceManager priceColor];
    [backgroundView addSubview:label];
    
    label.attributedText = [self LZSetString:@"¥0.00"];
    CGFloat maxWidth = LZSCREEN_WIDTH - selectAll.bounds.size.width - btn.bounds.size.width - 30;
//    CGSize size = [label sizeThatFits:CGSizeMake(maxWidth, LZTabBarHeight)];
    label.frame = CGRectMake(selectAll.bounds.size.width + 20, 0, maxWidth - 10, LZTabBarHeight);
    self.totlePriceLabel = label;
}

- (NSMutableAttributedString*)LZSetString:(NSString*)string {
    
    NSString *text = [NSString stringWithFormat:@"合计:%@",string];
    NSMutableAttributedString *LZString = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange rang = [text rangeOfString:@"合计:"];
    [LZString addAttribute:NSForegroundColorAttributeName value:[ResourceManager color_1] range:rang];
    [LZString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:rang];
    return LZString;
}
#pragma mark -- 购物车为空时的默认视图
- (void)changeView {
    if (self.dataArray.count > 0) {
        UIView *view = [self.view viewWithTag:TAG_CartEmptyView];
        if (view != nil) {
            [view removeFromSuperview];
        }
        
        [self setupCartView];
    } else {
        UIView *bottomView = [self.view viewWithTag:TAG_CartEmptyView + 1];
        [bottomView removeFromSuperview];
        
        [self.myTableView removeFromSuperview];
        self.myTableView = nil;
        [self setupCartEmptyView];
    }
}

- (void)setupCartEmptyView {
    rightNavBtn.hidden = YES;
    [self.selectedArray removeAllObjects];
    
    //默认视图背景
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, LZNaigationBarHeight, LZSCREEN_WIDTH, LZSCREEN_HEIGHT - LZNaigationBarHeight)];
    [self.view addSubview:backgroundView];
    backgroundView.tag = TAG_CartEmptyView;
    backgroundView.backgroundColor = [UIColor whiteColor];
    
    //默认图片
    UIImageView *img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:lz_CartEmptyString]];
    img.center = CGPointMake(LZSCREEN_WIDTH/2.0, LZSCREEN_HEIGHT/2.0 - 180);
    img.bounds = CGRectMake(0, 0, 100, 100);
    [backgroundView addSubview:img];
    
    UILabel *warnLabel = [[UILabel alloc]init];
    warnLabel.center = CGPointMake(LZSCREEN_WIDTH/2.0, LZSCREEN_HEIGHT/2.0 - 90);
    warnLabel.bounds = CGRectMake(0, 0, LZSCREEN_WIDTH, 30);
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.text = @"购物车还没有商品哦～";
    warnLabel.font = [UIFont systemFontOfSize:14];
    warnLabel.textColor = [ResourceManager lightGrayColor];
    [backgroundView addSubview:warnLabel];
    
    UIButton *btnShop = [[UIButton alloc] init];
    btnShop.center = CGPointMake(LZSCREEN_WIDTH/2.0, LZSCREEN_HEIGHT/2.0 - 30);
    btnShop.bounds = CGRectMake(0, 0, 100, 30);
    [backgroundView addSubview:btnShop];
    btnShop.cornerRadius = 4;
    [btnShop setTitle:@"去逛逛" forState:UIControlStateNormal];
    [btnShop setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    btnShop.titleLabel.font = [UIFont systemFontOfSize:14];
    btnShop.borderWidth = 0.3;
    btnShop.borderColor = [ResourceManager mainColor];
    [btnShop addTarget:self action:@selector(actonShop) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark -- 购物车有商品时的视图
- (void)setupCartView {
    
    rightNavBtn.hidden = NO;
    
    [self.selectedArray removeAllObjects];
    
    //创建底部视图
    [self setupCustomBottomView];
    // UITableViewStylePlain 风格时， 动态变为分组，才没有BUG
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    table.delegate = self;
    table.dataSource = self;
    
    table.rowHeight = lz_CartRowHeight;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:table];
    self.myTableView = table;
    
    
    if (isHasTabBarController) {
        table.frame = CGRectMake(0, LZNaigationBarHeight +LZTop1Height, LZSCREEN_WIDTH, LZSCREEN_HEIGHT - LZNaigationBarHeight - LZTop1Height - LZTabBarHeight - TabbarHeight);
    } else {
        table.frame = CGRectMake(0, LZNaigationBarHeight+ LZTop1Height, LZSCREEN_WIDTH, LZSCREEN_HEIGHT - LZNaigationBarHeight - LZTop1Height - LZTabBarHeight);
    }
    
    [self setupTopTitle];
}

// 创建头部标题时，购物车table的高度会动态改变
-(void) setupTopTitle
{
    int iLeftX = 20;
    UIView *viewBaoYou = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, LZTop1Height)];
    [self.view addSubview:viewBaoYou];
    viewBaoYou.backgroundColor = UIColorFromRGB(0xfbf1dd);
    
    labelBY = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, 10, SCREEN_WIDTH-70-iLeftX, LZTop1Height-20)];
    [viewBaoYou addSubview:labelBY];
    labelBY.font = [UIFont systemFontOfSize:14];
    labelBY.textColor = UIColorFromRGB(0x704a18);
    labelBY.text = @"满88元包邮";
    
    btnAddShop1 = [[UIButton alloc] initWithFrame:CGRectMake( SCREEN_WIDTH - 70, 0, 70, LZTop1Height)];  // 去凑单按钮1
    [viewBaoYou addSubview:btnAddShop1];
    [btnAddShop1 setTitle:@"去凑单>" forState:UIControlStateNormal];
    [btnAddShop1 setTitleColor:[ResourceManager priceColor] forState:UIControlStateNormal];
    btnAddShop1.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnAddShop1 addTarget:self action:@selector(actonAddShop) forControlEvents:UIControlEventTouchUpInside];
    btnAddShop1.hidden = YES;
    
    viewYH = [[UIView alloc] initWithFrame:CGRectMake(0, NavHeight+LZTop1Height, SCREEN_WIDTH, LZTop1Height)];
    [self.view addSubview:viewYH];
    viewYH.backgroundColor = [UIColor whiteColor];
    
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, LZTop1Height-1, SCREEN_WIDTH, 1)];
    [viewYH addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager color_5];
    
    UILabel *lableYHFH = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, 12, 30, LZTop1Height-12*2)];
    [viewYH addSubview:lableYHFH];
    lableYHFH.backgroundColor = [ResourceManager priceColor];
    lableYHFH.layer.cornerRadius = 3;
    lableYHFH.layer.masksToBounds = YES;
    lableYHFH.font = [UIFont systemFontOfSize:12];
    lableYHFH.textColor = [UIColor whiteColor];
    lableYHFH.text = @" 优惠";
    

    
    
    btnAddShop2 = [[UIButton alloc] initWithFrame:CGRectMake( SCREEN_WIDTH - 60, 0, 60, LZTop1Height)];  // 去凑单按钮1
    [viewYH addSubview:btnAddShop2];
    //btnAddShop2.backgroundColor = [UIColor yellowColor];
    [btnAddShop2 setTitle:@"去凑单>" forState:UIControlStateNormal];
    [btnAddShop2 setTitleColor:[ResourceManager priceColor] forState:UIControlStateNormal];
    btnAddShop2.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnAddShop2 addTarget:self action:@selector(actonAddShop) forControlEvents:UIControlEventTouchUpInside];
    btnAddShop2.hidden = YES;
    
    
    iLeftX += lableYHFH.width + 8;
    labelYH = [[SKAutoScrollLabel alloc] initWithFrame:CGRectMake(iLeftX,10 , SCREEN_WIDTH-60-iLeftX, LZTop1Height-20)];
    [viewYH addSubview:labelYH];
    labelYH.font = [UIFont systemFontOfSize:14];
    //labelYH.backgroundColor  = [UIColor blueColor];
    labelYH.textColor = [ResourceManager midGrayColor];
    labelYH.text = @"满88元包邮";
    
    viewYH.hidden = YES;
    
    

}

// 根据数据内容， 显示顶部标题
-(void) setTopTitle:(NSDictionary*) dic
{
    btnAddShop1.hidden = YES;
    btnAddShop2.hidden = YES;
    viewYH.hidden = YES;

    labelBY.text = dic[@"postTitle"];
    
    int postageFlag = [dic[@"postageFlag"] intValue];
    
    if (1 == postageFlag)
     {
        // 如果包邮里，需要凑单， 那么不显示优惠
        btnAddShop1.hidden = NO;
        if (isHasTabBarController) {
            self.myTableView.frame = CGRectMake(0, LZNaigationBarHeight +LZTop1Height, LZSCREEN_WIDTH, LZSCREEN_HEIGHT - LZNaigationBarHeight - LZTop1Height - LZTabBarHeight - TabbarHeight);
        } else {
            self.myTableView.frame = CGRectMake(0, LZNaigationBarHeight+ LZTop1Height, LZSCREEN_WIDTH, LZSCREEN_HEIGHT - LZNaigationBarHeight - LZTop1Height - LZTabBarHeight);
        }
        return;
     }
    
    NSString *promocardDesc = dic[@"promocardDesc"];
    if (promocardDesc &&
        promocardDesc.length > 0)
     {
        // 如果有优惠券
        viewYH.hidden = NO;
        labelYH.text = promocardDesc;
        //labelYH.scrolling = NO;
        
        int addFlag = [dic[@"addFlag"] intValue];
        if (1 == addFlag)
         {
            btnAddShop2.hidden = NO;
         }
        
        if (isHasTabBarController) {
            self.myTableView.frame = CGRectMake(0, LZNaigationBarHeight +2*LZTop1Height, LZSCREEN_WIDTH, LZSCREEN_HEIGHT - LZNaigationBarHeight - 2*LZTop1Height - LZTabBarHeight - TabbarHeight);
        } else {
            self.myTableView.frame = CGRectMake(0, LZNaigationBarHeight+ 2*LZTop1Height, LZSCREEN_WIDTH, LZSCREEN_HEIGHT - LZNaigationBarHeight - 2*LZTop1Height - LZTabBarHeight);
        }
     }
    else
     {
        if (isHasTabBarController) {
            self.myTableView.frame = CGRectMake(0, LZNaigationBarHeight +LZTop1Height, LZSCREEN_WIDTH, LZSCREEN_HEIGHT - LZNaigationBarHeight - LZTop1Height - LZTabBarHeight - TabbarHeight);
        } else {
            self.myTableView.frame = CGRectMake(0, LZNaigationBarHeight+ LZTop1Height, LZSCREEN_WIDTH, LZSCREEN_HEIGHT - LZNaigationBarHeight - LZTop1Height - LZTabBarHeight);
        }
     }
    
    NSLog(@"promocardDesc:%@", dic[@"promocardDesc"]);
}

#pragma mark --- UITableViewDataSource & UITableViewDelegate

//返回分组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"计算分组数");
    
    if ([self.dataArrayUnUse count] <= 0)
     {
        return 1;
     }
    return 2;
}

//返回每组行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ( 0 == section)
     {
        return self.dataArray.count;
     }
    if (1 == section)
     {
        return  self.dataArrayUnUse.count;
     }
    
    return self.dataArray.count;
}

// 自定义段头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (0 == section)
     {
        return   0;
     }
    
    if ([self.dataArrayUnUse count] == 0)
     {
        return 0;
     }
    
    if (1 == section  &&
        [self.dataArrayUnUse count] > 0)
     {
        return 70;
     }
    
    return 0;
}

// 自定义头部view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    int iHeight = 70;
    if (0 == section)
     {
        iHeight = 0;
     }
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, iHeight)];//创建一个视图
    //headerView.backgroundColor = [UIColor blueColor];
    
    int iTopY = 0;
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 10)];
    [headerView addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager viewBackgroundColor];
    
    
   
    iTopY += viewFG.height + 20;
    NSString *createTime = [NSString stringWithFormat:@"失效物品%d件", (int)[self.dataArrayUnUse  count]];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, iTopY, 150, 20)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont systemFontOfSize:14];
    headerLabel.textColor = [ResourceManager color_1];
    headerLabel.text = createTime;
    [headerView addSubview:headerLabel];
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, iTopY, 90, 20)];
    [headerView addSubview:btnRight];
    [btnRight setTitle:@"清除失效商品"   forState:UIControlStateNormal];
    [btnRight setTitleColor:[ResourceManager priceColor] forState:UIControlStateNormal];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnRight addTarget:self action:@selector(actionDelUnuse) forControlEvents:UIControlEventTouchUpInside];
    

    UIView *viewFG2 = [[UIView alloc] initWithFrame:CGRectMake(0, headerView.height -1, SCREEN_WIDTH, 1)];
    [headerView addSubview:viewFG2];
    viewFG2.backgroundColor = [ResourceManager color_5];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 失效列表
    if (1 ==  indexPath.section)
     {
        //UITableViewCell  *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, lz_CartRowHeight)];
        
        UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"LZCartReusableCellUnuse"];
        if (cell == nil)
         {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LZCartReusableCellUnuse"];
            //cell.backgroundColor = [UIColor yellowColor];
            NSDictionary *dicObj = self.dataArrayUnUse[indexPath.row];
            
            int iRoundWidth = 20;
            int iLeftX = 20;
            
            UIImageView *imgRight = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, (lz_CartRowHeight-iRoundWidth)/2, iRoundWidth, iRoundWidth)];
            [cell addSubview:imgRight];
            imgRight.cornerRadius = iRoundWidth/2;
            imgRight.backgroundColor = UIColorFromRGB(0xebebeb);
            
            iLeftX += imgRight.width + 15;
            int iTopY = 15;
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX,  iTopY, lz_CartRowHeight - 30, lz_CartRowHeight - 30)];
            [cell addSubview:imageView];
            [imageView setImageWithURL:[NSURL URLWithString:dicObj[@"goodsUrl"]]];
            
            iTopY += 1;
            iLeftX += imageView.width + 10;
            UILabel* labelName = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX,  iTopY, SCREEN_WIDTH - iLeftX-10, 20)];
            [cell addSubview:labelName];
            labelName.textColor = [ResourceManager color_1];
            labelName.font = [UIFont systemFontOfSize:14];
            labelName.text = dicObj[@"goodsName"];
            
            iTopY += labelName.height + 6 ;
            UILabel* labelYXJ = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX,  iTopY, 46, 15)];
            [cell addSubview:labelYXJ];
            labelYXJ.textColor = [ResourceManager mainColor];
            labelYXJ.font = [UIFont systemFontOfSize:11];
            labelYXJ.text = @"已下架";
            labelYXJ.textAlignment = NSTextAlignmentCenter;
            labelYXJ.borderColor = [ResourceManager mainColor];
            labelYXJ.borderWidth = 0.3;
            labelYXJ.layer.cornerRadius = 2;
            labelYXJ.layer.masksToBounds = YES;
            
            
            iTopY += labelYXJ.height + 10;
            UILabel* labelBNM = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX,  iTopY, SCREEN_WIDTH - iLeftX-10, 20)];
            [cell addSubview:labelBNM];
            labelBNM.textColor = [ResourceManager midGrayColor];
            labelBNM.font = [UIFont systemFontOfSize:12];
            labelBNM.text = @"此商品不能购买";
            
            
            //加入分割线
            UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(10, lz_CartRowHeight-1, SCREEN_WIDTH-20, 1)];
            [cell addSubview:viewFG];
            viewFG.backgroundColor = [ResourceManager color_5];
            
        }
        return  cell;
     }
    
    
    // 有效列表
    LZCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LZCartReusableCell"];
    if (cell == nil) {
        cell = [[LZCartTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"LZCartReusableCell"];
    }
    
    LZCartModel *model = self.dataArray[indexPath.row];
    __block typeof(cell)wsCell = cell;
    
    
    // 做加法
    [cell numberAddWithBlock:^(NSInteger number) {
        if (number > model.ableStock)
         {
            [MBProgressHUD showErrorWithStatus:@"购买数量不能大于库存数" toView:self.view];
            return;
         }
        
        wsCell.lzNumber = number;
        model.number = number;
        
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
        if ([self.selectedArray containsObject:model]) {
            [self.selectedArray removeObject:model];
            [self.selectedArray addObject:model];
            
            [self countPrice];
        }
        
         [self updateDataToWeb:model];
        
    }];
    
    
    // 做减法
    [cell numberCutWithBlock:^(NSInteger number) {
        
        wsCell.lzNumber = number;
        model.number = number;
        
        [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
        
        //判断已选择数组里有无该对象,有就删除  重新添加
        if ([self.selectedArray containsObject:model]) {
            [self.selectedArray removeObject:model];
            [self.selectedArray addObject:model];
            
            [self countPrice];
            
        }
        
        [self updateDataToWeb:model];
        
    }];
    
    [cell cellSelectedWithBlock:^(BOOL select) {
        
        model.select = select;
        if (select) {
            [self.selectedArray addObject:model];
        } else {
            [self.selectedArray removeObject:model];
        }
        
        if (self.selectedArray.count == self.dataArray.count) {
            self.allSellectedButton.selected = YES;
        } else {
            self.allSellectedButton.selected = NO;
        }
        
        [self countPrice];
    }];
    
    [cell reloadDataWithModel:model];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //（这种是没有点击后的阴影效果)
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    if (1 == indexPath.section)
     {
        NSDictionary *dicObj = self.dataArrayUnUse[indexPath.row];
        ShopDetailVC *VC  = [[ShopDetailVC alloc] init];
        VC.shopModel = [[ShopModel alloc] init];
        VC.shopModel.strGoodsCode = dicObj[@"goodsCode"];
        VC.est = @"cart";
        VC.esi = [NSString stringWithFormat:@"%@",[dicObj objectForKey:@"cartId"]];
        [self.navigationController pushViewController:VC animated:YES];
        return;
     }
    
    LZCartModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    if (model) {
        
        ShopDetailVC *VC  = [[ShopDetailVC alloc] init];
        VC.shopModel = [[ShopModel alloc] init];
        VC.shopModel.strGoodsCode = model.goodCodeStr;
        VC.est = @"cart";
        VC.esi = model.cartIdStr;
        [self.navigationController pushViewController:VC animated:YES];
        
    }
}



// 自定义左滑显示编辑按钮
-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    UITableViewRowAction *rowActionSec = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                            title:@"删除"    handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                                NSLog(@"删除");
                                                                                
                                                                            
                                                                                if (1 == indexPath.section)
                                                                                 {
                                                                                    [MBProgressHUD showErrorWithStatus:@"请用\“清除失效商品\“按钮" toView:self.view];
                                                                                    return ;
                                                                                 }
                                                                                
                                                                                CDWAlertView *alertView = [[CDWAlertView alloc] init];
                                                                                
                                                                                alertView.shouldDismissOnTapOutside = NO;
                                                                                alertView.textAlignment = RTTextAlignmentCenter;
                                                                                
                                                                                // 降低高度,加入标题
                                                                                //    [alertView subAlertCurHeight:20];
                                                                                //    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 18 color=#000000>提示</font>"]];
                                                                                
                                                                                // 加入message
                                                                                NSString *strXH= [NSString stringWithFormat:@"确定要删除所选商品？"];
                                                                                [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 15 color=#333333> %@ </font>",strXH]];
                                                                        
                                                                                
                                                                                
                                                                                [alertView addCanelButton:@"取消" actionBlock:^{
                                                                                    
                                                                                }];
                                                                                
                                                                                [alertView addButton:@"确定" color:[ResourceManager mainColor] actionBlock:^{
                                                                                    
                                                                                    // 记录删除的 indexPath
                                                                                    self.delIndexPath = indexPath;
                                                                                    
                                                                                    LZCartModel *model = [self.dataArray objectAtIndex:indexPath.row];
                                                                                    
                                                                                    [self deleteToWeb:model.cartIdStr];
                                                                                }];
                                                                                
                                                                               
                                                                                [alertView showAlertView:self.parentViewController duration:0.0];
                                                                                return;
                                                                                
                                                                               

                                                                            }];
    
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title:@"收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                             NSLog(@"收藏");
                                                                             
                                                                         }];
    rowActionSec.backgroundColor = UIColorFromRGB(0xaf0e1d);//[UIColor colorWithHexString:@"0f3822"];
    rowAction.backgroundColor =  UIColorFromRGB(0xd9d9d9);//[UIColor colorWithHexString:@"d9d9d9"];
    
    //NSArray *arr = @[rowActionSec,rowAction];
    NSArray *arr = @[rowActionSec];
    return arr;
}

-(void)delLocal:(NSIndexPath *)indexPath
{
    LZCartModel *model = [self.dataArray objectAtIndex:indexPath.row];
    
    [self.dataArray removeObjectAtIndex:indexPath.row];
    //    删除
    [_myTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    //判断删除的商品是否已选择
    if ([self.selectedArray containsObject:model]) {
        //从已选中删除,重新计算价格
        [self.selectedArray removeObject:model];
        [self countPrice];
    }
    
    if (self.selectedArray.count == self.dataArray.count) {
        self.allSellectedButton.selected = YES;
    } else {
        self.allSellectedButton.selected = NO;
    }
    
    if (self.dataArray.count == 0) {
        [self changeView];
    }
    
    //如果删除的时候数据紊乱,可延迟0.5s刷新一下
    [self performSelector:@selector(reloadTable) withObject:nil afterDelay:0.5];
    

}


- (void)reloadTable {
    [self.myTableView reloadData];
}
#pragma mark -- 页面按钮点击事件

#pragma mark --- 全选按钮点击事件
- (void)selectAllBtnClick:(UIButton*)button {
    button.selected = !button.selected;
    
    //点击全选时,把之前已选择的全部删除
    for (LZCartModel *model in self.selectedArray) {
        model.select = NO;
    }
    
    [self.selectedArray removeAllObjects];
    
    if (button.selected) {
        
        for (LZCartModel *model in self.dataArray) {
            model.select = YES;
            [self.selectedArray addObject:model];
        }
    }
    
    [self.myTableView reloadData];
    [self countPrice];
}
#pragma mark --- 确认选择,提交订单按钮点击事件
- (void)goToPayButtonClick:(UIButton*)button {
    
    
    // 编辑状态下，为删除动作
    if (isEdit)
     {
        if (self.selectedArray.count > 0) {
            NSString *strAll = @"";
            for (LZCartModel *model in self.selectedArray) {
                NSLog(@"选择的商品>>%@>>>%ld",model.nameStr,(long)model.number);

                strAll = [strAll stringByAppendingString:model.cartIdStr];
                strAll = [strAll stringByAppendingString:@","];
            }


            [self actionPopModify:strAll];



        }
        else
         {
            NSLog(@"你还没有选择任何商品");
            [MBProgressHUD showErrorWithStatus:@"你还没有选择任何商品" toView:self.view];
            
         }
        
        return;
     }
    
    
    if (self.selectedArray.count > 0) {
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        NSString *strCartIDS = @"";
        for (LZCartModel *model in self.selectedArray) {
            NSLog(@"选择的商品>>%@>>>%ld",model.nameStr,(long)model.number);
            
            strCartIDS = [strCartIDS stringByAppendingString:model.cartIdStr];
            strCartIDS = [strCartIDS stringByAppendingString:@","];
        }
        
        params[@"cartIds"] = strCartIDS;
        params[@"promocardId"] = promocardId;
        params[@"custPromocardId"] = custPromocardId;

        
        
        OrderDetialVC  *VC = [[OrderDetialVC alloc] init];
        VC.dicToWeb = params;
        VC.iType = 2;
        [self.navigationController pushViewController:VC animated:YES];
 
        
        
    } else {
        NSLog(@"你还没有选择任何商品");
        [MBProgressHUD showErrorWithStatus:@"你还没有选择任何商品" toView:self.view];
        
    }
    
}

-(void) actionPopModify:(NSString*) strAll
{
    CDWAlertView *alertView = [[CDWAlertView alloc] init];
    
    alertView.shouldDismissOnTapOutside = NO;
    alertView.textAlignment = RTTextAlignmentCenter;
    
    // 降低高度,加入标题
//    [alertView subAlertCurHeight:20];
//    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 18 color=#000000>提示</font>"]];
    
    // 加入message
    NSString *strXH= [NSString stringWithFormat:@"确定要删除所选商品？"];
    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 15 color=#333333> %@ </font>",strXH]];
     
    
    [alertView addCanelButton:@"取消" actionBlock:^{
        
    }];
    
    [alertView addButton:@"确定" color:[ResourceManager mainColor] actionBlock:^{
        
        [self deleteMulitToWeb:strAll];
    }];
    
    [alertView showAlertView:self.parentViewController duration:0.0];
    return;
}

#pragma mark --- action
-(void) actonShop
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@"1"}];
}

-(void) actonAddShop
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@"1"}];
}

-(void) actionEidt
{
    isEdit = !isEdit;
    if (isEdit)
     {
        [rightNavBtn setTitle:@"完成" forState:UIControlStateNormal];
        [btnTail setTitle:@"删除所选" forState:UIControlStateNormal];
        self.totlePriceLabel.hidden = YES;
        
     }
    else
     {
        [rightNavBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [btnTail setTitle:@"下单" forState:UIControlStateNormal];
        self.totlePriceLabel.hidden = NO;
     }
}

-(void) actionDelUnuse
{
    NSString *strAll = @"";
    for (int i =0; i < [self.dataArrayUnUse count]; i++) {
        NSDictionary *dicObj = self.dataArrayUnUse[i];
        
        NSString *strCardID = [NSString stringWithFormat:@"%@", dicObj[@"cartId"]];
        
        strAll = [strAll stringByAppendingString:strCardID];
        strAll = [strAll stringByAppendingString:@","];
    }
    
    if (strAll.length > 0)
     {
        [self actionPopModify:strAll];
     }
}

#pragma mark  --- 网络通讯
//- (void)loadData {
//    //[self creatData];
//    //[self changeView];
//}

-(void) loadData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLorderCartList];
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

-(void)deleteToWeb:(NSString*) strCartIds
{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"cartIds"] = strCartIds;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLorderCartDelete];
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

-(void)deleteMulitToWeb:(NSString*) strCartIds
{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"cartIds"] = strCartIds;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLorderCartDelete];
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


-(void)getTitleFromWeb
{
    promocardId = @"";
    custPromocardId = @"";
    
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *strAll = @"";
    for (LZCartModel *model in self.selectedArray) {
        NSLog(@"选择的商品>>%@>>>%ld",model.nameStr,(long)model.number);
        
        strAll = [strAll stringByAppendingString:model.cartIdStr];
        strAll = [strAll stringByAppendingString:@","];
    }
    
    
    params[@"cartIds"] = strAll;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLgetSaleTitle];
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

-(void) updateDataToWeb:(LZCartModel*)model
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"cartId"] = model.cartIdStr;
    params[@"num"] = @(model.number);
    params[@"skuCode"] = model.skuCodeStr;
    
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLorderCartUpdate];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      //[self handleErrorData:operation];
                                                                                  }];
    
    operation.tag = 1004;
    
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    // 需要刷新购物车下标
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGCartNeedCountNotification object:nil];
    
    if (operation.tag == 1000)
     {
        // 刷新购物车列表
        [self.dataArray removeAllObjects];
        
        NSArray *arr = operation.jsonResult.rows;
        if (arr)
         {
            for (int i = 0; i < [arr count]; i++) {
                NSDictionary *dic = arr[i];
                LZCartModel *model = [[LZCartModel alloc]init];
                
                model.cartIdStr = [NSString stringWithFormat:@"%@", dic[@"cartId"]];
                model.skuCodeStr = [NSString stringWithFormat:@"%@", dic[@"skuCode"]];
                model.nameStr = dic[@"goodsName"];
                
                
                NSString *strPrice = [NSString stringWithFormat:@"%@", dic[@"price"]];
                strPrice=[strPrice stringByReplacingOccurrencesOfString:@"," withString:@""];
                strPrice=[strPrice stringByReplacingOccurrencesOfString:@"，" withString:@""];
                
                model.price = [NSString stringWithFormat:@"%.2f", [strPrice floatValue]];
                float fmarketPrice = [dic[@"marketPrice"] floatValue];
                if (fmarketPrice > 0.00)
                 {
                    model.marketPrice =  [NSString stringWithFormat:@"¥%@", dic[@"marketPrice"]];
                 }
                
                model.number =  [dic[@"num"] intValue];
                model.imageStr =  dic[@"goodsUrl"];
                model.sizeStr = [NSString stringWithFormat:@"%@", dic[@"skuDesc"]];
                model.ableStock = [dic[@"ableStock"] intValue];
                model.goodCodeStr = dic[@"goodsCode"];
                
                [self.dataArray addObject:model];
            }
         }
        
        BOOL  isNeddRefesh = FALSE;
        // 如果数组个数不相等， 需要刷新
        if ([self.dataArray count] !=  [self.lastDataArr count] ||
            [self.lastDataArr count] == 0)
         {
            isNeddRefesh = TRUE;
         }
        else
         {
            for (int i = 0; i < [self.lastDataArr count]; i++)
             {
                LZCartModel *lastModel = self.lastDataArr[i];
                LZCartModel *curModel = self.dataArray[i];
                if (![lastModel.goodCodeStr isEqualToString:curModel.goodCodeStr])
                 {
                    isNeddRefesh = TRUE;
                 }
                
                if (![lastModel.skuCodeStr isEqualToString:curModel.skuCodeStr])
                 {
                    isNeddRefesh = TRUE;
                 }
                
                if (lastModel.number != curModel.number)
                 {
                    isNeddRefesh = TRUE;
                 }
                
             }
         }
        
        
        // 失效的列表
        [self.dataArrayUnUse removeAllObjects];
        NSDictionary *dicUnuse = operation.jsonResult.attr;
        NSArray *arrUnuse = dicUnuse[@"unUseGoodsList"];
        if (arrUnuse &&
            [arrUnuse count] >0)
         {
            [self.dataArrayUnUse addObjectsFromArray:arrUnuse];
         }
        
        if ([arrUnuse count] >0 &&
            [self.dataArray count] == 0)
         {
            isNeddRefesh = YES;
         }
        
        if ([self.dataArrayUnUse count] != [self.lastDataArrayUnUse count])
         {
            isNeddRefesh = YES;
         }
        
        
        if (isNeddRefesh)
         {
            [self changeView];
            
         }
        
        [self.lastDataArr removeAllObjects];
        [self.lastDataArr addObjectsFromArray:self.dataArray];
        
        [self.lastDataArrayUnUse removeAllObjects];
        [self.lastDataArrayUnUse addObjectsFromArray:self.dataArrayUnUse];
        
        
        if (isEdit)
         {
            [rightNavBtn setTitle:@"完成" forState:UIControlStateNormal];
            [btnTail setTitle:@"删除所选" forState:UIControlStateNormal];
            self.totlePriceLabel.hidden = YES;
            
         }
        else
         {
            [rightNavBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [btnTail setTitle:@"下单" forState:UIControlStateNormal];
            self.totlePriceLabel.hidden = NO;
         }
        
     }
    else if (1001 == operation.tag)
     {
        // 删除所选列成功，删除本地列
        [self delLocal:_delIndexPath];
        
        [self allUnSel];
        
     }
    else if (1002 == operation.tag)
     {
        // 删除多个项目成功，从新请求数据
        [self loadData];
        
        [self.selectedArray removeAllObjects];
        
        [rightNavBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [btnTail setTitle:@"下单" forState:UIControlStateNormal];
        
        [self allUnSel];
        
     }
    else if (1003 == operation.tag)
     {
        // 获取所选组合的标题
        NSDictionary *dic = operation.jsonResult.attr;
        if (dic &&
            [dic count])
         {
            [self setTopTitle:dic];
            
            float  goodsTotalAmt  = [dic[@"goodsTotalAmt"] floatValue];
            NSString *string = [NSString stringWithFormat:@"￥%.2f",goodsTotalAmt];
            self.totlePriceLabel.attributedText = [self LZSetString:string];
            
            if (dic[@"promocardId"])
             {
                promocardId = [NSString stringWithFormat:@"%@", dic[@"promocardId"]];
             }
            if (dic[@"custPromocardId"])
             {
                custPromocardId = [NSString stringWithFormat:@"%@", dic[@"custPromocardId"]];
             }
            
            
            if (isEdit)
             {
                
                [rightNavBtn setTitle:@"完成" forState:UIControlStateNormal];
                
                [btnTail setTitle:@"删除所选" forState:UIControlStateNormal];
                if ([dic[@"totalGoodsNum"] intValue] > 0)
                 {
                    NSString *strText = [NSString stringWithFormat:@"删除所选(%@)", dic[@"totalGoodsNum"]];
                    [btnTail setTitle:strText forState:UIControlStateNormal];
                 }
                
                self.totlePriceLabel.hidden = YES;
                
             }
            else
             {
                
                [rightNavBtn setTitle:@"编辑" forState:UIControlStateNormal];
                
                [btnTail setTitle:@"下单" forState:UIControlStateNormal];
                if ([dic[@"totalGoodsNum"] intValue] > 0)
                 {
                    NSString *strText = [NSString stringWithFormat:@"下单(%@)", dic[@"totalGoodsNum"]];
                    [btnTail setTitle:strText forState:UIControlStateNormal];
                 }
                self.totlePriceLabel.hidden = NO;
             }
            
         }
     }
    else if (1004 == operation.tag)
     {
        [self getTitleFromWeb];
        
     }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
    
}


@end
