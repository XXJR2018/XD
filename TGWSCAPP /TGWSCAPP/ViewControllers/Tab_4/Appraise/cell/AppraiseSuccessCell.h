//
//  AppraiseSuccessCell.h
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/19.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppraiseSuccessCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDicionary;

@property(nonatomic, copy) Block_Void appraiseBlock;


@end

NS_ASSUME_NONNULL_END
