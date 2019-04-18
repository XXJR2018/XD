//
//  CustomerServiceManager.m
//  XXJR
//
//  Created by Cary on 16/1/8.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "CustomerServiceManager.h"

#define ServiceViewHeight       50.f


@interface CustomerServiceManager()

@property (nonatomic,strong) UIView *view;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *phoneLabel;

@property (nonatomic,strong) UIButton *phoneButton;

@property (nonatomic,strong) UIButton *messgaeButton;

@property (nonatomic,weak) id targer;

@end

//static CustomerServiceManager *manager;
#define CustomerService 89880
@implementation CustomerServiceManager

//+(CustomerServiceManager *)shareManager{
//    if (!manager) {
//        manager = [[CustomerServiceManager alloc] init];
//        [manager initView];
//    }
//    return manager;
//}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    _view = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - ServiceViewHeight, SCREEN_WIDTH, ServiceViewHeight)];
    _view.backgroundColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:0.7f];
    _view.tag = CustomerServiceViewTag;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _view.width, 0.5f)];
    line.backgroundColor = [ResourceManager color_4];
    [_view addSubview:line];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(11.f, 10.f, 30.f, 30.f)];
    imageView.image = [UIImage imageNamed:@"customerService"];
    [_view addSubview:imageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.f, 12.f, 80.f, 11.f)];
    _titleLabel.font = [ResourceManager font_9];
    _titleLabel.textColor = [ResourceManager color_8];
    [_view addSubview:_titleLabel];
    
    _phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.f, CGRectGetMaxY(_titleLabel.frame) + 6.f, 80.f, 11.f)];
    _phoneLabel.font = [ResourceManager font_9];
    _phoneLabel.textColor = [ResourceManager color_8];
    [_view addSubview:_phoneLabel];
    
    float origin_x = 150.f * SCREEN_WIDTH/320.f;
    float buttonWidth = (SCREEN_WIDTH - origin_x)/2;
    _phoneButton = [[UIButton alloc] initWithFrame:CGRectMake(origin_x, 0, buttonWidth, _view.height)];
    _phoneButton.backgroundColor = [UIColor clearColor];
    _phoneButton.layer.borderColor = [ResourceManager color_5].CGColor;
    _phoneButton.layer.borderWidth = 0.5f;
    [_phoneButton setTitle:@"打电话" forState:UIControlStateNormal];
    [_phoneButton setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
    [_phoneButton setTitleColor:[ResourceManager color_6] forState:UIControlStateSelected];
    _phoneButton.titleLabel.font = [ResourceManager font_9];
    [_phoneButton setImage:[UIImage imageNamed:@"icon_phone"] forState:UIControlStateNormal];
    _phoneButton.titleEdgeInsets = UIEdgeInsetsMake(24, -10, 0, 20.f);
    _phoneButton.imageEdgeInsets = UIEdgeInsetsMake(-6, 20, 5, 0.f);
    [_phoneButton addTarget:self action:@selector(buttonClick_1) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:_phoneButton];
    
    _messgaeButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - buttonWidth, 0, buttonWidth, _view.height)];
    _messgaeButton.backgroundColor = [UIColor clearColor];
    _messgaeButton.layer.borderColor = [ResourceManager color_5].CGColor;
    _messgaeButton.layer.borderWidth = 0.5f;
    [_messgaeButton setTitle:@"联系客服" forState:UIControlStateNormal];
    [_messgaeButton setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
    [_messgaeButton setTitleColor:[ResourceManager color_6] forState:UIControlStateSelected];
    _messgaeButton.titleLabel.font = [ResourceManager font_9];
    [_messgaeButton setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    _messgaeButton.titleEdgeInsets = UIEdgeInsetsMake(24, -20, 0, 10.f);
    _messgaeButton.imageEdgeInsets = UIEdgeInsetsMake(-11, 23, 5, 00.f);
    [_messgaeButton addTarget:self action:@selector(buttonClick_2) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:_messgaeButton];
}

-(void)buttonClick_1{
    
}

-(void)buttonClick_2{
    
}

+(void)showServiceView:(UIViewController *)viewController name:(NSString *)name phone:(NSString *)phone{
    
    CustomerServiceManager *manager = [[CustomerServiceManager alloc] init];
    manager.titleLabel.text = name;
    manager.phoneLabel.text = phone;
//    [manager.phoneButton removeTarget:manager.targer action:@selector(customerServicePhone) forControlEvents:UIControlEventTouchUpInside];
//    [manager.messgaeButton removeTarget:manager.targer action:@selector(customerServiceMessage) forControlEvents:UIControlEventTouchUpInside];
//    manager.targer = viewController;
//    [manager.phoneButton addTarget:manager.targer action:@selector(customerServicePhone) forControlEvents:UIControlEventTouchUpInside];
//    [manager.messgaeButton addTarget:manager.targer action:@selector(customerServiceMessage) forControlEvents:UIControlEventTouchUpInside];
    
    [viewController.view addSubview:manager.view];
}


@end
