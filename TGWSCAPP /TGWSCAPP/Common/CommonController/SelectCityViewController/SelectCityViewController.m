//
//  SelectCityViewController.m
//  XXJR
//
//  Created by xxjr02 on 16/1/12.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "SelectCityViewController.h"
#import "CitysViewController.h"
#import "LocationManager.h"

#define ButtonTag 89830
#define CityFile   @"cityjson.json"


#define K_CITY_NETVESION     @"K_City_NetVesion"     // 城市信息的网络版本号
#define K_CITY_CURVESION     @"K_City_CurVesion"     // 城市信息的当前版本号

@interface CitysCellView : UIView

@property (nonatomic,strong) Block_Id block;

+(UIView *)citysView:(NSArray *)cityArr block:(Block_Id)block viewController:(UIViewController *)VC;

@end

@implementation CitysCellView

+(UIView *)citysView:(NSArray *)cityArr block:(Block_Id)block viewController:(UIViewController *)VC{
    //CitysCellView *view = [[CitysCellView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90.f)];
    CitysCellView *view = [[CitysCellView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120.f)];
    view.backgroundColor = [ResourceManager color_2];
    
    float space = 12.f;
    float buttonWidth = (SCREEN_WIDTH - 5 * space) / 4 , buttonHeight = 28.f;
    for (int i = 0; i <cityArr.count; i ++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i%4*buttonWidth + (i%4 + 1)*space, 8.f + i / 4 * 42.f, buttonWidth, buttonHeight)];
        [button setTitle:[(NSDictionary *)cityArr[i] objectForKey:@"areaName"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [ResourceManager font_5];
        [button setBackgroundColor:[UIColor whiteColor]];
        button.tag = 89830 + i;
        [button addTarget:VC action:@selector(citySelected:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
    view.tag = 100220;
    
    
    return view;
}

-(void)citySelected:(UIButton *)button{}

@end

@interface SelectCityViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *_hotCityArr;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation SelectCityViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"城市"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"城市"];
}

-(id)init{
    self = [super init];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self layoutNaviBarViewWithTitle:@"城市"];
    
    
    if (@available(iOS 11.0, *))
     {
        _NavConstraint.constant = NavHeight -30;
        if (IS_IPHONE_X_MORE)
         {
            _NavConstraint.constant = NavHeight -50;
         }
     }
    else
     {
        _NavConstraint.constant = NavHeight;
     }
    
   
    // 从缓存中读取城市信息
    NSArray *arry =  [self getCityFormCache];
    
    if (!arry)
     {
        
        // 从网络读取城市信息
        [self getCityData];
        
        // 从打包文件中读取城市信息
        arry = [self getCiytFormLocal];
     }
    
    if (arry)
     {
        [self.dataArray addObjectsFromArray:arry];
     }
    
    
    // 判断是否需要更新城市数据
    [self upCityData];

    
    _hotCityArr = @[@{@"areaId":@"1100",@"areaName":@"北京市",@"nameEn":@"BJ",@"pid":@"351",@"tempPcode":@"11"},
                    @{@"areaId":@"3101",@"areaName":@"上海市",@"nameEn":@"SH",@"pid":@"199",@"tempPcode":@"31"},
                    @{@"areaId":@"4401",@"areaName":@"广州市",@"nameEn":@"GZ",@"pid":@"304",@"tempPcode":@"44"},
                    @{@"areaId":@"4403",@"areaName":@"深圳市",@"nameEn":@"SZ",@"pid":@"304",@"tempPcode":@"44"},
                    @{@"areaId":@"4201",@"areaName":@"重庆市",@"nameEn":@"WH",@"pid":@"160",@"tempPcode":@"42"},
                    @{@"areaId":@"4301",@"areaName":@"武汉市",@"nameEn":@"WH",@"pid":@"145",@"tempPcode":@"43"},
                    @{@"areaId":@"1200",@"areaName":@"成都市",@"nameEn":@"TJ",@"pid":@"223",@"tempPcode":@"12"},
                    @{@"areaId":@"5000",@"areaName":@"昆明市",@"nameEn":@"CQ",@"pid":@"277",@"tempPcode":@"50"},
                    @{@"areaId":@"5000",@"areaName":@"长沙市",@"nameEn":@"CQ",@"pid":@"278",@"tempPcode":@"51"},
                    @{@"areaId":@"5000",@"areaName":@"苏州市",@"nameEn":@"CQ",@"pid":@"279",@"tempPcode":@"52"},
                    @{@"areaId":@"5000",@"areaName":@"南京市",@"nameEn":@"CQ",@"pid":@"280",@"tempPcode":@"53"},
                    @{@"areaId":@"5000",@"areaName":@"无锡市",@"nameEn":@"CQ",@"pid":@"281",@"tempPcode":@"54"}];
    
    if (![DDGSetting sharedSettings].locationCityString) {
        [[LocationManager shareManager] getUserLocationSuccess:^{
            [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        } failedBlock:^(int code){
            //[MBProgressHUD showErrorWithStatus:@"定位失败" toView:self.view];
        }];
    }
    
    _tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    
    
}

// 当版本号变动时， 获取城市数据
- (void) upCityData
{
    NSString *strCityCurVer = [CommonInfo getKey:K_CITY_CURVESION]; // 城市信息的当前版本号
    NSString *strCityNetVer = [CommonInfo getKey:K_CITY_NETVESION]; // 城市信息的网络版本号
    
    // 如果版本号不一致，获取城市数据
    if (![strCityCurVer isEqualToString:strCityNetVer])
     {
        [self getCityData];
     }
    
}

#pragma mark --- 请求城市数据
-(void)getCityData{
    
    

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //NSString *url = [NSString stringWithFormat:@"%@%@",@"https://newapp.xxjr.com/",@"mjb/area/allAreaInfo"];
    NSString *url = [NSString stringWithFormat:@"%@%@", [PDAPI getBaseUrlString],@"appMall/area/allAreaInfo"];
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:url
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 10210;
    
    [operation start];
}


-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    if (operation.tag == 10210) {
        
        NSDictionary *dicAttr = operation.jsonResult.attr;
        NSArray *arry = dicAttr[@"allArea"];
        NSLog(@"arry: %@" ,arry);
        
        [self  wirteToCache:arry];
        
        NSArray *arryCache =  [self getCityFormCache];
        NSLog(@"arryCache: %@" ,arryCache);
        
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:arry];
        [_tableView reloadData];
    }
}

