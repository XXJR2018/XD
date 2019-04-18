//
//  AddAddressViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/27.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "AddAddressViewController.h"
#import "SelectCityViewController.h"

@interface AddAddressViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIView *_adderssPickerView;
    UIPickerView *_pickerView;
    NSArray *_provinceArr;
    NSArray *_cityArr;
    NSArray *_districtArr;
    NSString *_provinceStr;
    NSString *_cityStr;
    NSString *_districtStr;
}
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *streetAdderssField;
@property (weak, nonatomic) IBOutlet UITextField *zipCodeField;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *acquiesceBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTop;
@end

@implementation AddAddressViewController

-(void)loadData{
    [MBProgressHUD showHUDAddedTo:self.view];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/area/allAreaInfo",[PDAPI getBaseUrlString]]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
    operation.tag = 1000;
}

-(void)addAddressUrl{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"receiveName"] = self.nameField.text;
    params[@"receiveTel"] = self.phoneField.text;
    params[@"province"] = _provinceStr;
    params[@"cityName"] = _cityStr;
    params[@"area"] = _districtStr;
    params[@"addrDetail"] = self.streetAdderssField.text;
    params[@"postCode"] = self.zipCodeField.text;
    params[@"isDefault"] = @"0";
    if (self.acquiesceBtn.selected) {
        params[@"isDefault"] = @"1";
    }
    if (self.addressDic.count > 0) {
        params[@"addrId"] = [NSString stringWithFormat:@"%@",[_addressDic objectForKey:@"addrId"]];
    }
    NSString *urlStr;
    if ([self.titleStr isEqualToString:@"新增地址"]) {
        urlStr = @"appMall/account/custAddr/add";
    }else{
        urlStr = @"appMall/account/custAddr/update";
    }
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],urlStr]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
    operation.tag = 1001;
}

-(void)delectAddressUrl{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.addressDic.count > 0) {
        params[@"addrId"] = [NSString stringWithFormat:@"%@",[_addressDic objectForKey:@"addrId"]];
    }
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/custAddr/delete",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
    operation.tag = 1002;
}
#pragma mark 数据操作
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    if (operation.tag == 1000) {
        if (operation.jsonResult.attr.count > 0) {
            _provinceArr = [operation.jsonResult.attr objectForKey:@"allArea"];
            if (_provinceArr &&
                _provinceArr.count > 0 )
             {
                _cityArr = [(NSDictionary *)_provinceArr[0] objectForKey:@"citys"];
                if (_cityArr &&
                    _cityArr.count > 0)
                 {
                    _districtArr = [(NSDictionary *)_cityArr[0] objectForKey:@"districts"];
                 }
             }
        }
    }else if (operation.tag == 1001) {
        [MBProgressHUD showSuccessWithStatus:@"修改地址成功" toView:self.view];
        //发送通知更新用户信息
        [[NSNotificationCenter defaultCenter] postNotificationName:DDGNotificationAccountNeedRefresh object:nil];
        self.addressBlock();
        [self performBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        } afterDelay:1];
    }else{
        [MBProgressHUD showSuccessWithStatus:@"删除地址成功" toView:self.view];
        //发送通知更新用户信息
        [[NSNotificationCenter defaultCenter] postNotificationName:DDGNotificationAccountNeedRefresh object:nil];
        self.addressBlock();
        [self performBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        } afterDelay:1];
    }
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (iOS11Less) {
        self.layoutTop.constant = NavHeight;
    }
    
    CustomNavigationBarView *naviBarView  = [self layoutNaviBarViewWithTitle:self.titleStr];
    
    if ([self.titleStr isEqualToString:@"修改地址"]) {
        UIButton *delectBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60, NavHeight - 35, 60, 30)];
        [naviBarView addSubview:delectBtn];
        [delectBtn setTitle:@"删除" forState:UIControlStateNormal];
        delectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [delectBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        [delectBtn addTarget:self action:@selector(delectAddressUrl) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self layoutUI];
    
}

-(void)layoutUI{
    self.saveBtn.layer.borderWidth = 0.5;
    self.saveBtn.layer.borderColor = [ResourceManager mainColor].CGColor;
    
    if (self.addressDic.count > 0) {
        self.nameField.text = [NSString stringWithFormat:@"%@",[_addressDic objectForKey:@"receiveName"]];
        self.phoneField.text = [NSString stringWithFormat:@"%@",[_addressDic objectForKey:@"receiveTel"]];
        _provinceStr = [NSString stringWithFormat:@"%@",[_addressDic objectForKey:@"province"]];
        _cityStr = [NSString stringWithFormat:@"%@",[_addressDic objectForKey:@"cityName"]];
        _districtStr = [NSString stringWithFormat:@"%@",[_addressDic objectForKey:@"area"]];
        self.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@",_provinceStr,_cityStr,_districtStr];
        self.streetAdderssField.text = [NSString stringWithFormat:@"%@",[_addressDic objectForKey:@"addrDetail"]];
        if ([_addressDic objectForKey:@"postCode"] && [NSString stringWithFormat:@"%@",[_addressDic objectForKey:@"postCode"]].length > 0) {
            self.zipCodeField.text = [NSString stringWithFormat:@"%@",[_addressDic objectForKey:@"postCode"]];
        }
        if ([[_addressDic objectForKey:@"isDefault"] intValue] == 1) {
            self.acquiesceBtn.selected = YES;
        }
    }
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
}

