//
//  PayResultVC.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/5.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PayResultVC : CommonViewController

@property (nonatomic, strong)  NSDictionary *dicPayResult;  // 后台返回的支付数据

@property (nonatomic, assign) BOOL  isSuceess;   // 是否支付成功

@end

NS_ASSUME_NONNULL_END
