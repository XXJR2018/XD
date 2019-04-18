//
//  ShopCouponViewCell.h
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/3/20.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShopCouponViewCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDicionary;

@property(nonatomic, copy)Block_Void shareBlock;

@end

NS_ASSUME_NONNULL_END
