//
//  RefundRequstSecond.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/9.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RefundRequstSecond : CommonViewController

@property (nonatomic,strong) NSDictionary *dicParams;

@property (nonatomic,assign) int  iCommitType;  //  1 - 退款 ，2 -- 退款退货  

@end

NS_ASSUME_NONNULL_END
