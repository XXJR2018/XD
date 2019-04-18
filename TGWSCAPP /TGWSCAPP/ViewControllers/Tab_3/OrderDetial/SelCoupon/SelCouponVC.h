//
//  SelCouponVC.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/5.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelCouponVC : CommonViewController

@property (nonatomic, strong) NSArray *arrCoupon;

@property (nonatomic, strong) NSString *custPromocardId;  // 优惠券的唯一ID

@property (nonatomic, strong) Block_Id  sel_bolck;

@end

NS_ASSUME_NONNULL_END
