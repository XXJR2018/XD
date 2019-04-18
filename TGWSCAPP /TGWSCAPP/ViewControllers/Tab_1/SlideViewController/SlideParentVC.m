//
//  SlideParentVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/13.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "SlideParentVC.h"
#import "SlideSub1.h"
#import "SlideSub1.h"

@interface SlideParentVC ()

@end

@implementation SlideParentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
}

#pragma mark --- 布局UI
// view 已经布局其 Subviews
- (void)viewDidLayoutSubviews {
    NSLog(@"%s", __FUNCTION__);
    [super viewDidLayoutSubviews];
    
    // update by baicai
    NSLog(@"SlideParentVC  frame:%f", self.view.frame.size.height);
    self.view.backgroundColor = [UIColor colorWithRed:(arc4random()%255 / 255.0) green:(arc4random()%255 / 255.0) blue:(arc4random()%255 / 255.0) alpha:1];
    


//    UIViewController *vc = _controllers[i];
//
//    // update by baicai
//    vc.view.frame =  _bodyScrollView.bounds;
//    vc.view.center = CGPointMake(CGRectGetWidth(_bodyScrollView.frame)*(i+0.5), _bodyScrollView.frame.size.height/2);
//    [_bodyScrollView addSubview:vc.view];

    
    
    UILabel *viewTail = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 20, 100, 18)];
    [self.view addSubview:viewTail];
    viewTail.backgroundColor = [UIColor yellowColor];
    viewTail.textColor = [UIColor blueColor];
    viewTail.text = _slideModel.cateName;
    
    
    // 真正加载子页面
    if (_slideModel.iSlideID == -1 ||
        _slideModel.iSlideID %2 == 0)
     {
        // 加载推荐页面
        SlideSub1 *VC = [[SlideSub1 alloc] init];
        VC.view.frame = self.view.bounds;
        VC.slideModel = [[SlideModel alloc] init];
        VC.slideModel = _slideModel;
        [self.view addSubview:VC.view];
        
     }
//    else if (_slideModel.iSlideID %2 == 1)
//     {
//        SlideSub1 *VC = [[SlideSub1 alloc] init];
//        VC.view.frame = self.view.bounds;
//        [self.view addSubview:VC.view];
//        
//     }
    
    

}

@end
