//
//  CitysViewController.m
//  XXJR
//
//  Created by xxjr02 on 16/1/12.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "CitysViewController.h"

@interface CitysViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSIndexPath *_selectedCityIndex;
    
    // 区域选择的背景遮罩
    UIView *trusBackView;
}

@property(nonatomic,strong) UITableView *tableView_Right;

@end

@implementation CitysViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"选择城市"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"选择城市"];
}

-(UITableView *)tableView_Right{
    if (!_tableView_Right) {
        _tableView_Right = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, 180, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView_Right.contentInset = UIEdgeInsetsMake(NavHeight, 0, 0, 0);
        _tableView_Right.backgroundColor = [ResourceManager viewBackgroundColor];
        _tableView_Right.delegate = self;
        _tableView_Right.dataSource = self;
        _tableView_Right.tag = 102;
        [self.view addSubview:_tableView_Right];
    }
    
    return _tableView_Right;
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
    
    [self layoutNaviBarViewWithTitle:@"选择城市"];
    

    
    if (@available(iOS 11.0, *))
     {
        _NavConstraint.constant = NavHeight -50;
        if (IS_IPHONE_X_MORE)
         {
            _NavConstraint.constant = NavHeight -70;
         }
     }
    else
     {
        _NavConstraint.constant = NavHeight-30;
     }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ===
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 102) {
        NSDictionary *dic = self.dataArray[_selectedCityIndex.row];
        NSArray *arr = [dic objectForKey:@"districts"];
        return arr.count;
    }
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *citysCellID = @"citysCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:citysCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:citysCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (tableView.tag == 101) {
        cell.textLabel.text = [(NSDictionary *)[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"cityName"];
    }else if (tableView.tag == 102) {
        NSDictionary *dic = self.dataArray[_selectedCityIndex.row];
        NSArray *arr = [dic objectForKey:@"districts"];
        cell.textLabel.text =  arr[indexPath.row];  //[(NSDictionary *)[arr objectAtIndex:indexPath.row] objectForKey:@"areaName"];
    }
    
    cell.textLabel.textColor = [ResourceManager color_8];
    cell.textLabel.font = [ResourceManager font_5];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.area) {
        if (_block) {
            _block(self.dataArray[indexPath.row]);
        }
        [self.navigationController popToViewController:self.rootVC animated:YES];
    }else{
        if (tableView.tag == 101) {
            _selectedCityIndex = indexPath;
            
            // 遮罩
            trusBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            trusBackView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.3];
            trusBackView.alpha = 0.0;
            trusBackView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endSelectCityArea)];
            [trusBackView addGestureRecognizer:tap];
            [self.view insertSubview:trusBackView belowSubview:self.tableView_Right];
            
            [UIView beginAnimations:@"1" context:nil];
            [UIView setAnimationDuration:0.1];
            [UIView setAnimationDelegate:self];
            trusBackView.alpha = 1.0;
            self.tableView_Right.transform = CGAffineTransformMakeTranslation(-180, 0);
            [UIView commitAnimations];
            
            [_tableView_Right reloadData];
            
        }else if (tableView.tag == 102){
            
            [self endSelect];
            
            if (_block) {
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[_selectedCityIndex.row]];
                NSArray *arr = [dic objectForKey:@"districts"];
                
                NSString *strCity = dic[@"cityName"];
                
                // 设置市的名字
                [dic setValue:strCity forKey:@"areaName"];
                
                // 设置区的名字
                [dic setValue:(NSDictionary *)arr[indexPath.row] forKey:@"area"];
                
                
                
                _block(dic);
            }
            [self.navigationController popToViewController:self.rootVC animated:YES];
        }
        
    }
    
}

-(void)endSelectCityArea{
    
    [UIView beginAnimations:@"1" context:nil];
    [UIView setAnimationDuration:0.1];
    [UIView setAnimationDelegate:self];
    trusBackView.alpha = 0.0;
    self.tableView_Right.transform = CGAffineTransformMakeTranslation(0, 0);
    [UIView commitAnimations];
    
    if (trusBackView != nil) {
        [trusBackView removeFromSuperview];
        trusBackView = nil;
    }
}

-(void)endSelect{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        trusBackView.alpha = 0.0;
        self.tableView_Right.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:^(BOOL finished) {
        [trusBackView removeFromSuperview];
    }];
}

@end
