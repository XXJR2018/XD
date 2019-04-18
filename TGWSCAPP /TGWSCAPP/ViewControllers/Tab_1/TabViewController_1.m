//
//  TabViewController_1.m
//  XXJR
//
//  Created by xxjr03 on 2018/9/4.
//  Copyright © 2018年 Cary. All rights reserved.
//

#import "TabViewController_1.h"
#import "HistoryAndCategorySearchVC.h"
#import "HistorySearchVC.h"
#import "CKSlideMenu.h"
#import "SlideParentVC.h"
#import "SlideSub1.h"
#import "MessageCenterVC.h"

@interface TabViewController_1 ()
{
    // 子viewController
    SlideSub1 *vcSub1 ;  // 首页
    NSMutableArray  *arrSubViewController;
    
    
    int iMenuTopY;   // 菜单控件的顶点坐标
    CKSlideMenu *slideMenu;   // 菜单控件
    NSMutableArray *titles;  // 菜单标题
    UIButton *selMenuBtn;  // 选择的菜单按钮
    
    UIView *background;  //弹框背景
}
@end

@implementation TabViewController_1

#pragma mark  ---   lifcycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"首页"];
    
    
    if  ([CommonInfo isLoggedIn])
     {
        //登陆成功,发送通知更新用户信息
        [[NSNotificationCenter defaultCenter] postNotificationName:DDGNotificationAccountNeedRefresh object:nil];
        
        //[self performSelector:@selector(isPopView) withObject:nil afterDelay:2.0];// 延迟执行
        if (_haveAppeared)
         {
            [self isPopView];
         }
        
        [self getCartCount];
     }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"首页"];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self initData];
    
    [self layoutUI];
    
    [self performSelector:@selector(isPopView) withObject:nil afterDelay:2.0];// 延迟执行
    
    // 购物车需要计算的通知函数 注册
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getCartCount) name:DDGCartNeedCountNotification object:nil];
}

-(void)initData
{
    titles = [[NSMutableArray alloc] init];
    arrSubViewController = [[NSMutableArray alloc] init];
}

#pragma mark --- 布局UI
-(void)layoutUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 布局头部
    [self layoutHead];
    
    // 请求菜单数据  （屏蔽掉菜单分类）
    //[self getMenuFromWeb];
    
    // 布局中间
    
    
}

-(void) layoutHead
{
    // 布局头部
    int iTopY =  IS_IPHONE_X_MORE? 40:30;
    int iLeftX = 15;
    UIImageView *imgICON = [[UIImageView alloc] initWithFrame:CGRectMake(iLeftX, iTopY +2, 50, 17)];
    [self.view addSubview:imgICON];
    imgICON.image = [UIImage imageNamed:@"Tab1_TGW"];
    
    // 搜索框
    iLeftX += imgICON.width + 10;
    UIView *viewSearch = [[UIView alloc] initWithFrame:CGRectMake(iLeftX , iTopY-5, SCREEN_WIDTH - iLeftX - 40, 30)];
    [self.view addSubview:viewSearch];
    viewSearch.cornerRadius = 5;
    viewSearch.backgroundColor = [ResourceManager viewBackgroundColor];
    
    UITapGestureRecognizer * gestureSearch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionSearch1)];
    gestureSearch.numberOfTapsRequired  = 1;
    viewSearch.userInteractionEnabled = YES;
    [viewSearch addGestureRecognizer:gestureSearch];
    
    UIImageView *imgSearch = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 15, 15)];
    [viewSearch addSubview:imgSearch];
    imgSearch.image = [UIImage imageNamed:@"Tab1_Search"];
    
    UILabel *labelSearch = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, viewSearch.width - 35, 20)];
    [viewSearch addSubview:labelSearch];
    labelSearch.font = [UIFont systemFontOfSize:14];
    labelSearch.textColor = [ResourceManager midGrayColor];
    labelSearch.text = @"百里挑一的好商品";
    
    // 消息按钮
    UIButton *btnMessage = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30, iTopY+1, 17 * ScaleSize, 18 * ScaleSize)];
    [self.view addSubview:btnMessage];
    [btnMessage setBackgroundImage:[UIImage imageNamed:@"Tab1_Message"] forState:UIControlStateNormal];
    [btnMessage addTarget: self action:@selector(actionMessage) forControlEvents:UIControlEventTouchUpInside];
    
    
    // 滚动菜单
    iTopY += viewSearch.height ;
    iMenuTopY = iTopY;
    
    [self layoutMain];
    
    
    
    
}

