//
//  AllAppraiseListCell.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/25.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "AllAppraiseListCell.h"
#import "AllAppraiseView.h"

@implementation AllAppraiseListCell

-(void)setDataDicionary:(NSDictionary *)dataDicionary{
    _dataDicionary = dataDicionary;
    [self.contentView removeAllSubviews];
    [self layoutUI];
    
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

#pragma --mark 手动布局cell内部j控件
-(void)layoutUI{
    AllAppraiseView *view = [[AllAppraiseView alloc]initWithAppraiseListViewLayoutUI:_dataDicionary];
    view.clickEnlargeBlock = ^(int touchTag){
        if (self.clickEnlargeBlock) {
            self.clickEnlargeBlock(touchTag);
        }
    };
    [self.contentView addSubview:view];
   
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
