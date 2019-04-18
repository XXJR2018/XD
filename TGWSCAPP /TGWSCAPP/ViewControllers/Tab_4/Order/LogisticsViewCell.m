//
//  LogisticsViewCell.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/1/8.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "LogisticsViewCell.h"

@interface LogisticsViewCell ()

@property(nonatomic, strong)UILabel *logisticsLabel;       //物流标签

@property(nonatomic, strong)UILabel *expressLabel;      //快递信息

@property(nonatomic, strong)UILabel *lastLogisticsInfoLabel;  //物流信息

@property(nonatomic, strong)UILabel *productNumLabel;  //商品数量

@property(nonatomic, strong)UIImageView *productImgView;  //商品图片



@end

@implementation LogisticsViewCell


-(void)setDataDicionary:(NSDictionary *)dataDicionary{
    _dataDicionary = dataDicionary;
//    [self.contentView removeAllSubviews];
    [self layoutUI];
    [self layoutSubviews];
}

-(void)layoutUI{
    UIColor *color_1 = [ResourceManager color_1];
    UIFont *font_1 = [UIFont systemFontOfSize:13];
    UIFont *font_2 = [UIFont systemFontOfSize:14];
    
    UIImageView *logisticsImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 28, 28)];
    [self.contentView addSubview:logisticsImgView];
    logisticsImgView.image = [UIImage imageNamed:@"Tab_4-30"];
    
    _logisticsLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logisticsImgView.frame) + 10, CGRectGetMinY(logisticsImgView.frame), 100, 20)];
    [self.contentView addSubview:_logisticsLabel];
    _logisticsLabel.font = font_2;
    _logisticsLabel.textColor = [ResourceManager mainColor];
    _logisticsLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"logisticsLabel"]];
    
    _expressLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 265, CGRectGetMinY(_logisticsLabel.frame), 250, 20)];
    [self.contentView addSubview:_expressLabel];
    _expressLabel.textAlignment = NSTextAlignmentRight;
    _expressLabel.font = [UIFont systemFontOfSize:12];
    _expressLabel.textColor = color_1;
    _expressLabel.text = [NSString stringWithFormat:@"%@包裹:%@",[_dataDicionary objectForKey:@"expressCompany"],[_dataDicionary objectForKey:@"expressNo"]];
    
    _lastLogisticsInfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_logisticsLabel.frame), CGRectGetMaxY(_logisticsLabel.frame) + 5, 310, 20)];
    [self.contentView addSubview:_lastLogisticsInfoLabel];
    _lastLogisticsInfoLabel.font = font_1;
    _lastLogisticsInfoLabel.textColor = color_1;
    _lastLogisticsInfoLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"lastLogisticsInfo"]];
    
    UIView *lineViewX = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_lastLogisticsInfoLabel.frame) + 15, SCREEN_WIDTH, 0.5)];
    [self.contentView addSubview:lineViewX];
    lineViewX.backgroundColor = [ResourceManager color_5];

    //3.分隔字符串
    NSString *imgUrls =[NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"imgUrls"]];
    NSArray *imgArr = [imgUrls componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
    
    NSInteger count = 0;
    if (imgArr.count%4 == 0) {
        count = imgArr.count/4;
    }else{
        count = imgArr.count/4 + 1;
    }
    for (int i = 0; i < count; i++) {
        for (int j = 0; j < 4; j++) {
            if (i * 4 + j < imgArr.count) {
                _productImgView = [[UIImageView alloc]initWithFrame:CGRectMake((80 + + (SCREEN_WIDTH - 320)/5) * j + (SCREEN_WIDTH - 320)/5, CGRectGetMaxY(lineViewX.frame) + 10 + 90 * i, 80, 80)];
                [self.contentView addSubview:_productImgView];
                _productImgView.backgroundColor = UIColorFromRGB(0xf6f6f6);
                [_productImgView sd_setImageWithURL:[NSURL URLWithString:imgArr[i * 4 + j]]];
            }
        }
    }

    _productNumLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 320)/5, CGRectGetMaxY(_productImgView.frame), 150, 35)];
    [self.contentView addSubview:_productNumLabel];
    _productNumLabel.font = [UIFont systemFontOfSize:12];
    _productNumLabel.textColor = [ResourceManager color_6];
    _productNumLabel.text = [NSString stringWithFormat:@"共%ld件商品",imgArr.count];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_productNumLabel.frame), SCREEN_WIDTH, 10)];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = [ResourceManager viewBackgroundColor];
    
}

-(void)layoutSubviews{
    
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
