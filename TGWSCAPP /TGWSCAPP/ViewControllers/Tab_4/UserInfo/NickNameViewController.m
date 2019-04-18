//
//  NickNameViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/24.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "NickNameViewController.h"

@interface NickNameViewController ()


@property (weak, nonatomic) IBOutlet UITextField *nickNameField;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTop;

@end

@implementation NickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNaviBarViewWithTitle:@"设置昵称"];
    
    if (iOS11Less) {
        self.layoutTop.constant = NavHeight + 10;
    }
    
    self.nextBtn.layer.cornerRadius = 3;
    self.nextBtn.layer.borderWidth = 0.5;
    self.nextBtn.layer.borderColor = [ResourceManager mainColor].CGColor;
    
    [self.nickNameField addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    
}

- (IBAction)nextTouch:(id)sender {
    [self.view endEditing:YES];
    if (self.nickNameField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"昵称不能为空" toView:self.view];
        return;
    }
    [self changeCustInfoUrl];
}

-(void)changeCustInfoUrl{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"nickName"] = self.nickNameField.text;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/cust/info/changeCustInfo",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
}

#pragma mark 数据操作
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
     [MBProgressHUD showSuccessWithStatus:@"设置昵称成功" toView:self.view];
    //发送通知更新用户信息
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGNotificationAccountNeedRefresh object:nil];
    self.nickNameBlock(self.nickNameField.text);
    [self performBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    } afterDelay:1];
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}



#pragma mark- 监听输入框内容改变按钮颜色
-(void)textFieldTextChange:(UITextField *)textField{
    if (self.nickNameField.text.length > 10) {
        [MBProgressHUD showErrorWithStatus:@"昵称长度最多10个字符" toView:self.view];
        self.nickNameField.text = [self.nickNameField.text substringToIndex:10];
    }
}


@end
