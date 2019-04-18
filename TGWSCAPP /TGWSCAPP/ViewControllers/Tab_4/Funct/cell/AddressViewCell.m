//
//  AddressViewCell.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/27.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "AddressViewCell.h"

@implementation AddressViewCell

-(void)setDataDicionary:(NSDictionary *)dataDicionary{
    _dataDicionary = dataDicionary;
    
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.mrLabel.layer.borderWidth = 0.5;
    self.mrLabel.layer.borderColor = [ResourceManager mainColor].CGColor;
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"receiveName"]];
    self.phoneLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"hideReceiveTel"]];
    self.addressLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"fullAddrDesc"]];
//    [self.addressLabel sizeToFit];
    
    if ([[_dataDicionary objectForKey:@"isDefault"] intValue] == 1) {
        self.mrLabel.hidden = NO;
        self.layoutLeftLead.constant = 10;
    }else{
        self.mrLabel.hidden = YES;
        self.layoutLeftLead.constant = - 30;
    }
}

- (IBAction)edit:(id)sender {
    self.redactBlock();
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
