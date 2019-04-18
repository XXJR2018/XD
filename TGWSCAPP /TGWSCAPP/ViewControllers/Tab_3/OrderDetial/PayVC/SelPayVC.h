//
//  SelPayVC.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/5.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelPayVC : CommonViewController

@property (nonatomic, strong)  NSDictionary *dicPay;  // 后台返回的支付数据

@property (nonatomic, assign)  BOOL  isWithBalance;// 是否带余额支付 （部分余额支付）

@end

NS_ASSUME_NONNULL_END
