//
//  PhoneCheckViewController.h
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/25.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhoneCheckViewController : CommonViewController

@property(nonatomic, copy)NSString *titleStr;

@property(nonatomic, strong) UIViewController *popVC;  // 返回viewController

@end

NS_ASSUME_NONNULL_END
