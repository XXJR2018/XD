//
//  SortProductCollectionViewCell.h
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/21.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SortProductCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) NSDictionary *dataDicionary;

@property (weak, nonatomic) IBOutlet UIImageView *productImgView;

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *productSubNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *selloutLabel;

@end

NS_ASSUME_NONNULL_END
