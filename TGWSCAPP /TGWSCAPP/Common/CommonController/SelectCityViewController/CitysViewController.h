//
//  CitysViewController.h
//  XXJR
//
//  Created by xxjr02 on 16/1/12.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import "CommonViewController.h"

@interface CitysViewController : CommonViewController

@property (nonatomic,weak) UIViewController *rootVC;

/*
 * 是否需要选择区域
 */
@property (nonatomic,assign) BOOL area;

@property (nonatomic,strong) Block_Id block;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NavConstraint;

@end
