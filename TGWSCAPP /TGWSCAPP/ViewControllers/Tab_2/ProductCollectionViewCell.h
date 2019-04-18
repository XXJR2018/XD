//
//  ProductCollectionViewCell.h
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/14.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProductCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) NSDictionary *dataDicionary;

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;


@end

NS_ASSUME_NONNULL_END
