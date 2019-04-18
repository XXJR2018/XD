//
//  TabBarViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/10.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "TabBarViewController.h"
#import "WCAlertview.h"
#import "PayResultVC.h"
#import "AppraiseListViewController.h"
#import "CustomerServiceViewController.h"
#import "CouponViewController.h"

#import <sys/utsname.h>

@interface TabBarViewController ()<WCALertviewDelegate>
{
    TabViewController_1 *ctl1;
    TabViewController_2 *ctl2;
    TabViewController_3 *ctl3;
    TabViewController_4 *ctl4;
    
    UINavigationController *nav1;
    UINavigationController *nav2;
    UINavigationController *nav3;
    UINavigationController *nav4;
    
    UILabel *labelCartNum;  // 购物车数量的下标
    
}

/*!
 @brief     进入后台时间
 */
@property (nonatomic, strong) NSDate *intoBackground;

/*!
 @brief     app升级下载链接  https://itunes.apple.com/us/app/tian-gou-wo-shang-cheng/id1449821012?l=zh&ls=1&mt=8
 */
@property (nonatomic, strong) NSString *APP_URL;

/*!
 @brief     开启定位
 */
@property (nonatomic, strong) CLLocationManager* locationManager;

@end

@implementation TabBarViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark === TabBarButtons
-(TabBarSelectButtn *)tab1_Button{
    if (_tab1_Button == nil){
        _tab1_Button = [[TabBarSelectButtn alloc] initWithFrame:CGRectMake(0.f, 0, SCREEN_WIDTH/4, 49.f)];
        [_tab1_Button addTarget:self action:@selector(setButtonsState:) forControlEvents:UIControlEventTouchUpInside];
        _tab1_Button.tag = 100;
        
    }
    return _tab1_Button;
}

-(TabBarSelectButtn *)tab2_Button{
    if (_tab2_Button == nil){
        _tab2_Button = [[TabBarSelectButtn alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4, 49.f)];
        [_tab2_Button addTarget:self action:@selector(setButtonsState:) forControlEvents:UIControlEventTouchUpInside];
        _tab2_Button.tag = 101;
    }
    return _tab2_Button;
}

-(TabBarSelectButtn *)tab3_Button{
    if (_tab3_Button == nil){
        _tab3_Button = [[TabBarSelectButtn alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4 * 2, 0, SCREEN_WIDTH/4, 49.f)];
        [_tab3_Button addTarget:self action:@selector(setButtonsState:) forControlEvents:UIControlEventTouchUpInside];
        
        
        labelCartNum = [[UILabel alloc] initWithFrame:CGRectMake(48, 5, 15, 15)];
        [_tab3_Button addSubview:labelCartNum];
        labelCartNum.layer.masksToBounds = YES;
        labelCartNum.layer.cornerRadius = labelCartNum.height/2;
        labelCartNum.backgroundColor = [ResourceManager priceColor];
        labelCartNum.textColor = [UIColor whiteColor];
        labelCartNum.font = [UIFont systemFontOfSize:8];
        labelCartNum.textAlignment = NSTextAlignmentCenter;
        labelCartNum.hidden = YES;
        
        _tab3_Button.tag = 102;
    }
    return _tab3_Button;
}

-(TabBarSelectButtn *)tab4_Button{
    if (_tab4_Button == nil){
        _tab4_Button = [[TabBarSelectButtn alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4 * 3, 0, SCREEN_WIDTH/4, 49.f)];
        [_tab4_Button addTarget:self action:@selector(setButtonsState:) forControlEvents:UIControlEventTouchUpInside];
        _tab4_Button.tag = 103;
    }
    return _tab4_Button;
}


-(UINavigationController *)homeViewController{
    return _homeViewController = (UINavigationController *)self.selectedViewController;
}

#pragma mark === init
-(id)init{
    self = [super init];
    
    if (self) {
        self.view.frame = [[UIScreen mainScreen] bounds];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucess:) name:DDGAccountEngineDidLoginNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSucess:) name:DDGAccountEngineDidLogoutNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleDidEnterBackgroudNotificaiton:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleWillEnterForegroundNotificaiton:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        // userInfo需要更新通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfo) name:DDGNotificationAccountNeedRefresh object:nil];
        
        // 推送消息处理
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotification:) name:DDGPushNotification object:nil];
        
        // 首页切换到别的页面的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchTab:) name:DDGSwitchTabNotification object:nil];
        
        // token过期通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenOutOfData:) name:DDGUserTokenOutOfDataNotification object:nil];
        
        // 购物车需要更新的通知函数 注册
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDateCartCount:) name:DDGCartUpdateNotification object:nil];
        
       
    }
    
    return self;
}

