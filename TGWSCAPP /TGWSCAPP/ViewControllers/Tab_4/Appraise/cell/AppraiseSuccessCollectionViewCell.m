//
//  AppraiseSuccessCollectionViewCell.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/20.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "AppraiseSuccessCollectionViewCell.h"

@interface AppraiseSuccessCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *productImgView;

@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *productImgViewLayoutHeight;

@end

@implementation AppraiseSuccessCollectionViewCell

-(void)setDataDicionary:(NSDictionary *)dataDicionary{
    _dataDicionary = dataDicionary;
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.productImgViewLayoutHeight.constant = (SCREEN_WIDTH/3  - 10) * ScaleSize;
    [self.productImgView sd_setImageWithURL:[NSURL URLWithString:[_dataDicionary objectForKey:@"imgUrl"]]];
    self.goodsNameLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"goodsName"]];
    self.priceLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"minPrice"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