-(void) layoutMain
{
//    // 加载推荐页面
//    SlideSub1 *VC = [[SlideSub1 alloc] init];
//    VC.view.frame = CGRectMake(0, iMenuTopY, SCREEN_WIDTH, SCREEN_HEIGHT - iMenuTopY - TabbarHeight);
//    VC.slideModel = [[SlideModel alloc] init];
//    VC.view.backgroundColor = [UIColor yellowColor];
//
//
//    //[self.view addSubview:VC.view];
//
//    [self addChildViewController:VC];
    
    // 加载推荐页面
    vcSub1 = [[SlideSub1 alloc] init];
    [self.view addSubview:vcSub1.view];
    [self addChildViewController:vcSub1];  // 加了这句，才能让子ViewController响应生命周期函数
    
    
    // 设置了很多方法，只有这样设置才能正确设置子sub的view的大小
    CGRect frameTemp = self.view.frame;
    frameTemp.origin.y = iMenuTopY;
    frameTemp.size.height = self.view.frame.size.height - iMenuTopY - TabbarHeight;
    vcSub1.view.frame = frameTemp;
    vcSub1.slideModel = [[SlideModel alloc] init];  // 一定要初始化， 否则赋值会失败
    vcSub1.view.backgroundColor = [UIColor whiteColor];

    

}


-(void) layoutMenu:(NSArray *) arrMenu
{

    int iTopY = iMenuTopY;
    
    int iCount = (int)[arrMenu count];
    
    [titles removeAllObjects];
    [arrSubViewController removeAllObjects];
    
    // 手动加入推荐菜单 和 推荐页面
    [titles addObject:@"推荐"];
    SlideParentVC *VC = [[SlideParentVC alloc] init];
    VC.slideModel = [[SlideModel alloc] init];
    VC.slideModel.iSlideID = -1;
    VC.slideModel.cateName = @"推荐";
    VC.slideModel.cateCode = @"000000";
    [arrSubViewController addObject:VC];
    
    for (int i = 0; i <iCount ; i++)
     {

        NSDictionary *dicObject = arrMenu[i];
        NSString *cateName = dicObject[@"cateName"];
        NSString *cateCode = dicObject[@"cateCode"];

        if (cateCode &&
            cateName)
         {
            SlideParentVC *VC = [[SlideParentVC alloc] init];
            VC.slideModel = [[SlideModel alloc] init];
            VC.slideModel.iSlideID = i;
            VC.slideModel.cateName = cateName;
            VC.slideModel.cateCode = cateCode;

            
            [titles addObject:cateName];
            [arrSubViewController addObject:VC];
         }
     }
////
////    // 重置
////    [slideMenu reloadTitles:titles controllers:arr atIndex: 0];
//
//    int iTopY = iMenuTopY;
//    [titles addObject:@"推荐"];
//    [titles addObject:@"母婴"];
//    [titles addObject:@"洗护"];
//    [titles addObject:@"食品"];
//    [titles addObject:@"医疗"];
//
//    NSMutableArray *arr = [NSMutableArray array];
//    for (int i = 0; i <titles.count ; i++) {
//        SlideParentVC *VC = [[SlideParentVC alloc] init];
//        VC.slideModel = [[SlideModel alloc] init];
//        VC.slideModel.iSlideID = i;
//        VC.slideModel.cateName = titles[i];
//        [arr addObject:VC];
//    }
    
    
    
    
    slideMenu = [[CKSlideMenu alloc]initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH-30, 40) titles:titles controllers:arrSubViewController];
    //slideMenu.backgroundColor = [UIColor yellowColor];
    if ([titles count] <= 5)
     {
        slideMenu.isFixed = TRUE; // 菜单固定
     }
    slideMenu.bodyFrame = CGRectMake(0,  iTopY + 40, self.view.frame.size.width, SCREEN_HEIGHT - 40 - iTopY- TabbarHeight);
    [slideMenu scrollToIndex:0];
    [self.view addSubview:slideMenu];
    //[self addChildViewController:slideMenu];
    
    
    UIButton *btnDonw = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, iTopY, 40, 40)];
    [self.view addSubview:btnDonw];
    [btnDonw addTarget:self action:@selector(popMenu) forControlEvents:UIControlEventTouchUpInside];
    //btnDonw.backgroundColor = [UIColor blueColor];
    //[btnAll setBackgroundImage:[UIImage imageNamed:@"com_down"] forState:UIControlStateNormal];
    
    UIImageView *imgDown = [[UIImageView alloc] initWithFrame:CGRectMake(18, 18, 12, 7)];
    [btnDonw addSubview:imgDown];
    imgDown.image = [UIImage imageNamed:@"com_down"];
}


