//
//  RefundCommitVC.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/9.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RefundCommitVC : CommonViewController

@property (nonatomic,strong) NSDictionary *dicParams;

@property (nonatomic,strong) NSString *subOrderNo;  // 退款的商品的 

@property (nonatomic,assign) int  iCommitType;  // 2 -- 退款退货  ， 1 - 退款

@end

NS_ASSUME_NONNULL_END
