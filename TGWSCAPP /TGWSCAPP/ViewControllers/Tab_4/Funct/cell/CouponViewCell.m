//
//  CouponViewCell.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/26.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "CouponViewCell.h"


@interface CouponViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *promocardValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *stataLabel;

@property (weak, nonatomic) IBOutlet UILabel *qctyLabel;

@property (weak, nonatomic) IBOutlet UILabel *atLeastLabel;

@property (weak, nonatomic) IBOutlet UILabel *astrictLabel;

@property (weak, nonatomic) IBOutlet UILabel *validTlmeLabel;

@property (weak, nonatomic) IBOutlet UIButton *employBtn;

@property (weak, nonatomic) IBOutlet UIImageView *statusImgView;

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;

@end



@implementation CouponViewCell


-(void)setDataDicionary:(NSDictionary *)dataDicionary{
    _dataDicionary = dataDicionary;
    
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.employBtn.layer.cornerRadius = 25/2;
    self.employBtn.layer.borderWidth = 0.5;
    self.employBtn.layer.borderColor = [ResourceManager color_5].CGColor;
    
    NSString *titleStr = [NSString stringWithFormat:@"%@元",[_dataDicionary objectForKey:@"promocardValue"]];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]
                                          initWithString:titleStr];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:40] range:NSMakeRange(0, titleStr.length - 1)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(titleStr.length - 1, 1)];
    self.promocardValueLabel.attributedText = attrStr;
    self.stataLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"desc"]];
    if ([self.stataLabel.text isEqualToString:@"未开始"]) {
        self.stataLabel.textColor = [ResourceManager color_6];
    }
    self.astrictLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"useDesc"]];
    self.atLeastLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"useRemark"]];
    self.validTlmeLabel.text = [NSString stringWithFormat:@"有效期%@-%@",[_dataDicionary objectForKey:@"validStartDate"],[_dataDicionary objectForKey:@"validEndDate"]];
  
    if ([[_dataDicionary objectForKey:@"usableFlag"] intValue] == 1) {
        self.employBtn.hidden = NO;
    }else{
        self.employBtn.hidden = YES;
    }
    if ([[_dataDicionary objectForKey:@"status"] intValue] == 2) {
        self.bgImgView.image = [UIImage imageNamed:@"Tab_4-20"];
        self.stataLabel.textColor = [ResourceManager color_6];
        self.promocardValueLabel.textColor = [ResourceManager color_6];
        self.qctyLabel.textColor = [ResourceManager color_6];
        self.statusImgView.hidden = NO;
        self.statusImgView.image = [UIImage imageNamed:@"Tab_4-21"];
    }else if ([[_dataDicionary objectForKey:@"status"] intValue] == 3) {
        self.bgImgView.image = [UIImage imageNamed:@"Tab_4-20"];
        self.stataLabel.textColor = [ResourceManager color_6];
        self.promocardValueLabel.textColor = [ResourceManager color_6];
        self.qctyLabel.textColor = [ResourceManager color_6];
        self.statusImgView.hidden = NO;
        self.statusImgView.image = [UIImage imageNamed:@"Tab_4-22"];
    }else{
        self.bgImgView.image = [UIImage imageNamed:@"Tab_4-19"];
        self.stataLabel.textColor = UIColorFromRGB(0xB00000);
        self.promocardValueLabel.textColor = [ResourceManager mainColor];
        self.qctyLabel.textColor = [ResourceManager color_1];
        self.statusImgView.hidden = YES;
    }
    
    
}

- (IBAction)employ:(id)sender {
    self.employBlock();
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