-(void)addButtonView{
    [self.view addSubview:self.tabBar];
}



-(void) popMenu
{
    //创建一个黑色背景
    //初始化一个用来当做背景的View
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    background = bgView;
    //bgView.backgroundColor =  [[UIColor blackColor]colorWithAlphaComponent:0.6];//[UIColor clearColor];
    [self.view addSubview:bgView];
    
    int iTopY = slideMenu.top;
    UIView *viewTail = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, SCREEN_HEIGHT - iTopY)];
    [bgView addSubview:viewTail];
    viewTail.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    
    
    UIView *viewMenu = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 200)];
    [bgView addSubview:viewMenu];
    viewMenu.backgroundColor = [UIColor whiteColor];
    
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, 40)];
    [viewMenu addSubview:labelTitle];
    labelTitle.font = [UIFont systemFontOfSize:15];
    labelTitle.textColor = [ResourceManager color_1];
    labelTitle.text = @"全部分类";
    
    
    UIButton  *btnUp = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 0, 40, 40)];
    [viewMenu addSubview:btnUp];
    btnUp.userInteractionEnabled = NO;
    
    UIImageView *imgUp = [[UIImageView alloc] initWithFrame:CGRectMake(18, 18, 12, 7)];
    [btnUp addSubview:imgUp];
    imgUp.image = [UIImage imageNamed:@"com_up"];
    
    
    int iBtnBetween = 15;
    int iBtnWdith = (SCREEN_WIDTH - 5 * iBtnBetween)/4;
    int iBtnHeight = 25;
    int iBtnLeftX = iBtnBetween;
    int iBtnTopY = 40 + 5;
    int iTitleCount = (int)[titles count];
    
    for (int i = 0; i < iTitleCount; i++)
     {
        UIButton *btnTemp = [[UIButton alloc] initWithFrame:CGRectMake(iBtnLeftX, iBtnTopY, iBtnWdith, iBtnHeight)];
        [viewMenu addSubview:btnTemp];
        //btnTemp.backgroundColor = [UIColor yellowColor];
        [btnTemp setTitle:titles[i] forState:UIControlStateNormal];
        [btnTemp setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        btnTemp.titleLabel.font = [UIFont systemFontOfSize:12];
        btnTemp.layer.borderColor = [ResourceManager midGrayColor].CGColor;
        btnTemp.layer.borderWidth = 1;
        btnTemp.tag = i;
        [btnTemp addTarget:self action:@selector(actionMenu:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == [slideMenu getScrollIndex])
         {
            selMenuBtn = btnTemp;
            selMenuBtn.layer.borderColor = [ResourceManager mainColor].CGColor;
            [selMenuBtn setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
         }
        
        if ((i + 1 )% 4 == 0)
         {
            iBtnTopY += iBtnHeight + iBtnBetween;
            iBtnLeftX = iBtnBetween ;
            
         }
        else
         {
            iBtnLeftX += iBtnBetween + iBtnWdith;
         }
     }
    
    if (iTitleCount > 0 &&
        iTitleCount%4 != 0)
     {
        iBtnTopY += iBtnHeight + iBtnBetween;
     }
    viewMenu.height = iBtnTopY;
    
    
    bgView.userInteractionEnabled = YES;
    //添加点击手势（点击任意地方，退出全屏）
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    [bgView addGestureRecognizer:tapGesture];
    
    //[self shakeToShow:bgView];//放大过程中的动画
}

-(void) closeView
{
    [background removeFromSuperview];
}

// 是否 有弹出框
-(void) isPopView
{
    
    NSString *isYSXY = [[NSUserDefaults standardUserDefaults]objectForKey:K_Home_IS_YSXY];
    if (![isYSXY isEqualToString:@"1"])
     {
        // 如果没有点击过 隐私协议
        [self popYSXY];
        return;
     }
    
    
    if ([CommonInfo isLoggedIn])
     {
        [self getPopFromWeb];
     }
}

#pragma mark ---  布局弹出框
// 隐私协议弹出框
-(void) popYSXY
{
    CDWAlertView *alertView = [[CDWAlertView alloc] init];
    
    alertView.shouldDismissOnTapOutside = NO;
    alertView.textAlignment = RTTextAlignmentCenter;
    
    // 降低高度,加入标题
    [alertView subAlertCurHeight:20];
    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 18 color=#000000>用户隐私政策概要</font>"]];
    
    // 加入message
    NSString *strXH= [NSString stringWithFormat:@" 深圳市小小信息技术有限公司及各关联公司（以下统称“小小信息”或“我们”）一向庄严承诺保护使用小小信息的产品和服务（以下统称“小小信息服务”）之用户（以下统称“用户”或“您”）的隐私。您在使用小小信息服务时，我们可能会收集和使用您的相关信息。我们会采用符合业界标准的安全防护措施，包括建立合理的制度规范、安全技术来防止您的信息遭到未经授权的访问使用、修改,避免数据的损坏或丢失。网络服务采取了多种加密技术，例如在某些服务中，我们将利用加密技术（例如SSL）来保护您的信息，采取加密技术对您的信息进行加密保存，并通过隔离技术进行隔离。"];
    [alertView addSubTitle:[NSString stringWithFormat:@"<font size = 12 color=#333333> %@ </font>",strXH]];
    
    
    
    
    UIView *viewCKXY = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270.0*ScaleSize, 20)];
    //viewCKXY.backgroundColor = [UIColor yellowColor];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 200, 20)];
    [viewCKXY addSubview:label1];
    label1.font = [UIFont systemFontOfSize:12];
    label1.textColor = [ResourceManager color_1];
    
    NSString *strAll = [NSString stringWithFormat:@"您可以查看完整版  隐私协议"];
    NSString *strSub = [NSString stringWithFormat:@"隐私协议"];
    NSRange range = [strAll rangeOfString:strSub];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strAll];
    //NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    [str addAttribute:NSForegroundColorAttributeName value:[ResourceManager blueColor] range:range]; //设置字体颜色
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range]; //设置下划线
    label1.attributedText = str;
    
    [alertView addView:viewCKXY leftX:0];

    viewCKXY.userInteractionEnabled = YES;
    //添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionYSXY)];
    [viewCKXY addGestureRecognizer:tapGesture];
    
    [alertView subAlertCurHeight:10];
    
    [alertView addButton:@"同意协议" color:[ResourceManager mainColor] actionBlock:^{
        
        
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"1" forKey:K_Home_IS_YSXY];

        
    }];
    
    [alertView showAlertView:self duration:0.0];
}

