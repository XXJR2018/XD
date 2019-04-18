//
//  ShopCouponViewCell.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/3/20.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "ShopCouponViewCell.h"

@interface ShopCouponViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *zsTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *promocardValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *stataLabel;

@property (weak, nonatomic) IBOutlet UILabel *qplgwjLabel;

@property (weak, nonatomic) IBOutlet UILabel *astrictLabel;

@property (weak, nonatomic) IBOutlet UILabel *atLeastLabel;

@property (weak, nonatomic) IBOutlet UILabel *validTlmeLabel;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@property (weak, nonatomic) IBOutlet UIImageView *statusImgView;

@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusImgViewLayoutWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusImgViewLayoutHeight;

@end

@implementation ShopCouponViewCell


-(void)setDataDicionary:(NSDictionary *)dataDicionary{
    _dataDicionary = dataDicionary;
    
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.shareBtn.layer.cornerRadius = 25/2;
    self.shareBtn.layer.borderWidth = 0.5;
    self.shareBtn.layer.borderColor = [ResourceManager mainColor].CGColor;
    self.statusImgViewLayoutWidth.constant = 53.5;
    self.statusImgViewLayoutHeight.constant = 41;
    self.userNameLabel.text = [NSString stringWithFormat:@"赠送人：%@",[_dataDicionary objectForKey:@"giveBy"]];
    self.zsTimeLabel.text = [NSString stringWithFormat:@"赠送日期：%@",[_dataDicionary objectForKey:@"receiveTime"]];
    
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

    //status 0未启用 1有效 2已使用 3已过期 4使用中 5分享中 6分享成功
    if ([[_dataDicionary objectForKey:@"status"] intValue] == 0) {
        self.bgImgView.image = [UIImage imageNamed:@"Tab_4-45"];
        self.stataLabel.textColor = [ResourceManager color_6];
        self.promocardValueLabel.textColor = [ResourceManager color_6];
        self.qplgwjLabel.textColor = [ResourceManager color_6];
        self.statusImgView.hidden = NO;
        self.statusImgView.image = [UIImage imageNamed:@"Tab_4-47"];
        self.statusImgViewLayoutWidth.constant = self.statusImgViewLayoutHeight.constant = 45;
        self.shareBtn.hidden = YES;
    }else if ([[_dataDicionary objectForKey:@"status"] intValue] == 1) {
        self.bgImgView.image = [UIImage imageNamed:@"Tab_4-46"];
        self.stataLabel.textColor = UIColorFromRGB(0xB00000);
        self.promocardValueLabel.textColor = [ResourceManager mainColor];
        self.qplgwjLabel.textColor = [ResourceManager color_1];
        self.statusImgView.hidden = YES;
        self.shareBtn.hidden = NO;
    }else if ([[_dataDicionary objectForKey:@"status"] intValue] == 2 || [[_dataDicionary objectForKey:@"status"] intValue] == 4) {
        self.bgImgView.image = [UIImage imageNamed:@"Tab_4-45"];
        self.stataLabel.textColor = [ResourceManager color_6];
        self.promocardValueLabel.textColor = [ResourceManager color_6];
        self.qplgwjLabel.textColor = [ResourceManager color_6];
        self.statusImgView.hidden = NO;
        self.statusImgView.image = [UIImage imageNamed:@"Tab_4-21"];
        self.shareBtn.hidden = YES;
    }else if ([[_dataDicionary objectForKey:@"status"] intValue] == 3) {
        self.bgImgView.image = [UIImage imageNamed:@"Tab_4-45"];
        self.stataLabel.textColor = [ResourceManager color_6];
        self.promocardValueLabel.textColor = [ResourceManager color_6];
        self.qplgwjLabel.textColor = [ResourceManager color_6];
        self.statusImgView.hidden = NO;
        self.statusImgView.image = [UIImage imageNamed:@"Tab_4-22"];
        self.shareBtn.hidden = YES;
    }else if ([[_dataDicionary objectForKey:@"status"] intValue] == 5) {
        self.bgImgView.image = [UIImage imageNamed:@"Tab_4-45"];
        self.stataLabel.textColor = [ResourceManager color_6];
        self.promocardValueLabel.textColor = [ResourceManager color_6];
        self.qplgwjLabel.textColor = [ResourceManager color_6];
        self.statusImgView.hidden = NO;
        self.statusImgView.image = [UIImage imageNamed:@"Tab_4-48"];
        self.shareBtn.hidden = YES;
        self.statusImgViewLayoutWidth.constant = 54;
        self.statusImgViewLayoutHeight.constant = 45.5;
    }else if ([[_dataDicionary objectForKey:@"status"] intValue] == 6) {
        self.bgImgView.image = [UIImage imageNamed:@"Tab_4-45"];
        self.stataLabel.textColor = [ResourceManager color_6];
        self.promocardValueLabel.textColor = [ResourceManager color_6];
        self.qplgwjLabel.textColor = [ResourceManager color_6];
        self.statusImgView.hidden = NO;
        self.statusImgView.image = [UIImage imageNamed:@"Tab_4-49"];
        self.shareBtn.hidden = YES;
        self.statusImgViewLayoutWidth.constant = 54;
        self.statusImgViewLayoutHeight.constant = 45.5;
    }
    
}

- (IBAction)share:(id)sender {
    self.shareBlock();
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
