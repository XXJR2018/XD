//
//  AddressViewCell.h
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/27.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressViewCell : UITableViewCell

@property (nonatomic,strong) NSDictionary *dataDicionary;

@property(nonatomic, copy) Block_Void redactBlock;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *mrLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutLeftLead;

@end

NS_ASSUME_NONNULL_END