-(void) initMap{
    //检测定位功能是否开启
    if([CLLocationManager locationServicesEnabled]){
        if(!self.locationManager){
            self.locationManager = [[CLLocationManager alloc] init];
            if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
                
                [self.locationManager requestWhenInUseAuthorization];
                [self.locationManager requestAlwaysAuthorization];
            }
            //设置代理
            //[self.locationManager setDelegate:self];
            //设置定位精度
            [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            //设置距离筛选
            [self.locationManager setDistanceFilter:100];
            //开始定位
            [self.locationManager startUpdatingLocation];
            //设置开始识别方向
            [self.locationManager startUpdatingHeading];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 版本检测
    [self onCheckVersion];
    
    //UI处理
    [self layoutViews];

     //第一次打开该版本调用统计接口
     if ([ToolsUtlis isAppFirstLoaded]){
         [self deviceInfo];
     }
    //开启定位权限
    [self initMap];
}

-(void)layoutViews{
    _buttonsView = [[UIView alloc] initWithFrame:CGRectMake(0.f, SCREEN_HEIGHT - TabbarHeight, SCREEN_WIDTH, TabbarHeight)];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.8)];
    line.backgroundColor = [ResourceManager color_3];
    [_buttonsView addSubview:line];
    _buttonsView.backgroundColor = [UIColor whiteColor];
    _buttonsView.tag = 1010;
    
    // 布置tabBar
    self.tab1_Button.normalImage = [ResourceManager tabBar_button1_gray];
    self.tab1_Button.selectedImage = [ResourceManager tabBar_button1_selected];
    self.tab2_Button.normalImage = [ResourceManager tabBar_button2_gray];
    self.tab2_Button.selectedImage = [ResourceManager tabBar_button2_selected];
    self.tab3_Button.normalImage = [ResourceManager tabBar_button3_gray];
    self.tab3_Button.selectedImage = [ResourceManager tabBar_button3_selected];
    self.tab4_Button.normalImage = [ResourceManager tabBar_button4_gray];
    self.tab4_Button.selectedImage = [ResourceManager tabBar_button4_selected];
    
    self.tab1_Button.selectedState = YES;
    self.tab2_Button.selectedState = NO;
    self.tab3_Button.selectedState = NO;
    self.tab4_Button.selectedState = NO;
    
    [_buttonsView addSubview:self.tab1_Button];
    [_buttonsView addSubview:self.tab2_Button];
    [_buttonsView addSubview:self.tab3_Button];
    [_buttonsView addSubview:self.tab4_Button];
    
    [self.tabBar removeFromSuperview];
    
    [self initViewControllers];
    
    [self ShowControllers];
    [self setButtonsState:self.tab1_Button];
}


-(void)initViewControllers{
    
    ctl1=[[TabViewController_1 alloc] init];
    nav1=[[UINavigationController alloc] initWithRootViewController:ctl1];
    
    ctl2 =[[TabViewController_2 alloc] init];
    nav2=[[UINavigationController alloc] initWithRootViewController:ctl2];
    
    ctl3 =[[TabViewController_3 alloc] init];
    nav3=[[UINavigationController alloc] initWithRootViewController:ctl3];
    
    ctl4 =[[TabViewController_4 alloc] init];
    nav4=[[UINavigationController alloc] initWithRootViewController:ctl4];
    
    ctl1.tabBar = ctl2.tabBar = ctl3.tabBar = ctl4.tabBar = self.buttonsView;
    
    [nav1 setNavigationBarHidden:NO];
    [nav1.navigationBar setHidden:YES];
    [nav2 setNavigationBarHidden:NO];
    [nav2.navigationBar setHidden:YES];
    [nav3 setNavigationBarHidden:NO];
    [nav3.navigationBar setHidden:YES];
    [nav4 setNavigationBarHidden:NO];
    [nav4.navigationBar setHidden:YES];
}

-(void)ShowControllers{
    self.viewControllers=@[nav1,nav2,nav3,nav4];
}

-(void)loginSucess:(NSNotification *)notification{
    if (nav1) {
        [nav1 popToRootViewControllerAnimated:NO];
    }
    if (nav2) {
        [nav2 popToRootViewControllerAnimated:NO];
    }
    if (nav3) {
        [nav3 popToRootViewControllerAnimated:NO];
    }
    if (nav4) {
        [nav4 popToRootViewControllerAnimated:NO];
    }
    [self setButtonsState:self.tab1_Button];
}

-(void)logoutSucess:(NSNotification *)notification{
    [self setButtonsState:self.tab1_Button];
    
    //注销极光推送  删除别名
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
    } seq:0];
    [CommonInfo AllDeleteInfo];
    [DDGUserInfoEngine engine].parentViewController = self;
    [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
}


