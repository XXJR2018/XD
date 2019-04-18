//
//  CustomerServiceViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/28.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "CustomerServiceViewController.h"
#import "ChatViewController.h"

@interface CustomerServiceViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTop;

@end

@implementation CustomerServiceViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"客服中心"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"客服中心"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (iOS11Less) {
        self.layoutTop.constant = NavHeight + 20;
    }
    
    [self layoutNaviBarViewWithTitle:@"客服中心"];
}

- (IBAction)consult:(UIButton *)sender {
    if (sender.tag == 100) {
        NSString *tellStr=[[NSString alloc] initWithFormat:@"telprompt://%@",[[CommonInfo userInfo] objectForKey:@"kfTel"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tellStr] options:@{} completionHandler:nil];
    }else if (sender.tag == 101) {
        // 客服聊天
        ChatViewController  *VC = [[ChatViewController alloc] init];
        [self.navigationController  pushViewController:VC animated:YES];
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
