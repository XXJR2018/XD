//
//  OrderListViewCell.h
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/28.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderListViewCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDicionary;

@property(nonatomic, copy)Block_Id orderLeftBlock;

@property(nonatomic, copy)Block_Void orderRightBlock;

@property(nonatomic, copy)Block_Void orderCentreBlock;

@property(nonatomic, copy)Block_Void orderTimeBlock;

@end

NS_ASSUME_NONNULL_END