-(void)tokenOutOfData:(NSNotification *)notification{
    //注销极光推送  删除别名
    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
    } seq:0];
    
    [CommonInfo AllDeleteInfo];
    [self setButtonsState:self.tab1_Button];
    
    [DDGUserInfoEngine engine].parentViewController = self;
    [[DDGUserInfoEngine engine] finishUserInfoWithFinish:nil];
    if ([[DDGAccountManager sharedManager] isLoggedIn]) {
        [MBProgressHUD showErrorWithStatus:@"登录超时，请重新登录" toView:[DDGUserInfoEngine engine].loginViewController.view];
    }
}

/*
 * TabBar按钮显示状态
 */
-(void)setButtonsState:(TabBarSelectButtn *)button{
    
    [_tab1_Button setSelectedState:NO];
    [_tab2_Button setSelectedState:NO];
    [_tab3_Button setSelectedState:NO];
    [_tab4_Button setSelectedState:NO];
    
    if (button.tag == 100) {
        _tab1_Button.selectedState = YES;
        [ctl1 addButtonView];
    }else if (button.tag == 101) {
        _tab2_Button.selectedState = YES;
        [ctl2 addButtonView];
    }else if (button.tag == 102) {
        _tab3_Button.selectedState = YES;
        [ctl3 addButtonView];
    }else if (button.tag == 103) {
        _tab4_Button.selectedState = YES;
        [ctl4 addButtonView];
    }
    self.selectedIndex = button.tag - 100;
}


#pragma mark ---通知事件
#pragma mark notification
-(void)switchTab:(NSNotification *)notification{
    NSLog(@"user info is %@",notification.object);
    NSDictionary *dic = notification.object;
    int tab = [[dic objectForKey:@"tab"] intValue];
    if ( tab == 1) {
        [self setButtonsState:_tab1_Button];
    }else if (tab == 2) {
        [self setButtonsState:_tab2_Button];
    }else if (tab == 3) {
        [self setButtonsState:_tab3_Button];
    }else if (tab == 4) {
        [self setButtonsState:_tab4_Button];
        int index = [[(NSDictionary *)notification.object objectForKey:@"index"] intValue];
        if (index == 1) {
            //评论
            AppraiseListViewController *ctl = [[AppraiseListViewController alloc] init];
            ctl.appraiseType = 2;
            [nav4 pushViewController:ctl animated:NO];
        }
        if (index == 2) {
            //客服
            CustomerServiceViewController *ctl = [[CustomerServiceViewController alloc] init];
            [nav4 pushViewController:ctl animated:NO];
        }
        if (index == 3) {
            //购物劵
            CouponViewController *ctl = [[CouponViewController alloc] init];
            ctl.couponType = 2;
            [nav4 pushViewController:ctl animated:NO];
        }
    }
}

// 更新购物车下标
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

-(void)pushNotification:(NSNotification *)notification{
    NSLog(@"user info is %@",notification.userInfo);
    if (notification.userInfo.count > 0) {
        if ([notification.userInfo objectForKey:@"extraData"]) {
            NSString *extraDataStr = [NSString stringWithFormat:@"%@",[notification.userInfo objectForKey:@"extraData"]];
            if (extraDataStr.length > 0) {
                NSData *jsonData = [extraDataStr dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                    options:NSJSONReadingMutableContainers
                                                                      error:&err];
                if (dic.count > 0) {
                    if ([[dic objectForKey:@"type"] intValue] == 1) {
                        //原生页面
                        NSString *iosClassName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"iosClassName"]];
                        if (iosClassName.length > 0) {
                            [self PushNextViewControllerWith:iosClassName];
                        }
                    }else if ([[dic objectForKey:@"type"] intValue] == 2) {
                        //h5
                        CCWebViewController *webContro = [CCWebViewController new];
                        webContro.homeUrl = [NSURL URLWithString:[dic objectForKey:@"url"]];
                        [self.homeViewController pushViewController:webContro animated:YES];
                    }
                }
            }
        }
    }
}

- (void)handleDidEnterBackgroudNotificaiton:(NSNotification *)notification{
    //程序退到后台的时间
    self.intoBackground = [NSDate date];
}

- (void)handleWillEnterForegroundNotificaiton:(NSNotification *)notification{
//    此行不注释掉微信登陆会偶尔黑屏
//    CFRunLoopRunInMode(kCFRunLoopDefaultMode,0.4, NO);
}

