//
//  SortProductCollectionViewCell.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/21.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "SortProductCollectionViewCell.h"

@implementation SortProductCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)setDataDicionary:(NSDictionary *)dataDicionary{
    _dataDicionary = dataDicionary;
    
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = UIColorFromRGB(0xf0f0f0).CGColor;
    self.selloutLabel.clipsToBounds = YES;
    self.selloutLabel.layer.cornerRadius = 25;
    self.selloutLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    [self.productImgView sd_setImageWithURL:[NSURL URLWithString:[_dataDicionary objectForKey:@"imgUrl"]]];
    self.productNameLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"goodsName"]];
    self.productSubNameLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"goodsSubName"]];
    
    if ([[_dataDicionary objectForKey:@"minPrice"] floatValue] > 0) {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[ToolsUtlis getnumber:[_dataDicionary objectForKey:@"minPrice"]]];
    }
    
    if ([[_dataDicionary objectForKey:@"marketPrice"] floatValue] > 0 && [[_dataDicionary objectForKey:@"minPrice"] floatValue] > 0) {
        if ([[_dataDicionary objectForKey:@"marketPrice"] floatValue] != [[_dataDicionary objectForKey:@"minPrice"] floatValue]) {
            NSString *minPrice = [NSString stringWithFormat:@"￥%@",[ToolsUtlis getnumber:[_dataDicionary objectForKey:@"minPrice"]]];
            NSString *marketPrice = [NSString stringWithFormat:@"￥%@",[ToolsUtlis getnumber:[_dataDicionary objectForKey:@"marketPrice"]]];
            NSString *titleStr = [NSString stringWithFormat:@"%@ %@",minPrice,marketPrice];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]
                                                  initWithString:titleStr];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, minPrice.length)];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(minPrice.length + 1, marketPrice.length)];
            [attrStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xB41D25) range:NSMakeRange(0, minPrice.length)];
            [attrStr addAttribute:NSForegroundColorAttributeName value:[ResourceManager color_6] range:NSMakeRange(minPrice.length + 1, marketPrice.length)];
            [attrStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(minPrice.length + 1, marketPrice.length)];
            
            self.priceLabel.attributedText = attrStr;
        }
    }
   
    if ([[_dataDicionary objectForKey:@"isSellOut"] intValue] == 0) {
        self.selloutLabel.hidden = NO;
    }else{
        self.selloutLabel.hidden = YES;
     }
    
}




@end
