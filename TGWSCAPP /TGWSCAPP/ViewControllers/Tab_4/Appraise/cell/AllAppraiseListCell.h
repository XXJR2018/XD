//
//  AllAppraiseListCell.h
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/25.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AllAppraiseListCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDicionary;

@property(nonatomic, copy)Block_Int clickEnlargeBlock;
@end

NS_ASSUME_NONNULL_END