-(BOOL)wirteToCache:(NSArray*) array
{
    //Cache目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    NSString* filePath = [NSString stringWithFormat:@"%@/%@",path, CityFile];
    
    // 数组写入文件执行的方法
    BOOL  isWirte =   [array writeToFile:filePath atomically:YES];
    
    if (isWirte)
     {
        NSString *strCityNetVer = [CommonInfo getKey:K_CITY_NETVESION]; // 城市信息的网络版本号
        [CommonInfo setKey:K_CITY_CURVESION withValue:strCityNetVer];
     }
    
    return  isWirte;
    
}

// 从Cache目录中读取城市信息
-(NSArray*) getCityFormCache
{
    //Cache目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    NSString* filePath = [NSString stringWithFormat:@"%@/%@",path, CityFile];
    
    NSArray *arry = [NSArray arrayWithContentsOfFile:filePath];
    
    return arry;
}

// 从打包文件中读取城市信息
-(NSArray*) getCiytFormLocal
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"cityjson" ofType:@"json"];
    
    NSArray *arry = [NSArray arrayWithContentsOfFile:plistPath];
    return arry;
}

#pragma mark === UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.area ? 2:3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else if (section == 1) {
        return self.area ? self.dataArray.count : 1;
    }else return self.dataArray.count;
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        
        if (_noShowHotCity)
         {
            return 0.f;
         }
        return self.area ? 44.0 : 120.0;
    }
    if (indexPath.section == 0)
     {
        // 隐藏 “当前定位的城市”
        return 0;
     }
    return 44.f;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"热门城市";
    }else if (section == 2)
        return @"全部";
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"11111"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"11111"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        //cell.textLabel.text = @"当前定位城市：";
        cell.textLabel.text = @"";//@"当前定位城市：";
        cell.textLabel.textColor = [ResourceManager color_6];
        cell.textLabel.font = [ResourceManager font_7];
        cell.detailTextLabel.textColor = [ResourceManager redColor2];
        [self performBlock:^{
            cell.detailTextLabel.text = [DDGSetting sharedSettings].locationCityString;
        } afterDelay:1];
        cell.detailTextLabel.font = [ResourceManager font_7];
        cell.imageView.image = [UIImage imageNamed:@"location"];
        return cell;
    }else if(indexPath.section == 1 && !self.area){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"222222"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"222222"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"222222";
//        cell.backgroundColor = [UIColor clearColor];
        
        UIView *subView = [cell.contentView viewWithTag:100230];
        if (!subView) {
            if (_noShowHotCity)
             {
                cell.textLabel.text = @"";
                return cell;
             }
            
            [cell.contentView addSubview:[CitysCellView citysView:_hotCityArr block:nil viewController:self]];
        }
        
        return cell;
    }else if (indexPath.section == 2 || (indexPath.section == 1 && self.area)){
        static NSString *selectCityCellID = @"selectCityCellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:selectCityCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:selectCityCellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [dic objectForKey:@"provinceName"];
        cell.textLabel.textColor = [ResourceManager color_8];
        cell.textLabel.font = [ResourceManager font_5];
        
        return cell;
    }else {
        return nil;
    }
}