-(void) popPng:(NSDictionary*) dicValue
{
    if (background)
     {
        return;
     }
    
    __block NSString *imageUrl =  [NSString stringWithFormat:@"%@", dicValue[@"imageUrl"]];
    if (imageUrl.length <= 8)
     {
        return;
     }
    
    //创建一个黑色背景
    //初始化一个用来当做背景的View
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    background = bgView;
    bgView.backgroundColor =  [[UIColor blackColor]colorWithAlphaComponent:0.6];//[UIColor clearColor];
    [self.view addSubview:bgView];
    
    int iTopY = slideMenu.top + 100;
    __block int iImgWidth = 300;
    __block int iImgHeight = 460;
    __block  UIImageView *imgPng = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - iImgWidth)/2, iTopY, iImgWidth, iImgHeight)];
    [bgView addSubview:imgPng];
    //[imgPng setImageWithURL:[NSURL URLWithString:imageUrl]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            // 异步方式加载图片
            UIImage *imgTemp =  [ToolsUtlis getImgFromStr:imageUrl];
            
            if (imgTemp)
             {
                
                CGFloat fixelH = CGImageGetHeight(imgTemp.CGImage);
                CGFloat fixelW = CGImageGetWidth(imgTemp.CGImage);
                iImgHeight = fixelH *FixelScaleSize*ScaleSize;
                iImgWidth = fixelW *FixelScaleSize*ScaleSize;
             }

        //跳回主队列执行
        dispatch_async(dispatch_get_main_queue(), ^{
            
            imgPng.width = iImgWidth;
            imgPng.height = iImgHeight;
            imgPng.left = (SCREEN_WIDTH - iImgWidth)/2;
            imgPng.top = (SCREEN_HEIGHT - iImgHeight)/2;
            [imgPng setImageWithURL:[NSURL URLWithString:imageUrl]];
  
        });
        
        
        
        
    });
    
    
    objc_setAssociatedObject(bgView, "firstObject", dicValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);   //绑定参数到view
    bgView.userInteractionEnabled = YES;
    //添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionDilckPop:)];
    [bgView addGestureRecognizer:tapGesture];
}

