//
//  paymentPWViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/25.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "paymentPWViewController.h"


#define kDotSize CGSizeMake (10, 10) //密码点的大小
#define kDotCount 6  //密码个数
#define K_Field_Height ([UIScreen mainScreen].bounds.size.width - 40)/6  //每一个输入框的高度等于当前view的高度
@interface paymentPWViewController ()<UITextFieldDelegate>
{
    NSString *_oldTradePwd;
    NSString *_tradePwd;
    NSString *_confirmTradePwd;
}
@property (nonatomic, strong) UILabel *payPWTitleLabel;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) NSMutableArray *dotArray; //用于存放黑色的点点


@end

@implementation paymentPWViewController


-(void)changePayPwdUrl{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tradePwd"] = _tradePwd;
    params[@"confirmTradePwd"] = _confirmTradePwd;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/cust/info/changePayPwd",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
    operation.tag = 1000;
}

-(void)verifyPayPwdUrl{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"tradePwd"] = _oldTradePwd;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/cust/info/verifyPayPwd",[PDAPI getBaseUrlString]]
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

#pragma mark 数据操作
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    if (operation.tag == 1000) {
        [MBProgressHUD showSuccessWithStatus:@"设置支付密码成功" toView:self.view];
        //发送通知更新用户信息
        [[NSNotificationCenter defaultCenter] postNotificationName:DDGNotificationAccountNeedRefresh object:nil];
        
        [self performBlock:^{
            
            if (self.popVC)
             {
                [self.navigationController popToViewController:self.popVC animated:YES];
                return;
             }
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        } afterDelay:1];
    }else{
        
        
        if (_isValidatePassWord)
         {
            //发送支付密码验证消息
            [[NSNotificationCenter defaultCenter] postNotificationName:DDGPayPassWordNotification object:@{@"password":_oldTradePwd}];
            [self.navigationController popViewControllerAnimated:YES];
            return;
         }
        
        _payPWTitleLabel.text = @"请设置新的支付密码，用于支付验证";
        _textField.text = @"";
        for (UIView *dotView in self.dotArray) {
            dotView.hidden = YES;
        }
    }
    
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
     if (operation.tag == 1001) {
         _oldTradePwd = @"";
         
         if (_isValidatePassWord)
          {
             _textField.text = @"";
          }
     }
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:self.titleStr];
    self.view.backgroundColor = [ResourceManager viewBackgroundColor];
    
    [self layoutUI];
}


-(void)layoutUI{
    _payPWTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, NavHeight + 80, SCREEN_WIDTH, 80)];
    [self.view addSubview:_payPWTitleLabel];
    _payPWTitleLabel.textColor = [ResourceManager color_1];
    _payPWTitleLabel.font = [UIFont systemFontOfSize:15];
    _payPWTitleLabel.textAlignment = NSTextAlignmentCenter;
    if ([self.titleStr isEqualToString:@"修改支付密码"]) {
        _payPWTitleLabel.text = @"请输入支付密码，以验证身份";
    }else{
         _payPWTitleLabel.text = @"请设置新的支付密码，用于支付验证";
    }
    
    if (_isValidatePassWord)
     {
        _payPWTitleLabel.text = @"请输入支付密码，以验证身份";
        [self layoutNaviBarViewWithTitle:@"验证支付密码"];
     }
    
    _textField = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_payPWTitleLabel.frame), SCREEN_WIDTH - 40, K_Field_Height)];
    [self.view addSubview:_textField];
    _textField.delegate = self;
    _textField.layer.borderWidth = 0.5;
    _textField.layer.borderColor = [ResourceManager color_5].CGColor;
    _textField.backgroundColor = [UIColor whiteColor];
    //输入的文字颜色为白色
    _textField.textColor = [UIColor clearColor];
    //输入框光标的颜色为白色
    _textField.tintColor = [UIColor clearColor];
    _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _textField.keyboardType = UIKeyboardTypeNumberPad;
    //第一响应者，弹出键盘
    [_textField becomeFirstResponder];
    [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    //生成分割线
    for (int i = 0; i < kDotCount - 1; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((i + 1) * K_Field_Height, 0, 1, K_Field_Height)];
        lineView.backgroundColor = [ResourceManager color_5];
        [_textField addSubview:lineView];
    }
    
    self.dotArray = [[NSMutableArray alloc] init];
    //生成中间的点
    for (int i = 0; i < kDotCount; i++) {
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake((K_Field_Height - kDotCount) / 2 + i * K_Field_Height, (K_Field_Height - kDotSize.height) / 2, kDotSize.width, kDotSize.height)];
        dotView.backgroundColor = [ResourceManager color_1];
        dotView.layer.cornerRadius = kDotSize.width / 2.0f;
        dotView.clipsToBounds = YES;
        dotView.hidden = YES; //先隐藏
        [_textField addSubview:dotView];
        //把创建的黑色点加入到数组中
        [self.dotArray addObject:dotView];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if([string isEqualToString:@"\n"]) {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
        //判断是不是删除键
        return YES;
    }
    else if(textField.text.length >= kDotCount) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        NSLog(@"输入的字符个数大于6，忽略输入");
        return NO;
    } else {
        return YES;
    }
}

/**
 *  重置变化显示的点
 */
- (void)textFieldDidChange:(UITextField *)textField{
    NSLog(@"%@", textField.text);
    for (UIView *dotView in self.dotArray) {
        dotView.hidden = YES;
    }
    for (int i = 0; i < textField.text.length; i++) {
        ((UIView *)[self.dotArray objectAtIndex:i]).hidden = NO;
    }
    if (textField.text.length == kDotCount) {
        NSLog(@"textField.text = %@",textField.text);
        
        if ([self.titleStr isEqualToString:@"验证支付密码"]) {
            if (_oldTradePwd.length == 0) {
                _oldTradePwd = textField.text;
                [self verifyPayPwdUrl];
                return;
            }
        }
        
        
        if ([self.titleStr isEqualToString:@"修改支付密码"]) {
            if (_oldTradePwd.length == 0) {
                _oldTradePwd = textField.text;
               [self verifyPayPwdUrl];
            }else if (_tradePwd.length == 0) {
                _tradePwd = textField.text;
                _payPWTitleLabel.text = @"请再次填写确认";
                textField.text = @"";
                for (UIView *dotView in self.dotArray) {
                    dotView.hidden = YES;
                }
            }else{
                _confirmTradePwd = textField.text;
                [self changePayPwdUrl];
            }
            
        }else{
            if (_tradePwd.length == 0) {
                _tradePwd = textField.text;
                _payPWTitleLabel.text = @"请再次填写确认";
                textField.text = @"";
                for (UIView *dotView in self.dotArray) {
                    dotView.hidden = YES;
                }
            }else{
                _confirmTradePwd = textField.text;
                [self changePayPwdUrl];
            }
        }
        
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