//添加手势点击空白处隐藏键盘
-(void)TouchViewKeyBoard{
    [self.view endEditing:YES];
}

-(void)pickViewerUI{
    [_adderssPickerView removeFromSuperview];
    
    _adderssPickerView = [[UIView alloc]initWithFrame:CGRectMake(0.f, SCREEN_HEIGHT - 220, SCREEN_WIDTH,220)];
    [self.view addSubview:_adderssPickerView];
    _adderssPickerView.backgroundColor = [UIColor whiteColor];

    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(10.f, 10.f, 60.f, 30.f)];
    [_adderssPickerView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    
    UIButton *finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 70.f, 10.f, 60.f, 30.f)];
    [_adderssPickerView addSubview:finishBtn];
    [finishBtn addTarget:self action:@selector(finishBtn) forControlEvents:UIControlEventTouchUpInside];
    [finishBtn setTitle:@"确定" forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [finishBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];

//    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0.f, 40.f, SCREEN_WIDTH, 180.f)];
//    _pickerView.delegate = self;
//    _pickerView.dataSource = self;
//    _pickerView.backgroundColor = [UIColor whiteColor];
//    [_adderssPickerView addSubview:_pickerView];
    
//    [_pickerView selectRow:0 inComponent:0 animated:YES];
//    [_pickerView selectRow:0 inComponent:1 animated:YES];
//    [_pickerView selectRow:0 inComponent:2 animated:YES];
    _provinceStr = [(NSDictionary *)_provinceArr[0] objectForKey:@"provinceName"];
    _cityStr = [(NSDictionary *)_cityArr[0] objectForKey:@"cityName"];
    _districtStr = (NSString *)_districtArr[0];
}

-(void)cancelBtn{
    [_adderssPickerView removeFromSuperview];
    _cityArr = [(NSDictionary *)_provinceArr[0] objectForKey:@"citys"];
    _districtArr = [(NSDictionary *)_cityArr[0] objectForKey:@"districts"];
}

-(void)finishBtn{
    [_adderssPickerView removeFromSuperview];
    _cityArr = [(NSDictionary *)_provinceArr[0] objectForKey:@"citys"];
    _districtArr = [(NSDictionary *)_cityArr[0] objectForKey:@"districts"];
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@",_provinceStr,_cityStr,_districtStr];
}


- (IBAction)selectAdderss:(UIButton *)sender {
    [self.view endEditing:YES];
    //[self pickViewerUI];
    
    SelectCityViewController *ctl = [[SelectCityViewController alloc] init];
    ctl.rootVC = self;
    //选择区域
    ctl.area = YES;
    ctl.block = ^(id city){
        NSDictionary * dic = city;
        _provinceStr = [dic objectForKey:@"province"];
        _cityStr = [dic objectForKey:@"areaName"];
        _districtStr = [dic objectForKey:@"area"];
        //_cityLabel.text = [NSString stringWithFormat:@"%@%@%@",[dic objectForKey:@"province"],[dic objectForKey:@"areaName"],[dic objectForKey:@"area"]];
        self.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@",_provinceStr,_cityStr,_districtStr];
    };
    
    [self.navigationController pushViewController:ctl animated:YES];
}

- (IBAction)acquiesceTouch:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = !sender.selected;
}

- (IBAction)saveAddress:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.nameField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"姓名不能为空" toView:self.view];
        return;
    }if (self.phoneField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"手机号码不能为空" toView:self.view];
        return;
    }if (_provinceStr.length == 0 || _cityStr.length == 0 || _districtStr.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"省市区不能为空" toView:self.view];
        return;
    }if (self.streetAdderssField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"街道地址不能为空" toView:self.view];
        return;
    }
    [self addAddressUrl];
}



#pragma mark - Picker View Data source
//列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
   return 3;
}
//行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
         return _provinceArr.count;
    }else if (component == 1) {
        return _cityArr.count;
    }else{
        return _districtArr.count;
    }
}

//返回row高度
-(CGFloat) pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40.f;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.font = [UIFont systemFontOfSize:15];
    }
    pickerLabel.textColor = [ResourceManager color_1];
    pickerLabel.textAlignment = NSTextAlignmentCenter;
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

#pragma mark- Picker View Delegate
//选中行触发事件
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        _cityStr = nil;
        _districtStr = nil;
        NSDictionary *dic = _provinceArr[row];
        _cityArr = [dic objectForKey:@"citys"];
        _districtArr = [(NSDictionary *)_cityArr[0] objectForKey:@"districts"];
        _provinceStr = [dic objectForKey:@"provinceName"];
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [_pickerView selectRow:0 inComponent:1 animated:YES];
        [_pickerView selectRow:0 inComponent:2 animated:YES];
    }else if (component == 1){
        _districtStr = nil;
        NSDictionary *dic = _cityArr[row];
        _districtArr = [dic objectForKey:@"districts"];
        _cityStr = [dic objectForKey:@"cityName"];
        [pickerView reloadComponent:2];
        [_pickerView selectRow:0 inComponent:2 animated:YES];
    }else{
        _districtStr = _districtArr[row];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        NSDictionary *dic = _provinceArr[row];
        _provinceStr = [dic objectForKey:@"provinceName"];
        return _provinceStr;
    }else if (component == 1){
        NSDictionary *dic = _cityArr[row];
        _cityStr = [dic objectForKey:@"cityName"];
        return _cityStr;
    }else{
        _districtStr = _districtArr[row];
        return _districtStr;
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