#pragma mark === UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    // 遮挡分割线的view
    UIView *subView = [view viewWithTag:100230];
    if (section == 1 && !subView) {
        UIView *baffleView = [[UIView alloc] initWithFrame:CGRectMake(0, 37.f, SCREEN_WIDTH, 2)];
        baffleView.backgroundColor = [ResourceManager viewBackgroundColor];
        baffleView.tag = 100230;
        [view addSubview:baffleView];
    }else if (section == 2 && !subView){
        UIView *baffleView = [[UIView alloc] initWithFrame:CGRectMake(0, -7.f, SCREEN_WIDTH, 2)];
        baffleView.backgroundColor = [ResourceManager viewBackgroundColor];
        baffleView.tag = 100230;
        [view addSubview:baffleView];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        // 定位
        [[LocationManager shareManager] getUserLocationSuccess:^{
            NSLog(@"Success");
        } failedBlock:^(int code){
            NSLog(@"failed");
        }];
    }else if (indexPath.section == 2 || (indexPath.section == 1 && self.area)) {
        CitysViewController *ctl = [[CitysViewController alloc] init];
        ctl.rootVC = self.rootVC;
        ctl.area = self.area;
        NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
        ctl.dataArray = [dic objectForKey:@"citys"];
        
        
        
        NSDictionary *provinceDic = [self.dataArray objectAtIndex:indexPath.row];
        NSString *provinceStr = [provinceDic objectForKey:@"provinceName"];
        
        ctl.block = ^(id city){
            NSMutableDictionary *cityDic = [[NSMutableDictionary alloc] initWithDictionary:city];
            [cityDic setObject:provinceStr forKey:@"province"];
            
            NSString *strCity = city[@"cityName"];
            [cityDic setObject:strCity forKey:@"areaName"];
            
            [self selectFinished:cityDic];
        };
        [self.navigationController pushViewController:ctl animated:YES];
    }
    
}

-(void)citySelected:(UIButton *)button{
    [self selectFinished:(NSDictionary *)_hotCityArr[button.tag - ButtonTag]];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectFinished:(NSDictionary *)city{
    if (_block) {
        _block(city);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