#pragma mark ---  action
-(void) actionDilckPop:(UITapGestureRecognizer*) tap
{
    
    
    NSDictionary *first = objc_getAssociatedObject(background, "firstObject");
    if (first)
     {
        NSLog(@"first:%@",first);
        NSString *type = first[@"type"];
        if ([type isEqualToString:@"empRewarded"])
         {
            [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(4),@"index":@(0)}];
         }
        else
         {
            [self sendPop:type];
         }
        

     }
    
    
    [background removeFromSuperview];
    background = nil;
}


-(void) actionMessage
{
    NSLog(@"actionMessage");
    MessageCenterVC *VC = [[MessageCenterVC alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void) actionSearch1
{
    HistorySearchVC *searShopVC = [HistorySearchVC alloc];
    
    

    //(1)点击分类 (2)用户点击键盘"搜索"按钮  (3)点击历史搜索记录
    [searShopVC beginSearch:^(NaviBarSearchType searchType,NBSSearchShopCategoryViewCellP *categorytagP,UILabel *historyTagLabel,LLSearchBar *searchBar) {
        
        NSLog(@"historyTagLabel:%@--->searchBar:%@--->categotyTitle:%@--->%@",historyTagLabel.text,searchBar.text,categorytagP.categotyTitle,categorytagP.categotyID);
        
        searShopVC.searchBarText = @"你选择的搜索内容显示到这里";
    }];
    
    //点击了即时匹配选项
    [searShopVC resultListViewDidSelectedIndex:^(UITableView *tableView, NSInteger index) {
        //            @LLStrongObj(self);
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

-(void) actionSearch2
{
    HistoryAndCategorySearchVC *searShopVC = [HistoryAndCategorySearchVC alloc];
    //(1)点击分类 (2)用户点击键盘"搜索"按钮  (3)点击历史搜索记录
    [searShopVC beginSearch:^(NaviBarSearchType searchType,NBSSearchShopCategoryViewCellP *categorytagP,UILabel *historyTagLabel,LLSearchBar *searchBar) {
        
        NSLog(@"historyTagLabel:%@--->searchBar:%@--->categotyTitle:%@--->%@",historyTagLabel.text,searchBar.text,categorytagP.categotyTitle,categorytagP.categotyID);
        
    }];
    
    //点击了即时匹配选项
    [searShopVC resultListViewDidSelectedIndex:^(UITableView *tableView, NSInteger index) {
        
        //NSLog(@"点击了即时搜索内容第%zd行的%@数据",index,tempArray[index]);
        NSLog(@"点击了即时搜索内容第%zd行的%@数据",index,searShopVC.resultListArray[index]);
        
    }];
    
    //执行即时搜索匹配
    NSArray *tempArray =  @[@"Java", @"Python", @"Objective-C", @"Swift", @"C", @"C++", @"PHP", @"C#", @"Perl", @"Go", @"JavaScript", @"R", @"Ruby", @"MATLAB"];

    [searShopVC searchbarDidChange:^(NaviBarSearchType searchType, LLSearchBar *searchBar, NSString *searchText) {

        //FIXME:这里模拟网络请求数据!!!
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            searShopVC.resultListArray = tempArray;
        });
    }];
    
    
    [self.navigationController pushViewController:searShopVC animated:YES];
}


-(void) actionMenu:(UIButton*) sender
{
    int iTag = (int)sender.tag;
    
    if (selMenuBtn)
     {
        //selMenuBtn = btnTemp;
        selMenuBtn.layer.borderColor = [ResourceManager midGrayColor].CGColor;
        [selMenuBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
     }
    
    selMenuBtn = sender;
    selMenuBtn.layer.borderColor = [ResourceManager mainColor].CGColor;
    [selMenuBtn setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    
    [slideMenu scrollToIndex:iTag];
    
    [self closeView];
    
    
    for (int i = 0; i < [arrSubViewController count]; i++)
     {
        UIViewController *VC = arrSubViewController[i];
        [VC viewWillAppear:YES];
     }
}

// 跳到完整版 隐私协议
-(void) actionYSXY
{
    NSString *url = [NSString stringWithFormat:@"%@webMall/protocol/privacy?type=ios",[PDAPI WXSysRouteAPI]];
    [CCWebViewController showWithContro:self withUrlStr:url withTitle:@"天狗窝商城隐私协议"];
}

#pragma mark ---  网络通讯
-(void) getMenuFromWeb
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLqueryCateList];
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

-(void) getPopFromWeb
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLpopups];
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

-(void) sendPop:(NSString *)strValue
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"type"] = strValue;
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLgetCustReward];
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

-(void) getCartCount
{
    if (![CommonInfo isLoggedIn])
     {
        return;
     }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@", [PDAPI getBusiUrlString],kURLorderCartList];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      //[self handleErrorData:operation];
                                                                                  }];
    operation.tag = 1003;
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation
{
    [self.view endEditing:YES];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (operation.tag == 1000)
     {
        // 获取菜单
        NSArray *arrTitles   = operation.jsonResult.rows;
        if (arrTitles&&
            [arrTitles count] > 0)
         {
            
            
            int iCount = (int)[arrTitles count];
            if (iCount > 0)
             {
                [titles removeAllObjects];
                
                [self layoutMenu:arrTitles];
                
               }
         }
     }
    else if (operation.tag == 1001)
     {
        // 获取后台返回的弹框
        NSDictionary *dic = operation.jsonResult.attr;
        if (dic)
         {
            [self popPng:dic];
         }
     }
    else if (operation.tag == 1002)
     {
        // 发送领取奖励
     }
    else if (operation.tag == 1003)
     {
        // 获取购物车的个数
        int iShopCount = 0;
        NSArray *arr = operation.jsonResult.rows;
        for (int i = 0; i < arr.count; i++ )
         {
            NSDictionary *dic = arr[i];
            int iNum = [dic[@"num"] intValue];
            iShopCount += iNum;
         }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DDGCartUpdateNotification object:@{@"count":@(iShopCount)}];
     }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    //[MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}




@end
