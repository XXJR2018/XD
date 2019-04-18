//
//  CouponViewCell.h
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/26.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CouponViewCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDicionary;

@property(nonatomic, copy)Block_Void employBlock;

@end

NS_ASSUME_NONNULL_END
