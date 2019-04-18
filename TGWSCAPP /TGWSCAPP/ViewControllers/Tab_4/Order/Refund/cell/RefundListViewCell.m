//
//  RefundListViewCell.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/11.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "RefundListViewCell.h"

const  int  iRefundListCellHeight = 235 + 10;

#define orderCellHeight  100

@interface RefundListViewCell()
{
    
}

@property(nonatomic, strong)UILabel *timeLabel;       //订单创建时间

@property(nonatomic, strong)UILabel *statusLabel;    //订单状态

@property(nonatomic, strong)UIImageView *productImgView;  //商品图片

@property(nonatomic, strong)UILabel *productNameLabel;  //商品名称

@property(nonatomic, strong)UILabel *productDescLabel;    //商品描述

@property(nonatomic, strong)UILabel *productPriceLabel;   //商品价格

@property(nonatomic, strong)UILabel *productNumLabel;   //商品数量

@property(nonatomic, strong)UILabel *orderDescLabel;      //订单描述

@property(nonatomic, strong)UILabel *orderFreightLabel;  //运费描述

@property(nonatomic, strong)UIButton *orderLeftBtn;      //订单左边按钮

@property(nonatomic, strong)UIButton *orderCentreBtn;    //订单中间按钮

@property(nonatomic, strong)UIButton *orderRightBtn;    //订单右边按钮

@property(nonatomic,strong)dispatch_source_t timer;       //创建GCD定时器

@end

@implementation RefundListViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setDataDicionary:(NSDictionary *)dataDicionary{
    _dataDicionary = dataDicionary;
    [self.contentView removeAllSubviews];
    
    [self layoutUI];
    [self layoutSubviews];
}



-(void)layoutUI{
    //self.backgroundColor = [UIColor yellowColor];
    
    UIColor *color_1 = [ResourceManager color_1];
    UIColor *color_2 = [ResourceManager color_6];
    UIFont *font_1 = [UIFont systemFontOfSize:13];
    UIFont *font_2 = [UIFont systemFontOfSize:12];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 45)];
    [self.contentView addSubview:_timeLabel];
    _timeLabel.font = font_1;
    _timeLabel.textColor = color_2;
    _timeLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"createTime"]];
    _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, 0, 150, 45)];
    [self.contentView addSubview:_statusLabel];
    _statusLabel.textAlignment = NSTextAlignmentRight;
    _statusLabel.font = font_1;
    _statusLabel.textColor = [ResourceManager mainColor];
    _statusLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"serverStatusDesc"]];
    
//    NSArray *orderDtlListArr = [_dataDicionary objectForKey:@"orderDtlList"];
//    if (orderDtlListArr.count == 0) {
//        return;
//    }
//    for (int i = 0; i < orderDtlListArr.count; i++)
//     {
        NSDictionary *dic = _dataDicionary;//orderDtlListArr[i];
        UIView *lineViewX = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_timeLabel.frame) + orderCellHeight * 0, SCREEN_WIDTH - 20, 0.5)];
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
        //_productPriceLabel.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"refundPrice"]];
        
        _productNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, CGRectGetMaxY(_productPriceLabel.frame) + 5, 150, 20)];
        [self.contentView addSubview:_productNumLabel];
        _productNumLabel.textAlignment = NSTextAlignmentRight;
        _productNumLabel.font = font_2;
        _productNumLabel.textColor = color_2;
        _productNumLabel.text = [NSString stringWithFormat:@"x%@",[dic objectForKey:@"refundNum"]];
    //}
    

    
    _orderDescLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 260, CGRectGetMaxY(_productImgView.frame) + 10, 250, 20)];
    [self.contentView addSubview:_orderDescLabel];
    _orderDescLabel.textAlignment = NSTextAlignmentRight;
    
    NSString *orderDescStr = [NSString stringWithFormat:@"共%@件商品，总金额￥%@",[_dataDicionary objectForKey:@"refundNum"],[_dataDicionary objectForKey:@"refundTotalAmt"]];
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
    if ([[_dataDicionary objectForKey:@"freightAmt"] intValue] >= 0) {
        _orderFreightLabel.frame = CGRectMake(SCREEN_WIDTH - 260, CGRectGetMaxY(_orderDescLabel.frame), 250, 20);
        _orderFreightLabel.text = [NSString stringWithFormat:@"(含运费￥%@)",[_dataDicionary objectForKey:@"freightAmt"]];
    }
    

    UIView *lineViewX3 = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_orderFreightLabel.frame) + 10, SCREEN_WIDTH - 20, 0.5)];
    [self.contentView addSubview:lineViewX3];
    lineViewX3.backgroundColor = [ResourceManager color_5];

    
    _orderRightBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH -80 -10, CGRectGetMaxY(lineViewX3.frame) + 10, 80, 30)];
    [self.contentView addSubview:_orderRightBtn];
    _orderRightBtn.tag = 102;
    _orderRightBtn.layer.cornerRadius = 3;
    _orderRightBtn.layer.borderWidth = 0.5;
    _orderRightBtn.layer.borderColor = [ResourceManager mainColor].CGColor;
    _orderRightBtn.titleLabel.font = font_1;
    [_orderRightBtn setTitle:@"退款详情" forState:UIControlStateNormal];
    [_orderRightBtn setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    //[_orderRightBtn addTarget:self action:@selector(orderTouch:) forControlEvents:UIControlEventTouchUpInside];
    _orderRightBtn.userInteractionEnabled = NO;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_orderRightBtn.frame) + 15, SCREEN_WIDTH, 5)];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = [ResourceManager viewBackgroundColor];
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    

    
//    self.titleLabrl.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"recordDesc"]];
//    self.timeLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"createTime"]];
//    self.orderNumber.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"orderNo"]];
//    if ([[_dataDicionary objectForKey:@"fundFlag"] intValue] == 1) {
//        self.changeNumLabel.text = [NSString stringWithFormat:@"+%@",[_dataDicionary objectForKey:@"amount"]];
//    }else{
//        self.changeNumLabel.text = [NSString stringWithFormat:@"-%@",[_dataDicionary objectForKey:@"amount"]];
//    }
    
}


@end
