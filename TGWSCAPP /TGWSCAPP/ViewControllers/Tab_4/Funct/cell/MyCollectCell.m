//
//  MyCollectCell.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/27.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "MyCollectCell.h"

@implementation MyCollectCell

-(void)setDataDicionary:(NSDictionary *)dataDicionary{
    _dataDicionary = dataDicionary;
    
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[_dataDicionary objectForKey:@"imgUrl"]]];
    self.titleLable.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"goodsName"]];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[_dataDicionary objectForKey:@"minPrice"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