#pragma mark  ---  传类名， 跳转页面
- (void)PushNextViewControllerWith:(NSString *)VCName {
    // 类名
    const char *className = [VCName cStringUsingEncoding:NSASCIIStringEncoding];
    // 从一个字串返回一个类
    Class newClass = objc_getClass(className);
    if (!newClass){
        // 创建一个类
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        // 注册你创建的这个类
        objc_registerClassPair(newClass);
    }
    // 创建对象
    id instance = [[newClass alloc] init];
    [self.homeViewController pushViewController:instance animated:YES];

}

/*!
 @brief 网络变化的通知回调
 */
- (void)reachabilityChanged:(NSNotification *)notification{
    if ([ToolsUtlis isNetworkReachable]){
        
    }else{
        [MBProgressHUD showNoNetworkHUDToView:self.view];
    }
}

#pragma mark - 判断版本更新
-(void)onCheckVersion{
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI getCheckVersionAPI]
                                                                               parameters:@{@"appID":@"tgwscIOS"} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      NSDictionary *dic = operation.jsonResult.attr;
                                                                                      //升级弹窗
                                                                                      [self upVersionAlertView:dic];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      NSLog(@"error ==== %@",operation.jsonResult.message);
                                                                                  }];
    [operation start];
}

//升级弹窗
-(void)upVersionAlertView:(NSDictionary*) dic{
    self.APP_URL = [NSString stringWithFormat:@"%@",[dic objectForKey:@"upUrl"]];
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    currentVersion = [currentVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *upVersion = [dic objectForKey:@"upVersion"];
    upVersion = [upVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *forceUpVersion = [dic objectForKey:@"forceUpgradeVersion"];
    forceUpVersion = [forceUpVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    //判断升级
    if (currentVersion.integerValue  < upVersion.integerValue && [[CommonInfo Verify] intValue] != 1) {
        if (currentVersion.integerValue <= forceUpVersion.integerValue) {
            //强制升级
            NSString *message = [NSString stringWithFormat:@"%@",[dic objectForKey:@"upDesc"]];
            WCAlertview * alert = [[WCAlertview alloc] initWithTitle:[NSString stringWithFormat:@"V%@",[dic objectForKey:@"upVersion"]]
                                                             Message:message
                                                            OkButton:@"立即升级"
                                                        CancelButton:nil];
            alert.delegate = self;
            [alert show];
        }else{
            //非强制升级
            NSString *message = [NSString stringWithFormat:@"%@",[dic objectForKey:@"upDesc"]];
            WCAlertview * alert = [[WCAlertview alloc] initWithTitle:[NSString stringWithFormat:@"V%@",[dic objectForKey:@"upVersion"]]
                                                             Message:message
                                                            OkButton:@"立即升级"
                                                        CancelButton:@"下次再说"];
            alert.strVerion = [NSString stringWithFormat:@"版本：v%@",[dic objectForKey:@"upVersion"]];
            alert.delegate = self;
            [alert show];
        }
    }    
}

-(void)didClickButtonAtIndex:(NSUInteger)index{
    switch (index) {
        case 0:{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.APP_URL] options:@{} completionHandler:nil];
        }break;
        case 1:{
            
        }break;
        default:
            break;
    }
}

//获取并保存用户信息
-(void)getUserInfo {
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[PDAPI getUserBaseInfoAPI]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                  }];
    [operation start];
}

//统计接口 客户端上传基本信息
-(void)deviceInfo {
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    NSString *resolution = [NSString stringWithFormat:@"%.0f*%.0f",width*scale_screen ,height*scale_screen];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"os"] = @"ios";
    params[@"st"] = [[UIDevice currentDevice] systemVersion];;
    params[@"brand"] = @"iphone";
    params[@"model"] = [self iphoneType];
    params[@"resolution"] = resolution;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/front/record/deviceInfo",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                          //更新第一次打开该版本信息
                                                                                          [ToolsUtlis saveBundleVersion];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                  }];
    [operation start];
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    // 保存用户信息
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[operation.jsonResult.attr objectForKey:@"custInfo"]];
    for (NSString *key in dic.allKeys) {   //避免NULL字段
        if ([[dic objectForKey:key] isEqual:[NSNull null]]) {
            [dic setValue:@"" forKey:key];
        }
    }
   
    [CommonInfo setUserInfo:dic];
    [CommonInfo setKey:K_ShopTopImgUrl withValue:[operation.jsonResult.attr objectForKey:@"shareBgImg"]];
    
    //用户信息保存成功，更新显示用户信息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationChangeUserInfo" object:nil];
    
}

- (NSString *)iphoneType {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
   
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";

    if([platform isEqualToString:@"iPhone9,4"])  return @"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    
    if([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    
    if([platform isEqualToString:@"iPhone11,4"]) return @"iPhone XS Max";
    
    if([platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    
    if([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
    
}



@end
