//
//  PhoneCheckViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/25.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "PhoneCheckViewController.h"

#import "paymentPWViewController.h"
#import "IdentifyAlertView.h"

@interface PhoneCheckViewController ()
{
    NSString *smsTokenId;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *VerifyTextField;//验证码
@property (weak, nonatomic) IBOutlet UIButton *VerifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation PhoneCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:self.titleStr];

    self.nextBtn.layer.borderWidth = 0.5;
    self.nextBtn.layer.borderColor = [ResourceManager mainColor].CGColor;
    
    self.titleLabel.text = [NSString stringWithFormat:@"请输入手机号为%@的验证码",[[CommonInfo userInfo] objectForKey:@"hideTelephone"]];
    
}

- (IBAction)nextTouch:(id)sender {
    [self.view endEditing:YES];
    if (self.VerifyTextField.text.length == 0) {
        [MBProgressHUD showErrorWithStatus:@"验证码不能为空" toView:self.view];
        return;
    }
    [self forgetTradeUrl];
}



#pragma mark 数据操作
-(void)forgetTradeUrl{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"randomNo"] = self.VerifyTextField.text;
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/smsSend/valid/login/forgetTrade",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    
    operation.tag = 1000;
    [operation start];
}

-(void)getSMSFrist
{
    smsTokenId = @"";
    [MBProgressHUD showHUDAddedTo:self.view];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@/forgetTrade", [PDAPI getBaseUrlString], kDDGgetSmsTokenByType];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"telephone"] = [[CommonInfo userInfo] objectForKey:@"telephone"];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 998;
    [operation start];
}


-(void)getSMSSecond
{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSString *strUrl = [NSString stringWithFormat:@"%@%@/forgetTrade", [PDAPI getBaseUrlString], kDDGnologinByType];
    NSMutableDictionary *parmas = [[NSMutableDictionary alloc] init];
    parmas[@"telephone"] = [[CommonInfo userInfo] objectForKey:@"telephone"];
    parmas[@"smsTokenId"] = smsTokenId;
    NSString *strTemp = [NSString stringWithFormat:@"%@&%@",smsTokenId,[[CommonInfo userInfo] objectForKey:@"telephone"]];
    parmas[@"smsEnc"] = [strTemp stringTGWToMD5];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:parmas HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    operation.tag = 999;
    [operation start];
}



-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    if (operation.tag == 998)
     {
        NSDictionary *dic = operation.jsonResult.attr;
        if (dic)
         {
            smsTokenId =  [NSString stringWithFormat:@"%@", dic[@"smsTokenId"]];
            [self getSMSSecond];
         }
        
     }
    else if (operation.tag == 999)
     {
        [MBProgressHUD showSuccessWithStatus:@"获取验证码成功" toView:self.view];
     }
    else if (1000 == operation.tag)
     {
        paymentPWViewController *ctl = [[paymentPWViewController alloc]init];
        if ([self.titleStr isEqualToString:@"设置支付密码"]) {
            ctl.titleStr = @"设置支付密码";
        }else{
            ctl.titleStr = @"重置支付密码";
        }
        if (_popVC)
         {
            ctl.popVC = _popVC;
         }
        [self.navigationController pushViewController:ctl animated:YES];
     }
   
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}


//获取验证码
- (IBAction)VerifyBtn:(UIButton *)sender {
    if (![ToolsUtlis isNetworkReachable]) {
        [MBProgressHUD showErrorWithStatus:@"请检查网络" toView:self.view];
        return;
    }
   
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.VerifyBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.VerifyBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.VerifyBtn setTitle:[NSString stringWithFormat:@"重发(%@秒)",strTime] forState:UIControlStateNormal];
                self.VerifyBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
    [self getSMSFrist];
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
