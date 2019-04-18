//
//  AppraiseListCell.h
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/14.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppraiseListCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDicionary;

@property(nonatomic, assign) NSInteger appraiseType;

@property(nonatomic, copy)Block_Void checkOrderBlock;

@property(nonatomic, copy)Block_Void appraiseBlock;

@property(nonatomic, copy)Block_Void reviewAppraiseBlock;

@property(nonatomic, copy)Block_Int clickEnlargeBlock;

@end

NS_ASSUME_NONNULL_END
