//
//  SlideSub2.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/14.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "SlideSub2.h"

@interface SlideSub2 ()

@end

@implementation SlideSub2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark --- 布局UI
// view 已经布局其 Subviews
- (void)viewDidLayoutSubviews
{
    NSLog(@"SlideSub1  frame:%f", self.view.frame.size.height);
}



@end
