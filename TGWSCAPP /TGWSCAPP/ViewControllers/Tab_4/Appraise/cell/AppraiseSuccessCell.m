//
//  AppraiseSuccessCell.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/19.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "AppraiseSuccessCell.h"

@interface AppraiseSuccessCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;

@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *skuDescLabel;

@property (weak, nonatomic) IBOutlet UIButton *appraiseBtn;

@end

@implementation AppraiseSuccessCell

-(void)setDataDicionary:(NSDictionary *)dataDicionary{
    _dataDicionary = dataDicionary;
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.appraiseBtn.layer.cornerRadius = 30/2;
    self.appraiseBtn.layer.borderWidth = 0.5;
    self.appraiseBtn.layer.borderColor = UIColorFromRGB(0x704a18).CGColor;
    
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:[_dataDicionary objectForKey:@"goodsUrl"]]];
    self.goodsNameLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"goodsName"]];
    self.skuDescLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"skuDesc"]];
    
    if ([[_dataDicionary objectForKey:@"commentStatus"] intValue] == 1) {
        [self.appraiseBtn setTitle:@"评价" forState:UIControlStateNormal];
    }else if ([[_dataDicionary objectForKey:@"commentStatus"] intValue] == 2) {
        [self.appraiseBtn setTitle:@"追评" forState:UIControlStateNormal];
    }else if ([[_dataDicionary objectForKey:@"commentStatus"] intValue] == 3) {
        [self.appraiseBtn setTitle:@"查看评价" forState:UIControlStateNormal];
    }
    
}

- (IBAction)appraise:(UIButton *)sender {
    self.appraiseBlock();
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
