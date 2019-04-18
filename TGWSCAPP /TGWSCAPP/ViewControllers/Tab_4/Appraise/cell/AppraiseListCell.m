//
//  AppraiseListCell.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/14.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "AppraiseListCell.h"
#import "MyAPPraiseView.h"

@interface AppraiseListCell ()

@property(nonatomic, strong)UILabel *timeLabel;       //订单创建时间

@property(nonatomic, strong)UIImageView *productImgView;  //商品图片

@property(nonatomic, strong)UILabel *productNameLabel;  //商品名称

@property(nonatomic, strong)UILabel *productDescLabel;    //商品描述

@property(nonatomic, strong)UILabel *productPriceLabel;   //商品价格

@property(nonatomic, strong)UILabel *productNumLabel;   //商品数量

@property(nonatomic, strong)UILabel *orderDescLabel;      //订单描述

@property(nonatomic, strong)UILabel *orderFreightLabel;  //运费描述

@property(nonatomic, strong)UIButton *checkOrderBtn;      //查看订单按钮

@property(nonatomic, strong)UIButton *appraiseBtn;    //评价按钮


@end


#define orderCellHeight  100

@implementation AppraiseListCell

-(void)setDataDicionary:(NSDictionary *)dataDicionary{
    _dataDicionary = dataDicionary;
    [self.contentView removeAllSubviews];
    if (self.appraiseType == 1) {
        [self layoutUI_1];
    }else{
        [self layoutUI_2];
    }
    
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

#pragma --mark 手动布局cell内部j控件
-(void)layoutUI_1{
    UIColor *color_1 = [ResourceManager color_1];
    UIColor *color_2 = [ResourceManager color_6];
    UIFont *font_1 = [UIFont systemFontOfSize:13];
    UIFont *font_2 = [UIFont systemFontOfSize:12];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 45)];
    [self.contentView addSubview:_timeLabel];
    _timeLabel.font = font_1;
    _timeLabel.textColor = color_2;
    _timeLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"finishTime"]];
    
    NSArray *orderDtlListArr = [_dataDicionary objectForKey:@"orderDtlList"];
    if (orderDtlListArr.count == 0) {
        return;
    }
    for (int i = 0; i < orderDtlListArr.count; i++) {
        NSDictionary *dic = orderDtlListArr[i];
        UIView *lineViewX = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_timeLabel.frame) + orderCellHeight * i, SCREEN_WIDTH - 20, 0.5)];
        [self.contentView addSubview:lineViewX];
        lineViewX.backgroundColor = [ResourceManager color_5];
        
        _productImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(lineViewX.frame) + 15, 70, 70)];
        [self.contentView addSubview:_productImgView];
        _productImgView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        [_productImgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"goodsUrl"]]];
        
        _productNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_productImgView.frame) + 10, CGRectGetMinY(_productImgView.frame) + 5, 200, 20)];
        [self.contentView addSubview:_productNameLabel];
        _productNameLabel.font = font_1;
        _productNameLabel.textColor = color_1;
        _productNameLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"goodsName"]];
        
        _productDescLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_productImgView.frame) + 10, CGRectGetMaxY(_productNameLabel.frame) + 5, 200, 20)];
        [self.contentView addSubview:_productDescLabel];
        _productDescLabel.font = font_2;
        _productDescLabel.textColor = color_2;
        _productDescLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"skuDesc"]];
        
        _productPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, CGRectGetMinY(_productImgView.frame) + 5, 150, 20)];
        [self.contentView addSubview:_productPriceLabel];
        _productPriceLabel.textAlignment = NSTextAlignmentRight;
        _productPriceLabel.font = font_1;
        _productPriceLabel.textColor = color_2;
        _productPriceLabel.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"price"]];
        
        _productNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, CGRectGetMaxY(_productPriceLabel.frame) + 5, 150, 20)];
        [self.contentView addSubview:_productNumLabel];
        _productNumLabel.textAlignment = NSTextAlignmentRight;
        _productNumLabel.font = font_2;
        _productNumLabel.textColor = color_2;
        _productNumLabel.text = [NSString stringWithFormat:@"x%@",[dic objectForKey:@"num"]];
    }
    
    UIView *lineViewX = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_productImgView.frame) + 15, SCREEN_WIDTH - 20, 0.5)];
    [self.contentView addSubview:lineViewX];
    lineViewX.backgroundColor = [ResourceManager color_5];
    
    _orderDescLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 260, CGRectGetMaxY(lineViewX.frame) + 10, 250, 20)];
    [self.contentView addSubview:_orderDescLabel];
    _orderDescLabel.textAlignment = NSTextAlignmentRight;
    
    NSString *orderDescStr = [NSString stringWithFormat:@"共%@件商品，总金额￥%@",[_dataDicionary objectForKey:@"subOrderNum"],[_dataDicionary objectForKey:@"totalOrderAmt"]];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]
                                          initWithString:orderDescStr];
    //2.匹配字符串
    NSRange range = [orderDescStr rangeOfString:@"￥"];//匹配得到的下标
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, range.location)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(range.location, orderDescStr.length - range.location)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:color_1 range:NSMakeRange(0, range.location)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xB00000) range:NSMakeRange(range.location, orderDescStr.length - range.location)];
    _orderDescLabel.attributedText = attrStr;
    
    _orderFreightLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 260, CGRectGetMaxY(_orderDescLabel.frame), 200, 0)];
    [self.contentView addSubview:_orderFreightLabel];
    _orderFreightLabel.textAlignment = NSTextAlignmentRight;
    _orderFreightLabel.font = font_2;
    _orderFreightLabel.textColor = color_1;
    if ([[_dataDicionary objectForKey:@"freightAmt"] intValue] > 0) {
        _orderFreightLabel.frame = CGRectMake(SCREEN_WIDTH - 260, CGRectGetMaxY(_orderDescLabel.frame), 250, 20);
        _orderFreightLabel.text = [NSString stringWithFormat:@"(含运费￥%@)",[_dataDicionary objectForKey:@"freightAmt"]];
    }
    
    _checkOrderBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 180, CGRectGetMaxY(_orderFreightLabel.frame) + 10, 80, 30)];
    [self.contentView addSubview:_checkOrderBtn];
    _checkOrderBtn.layer.cornerRadius = 3;
    _checkOrderBtn.layer.borderWidth = 0.5;
    _checkOrderBtn.layer.borderColor = [ResourceManager color_5].CGColor;
    _checkOrderBtn.titleLabel.font = font_1;
    [_checkOrderBtn setTitle:@"查看订单" forState:UIControlStateNormal];
    [_checkOrderBtn setTitleColor:color_1 forState:UIControlStateNormal];
    [_checkOrderBtn addTarget:self action:@selector(checkOrder) forControlEvents:UIControlEventTouchUpInside];
   
    _appraiseBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_checkOrderBtn.frame) + 10, CGRectGetMinY(_checkOrderBtn.frame), 80, 30)];
    [self.contentView addSubview:_appraiseBtn];
    _appraiseBtn.layer.cornerRadius = 3;
    _appraiseBtn.layer.borderWidth = 0.5;
    _appraiseBtn.layer.borderColor = [ResourceManager color_5].CGColor;
    _appraiseBtn.titleLabel.font = font_1;
    [_appraiseBtn setTitle:@"评价" forState:UIControlStateNormal];
    [_appraiseBtn setTitleColor:color_1 forState:UIControlStateNormal];
    [_appraiseBtn addTarget:self action:@selector(appraise) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_appraiseBtn.frame) + 15, SCREEN_WIDTH, 5)];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = [ResourceManager viewBackgroundColor];
    
}

-(void)layoutUI_2{
    
    MyAPPraiseView *view = [[MyAPPraiseView alloc]initWithAppraiseListViewLayoutUI:_dataDicionary];
    view.myAppraiseBlock = ^{
        if (self.reviewAppraiseBlock) {
            self.reviewAppraiseBlock();
        }
    };
    view.clickEnlargeBlock = ^(int touchTag){
        if (self.clickEnlargeBlock) {
            self.clickEnlargeBlock(touchTag);
        }
    };
    [self.contentView addSubview:view];

}

-(void)checkOrder{
    if (self.checkOrderBlock) {
        self.checkOrderBlock();
    }
}

-(void)appraise{
    if (self.appraiseBlock) {
        self.appraiseBlock();
    }
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
