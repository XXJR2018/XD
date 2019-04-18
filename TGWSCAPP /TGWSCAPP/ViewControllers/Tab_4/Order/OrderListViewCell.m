//
//  OrderListViewCell.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/28.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "OrderListViewCell.h"


#define orderCellHeight  100

@interface OrderListViewCell ()

@property(nonatomic, strong)UILabel *timeLabel;       //订单创建时间

@property(nonatomic, strong)UILabel *statusLabel;    //订单状态

@property(nonatomic, strong)UIImageView *productImgView;  //商品图片

@property(nonatomic, strong)UILabel *productNameLabel;  //商品名称

@property(nonatomic, strong)UILabel *productDescLabel;    //商品描述

@property(nonatomic, strong)UILabel *productPriceLabel;   //商品价格

@property(nonatomic, strong)UILabel *productNumLabel;   //商品数量

@property(nonatomic, strong)UILabel *orderDescLabel;      //订单描述

@property(nonatomic, strong)UIButton *orderLeftBtn;      //订单左边按钮

@property(nonatomic, strong)UIButton *orderCentreBtn;    //订单中间按钮

@property(nonatomic, strong)UIButton *orderRightBtn;    //订单右边按钮

@property(nonatomic,strong)dispatch_source_t timer;       //创建GCD定时器

@end

@implementation OrderListViewCell

-(void)setDataDicionary:(NSDictionary *)dataDicionary{
    _dataDicionary = dataDicionary;
    [self.contentView removeAllSubviews];

    [self layoutUI];
    [self layoutSubviews];
}

#pragma --mark 手动布局cell内部j控件
-(void)layoutUI{
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
    _statusLabel.text = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"statusDesc"]];
    
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

    NSString *orderDescStr = [NSString stringWithFormat:@"共%@件商品，实付金额￥%@",[_dataDicionary objectForKey:@"subOrderNum"],[_dataDicionary objectForKey:@"payAmt"]];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]
                                          initWithString:orderDescStr];
    //2.匹配字符串
    NSRange range = [orderDescStr rangeOfString:@"￥"];//匹配得到的下标
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, range.location)];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(range.location, orderDescStr.length - range.location)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:color_1 range:NSMakeRange(0, range.location)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xB00000) range:NSMakeRange(range.location, orderDescStr.length - range.location)];
    _orderDescLabel.attributedText = attrStr;
    
    _orderLeftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_orderDescLabel.frame) + 10, 80, 30)];
    [self.contentView addSubview:_orderLeftBtn];
    _orderLeftBtn.tag = 100;
    _orderLeftBtn.layer.cornerRadius = 3;
    _orderLeftBtn.layer.borderWidth = 0.5;
    _orderLeftBtn.layer.borderColor = [ResourceManager color_5].CGColor;
    _orderLeftBtn.titleLabel.font = font_1;
    [_orderLeftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
    [_orderLeftBtn setTitleColor:[ResourceManager color_6] forState:UIControlStateNormal];
    [_orderLeftBtn addTarget:self action:@selector(orderTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    _orderCentreBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 180, CGRectGetMinY(_orderLeftBtn.frame), 80, 30)];
    [self.contentView addSubview:_orderCentreBtn];
    _orderCentreBtn.tag = 101;
    _orderCentreBtn.layer.cornerRadius = 3;
    _orderCentreBtn.layer.borderWidth = 0.5;
    _orderCentreBtn.layer.borderColor = [ResourceManager color_5].CGColor;
    _orderCentreBtn.titleLabel.font = font_1;
    [_orderCentreBtn setTitle:@"申请售后" forState:UIControlStateNormal];
    [_orderCentreBtn setTitleColor:color_1 forState:UIControlStateNormal];
    [_orderCentreBtn addTarget:self action:@selector(orderTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    _orderRightBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_orderCentreBtn.frame) + 10, CGRectGetMinY(_orderLeftBtn.frame), 80, 30)];
    [self.contentView addSubview:_orderRightBtn];
     _orderRightBtn.tag = 102;
    _orderRightBtn.layer.cornerRadius = 3;
    _orderRightBtn.layer.borderWidth = 0.5;
    _orderRightBtn.layer.borderColor = [ResourceManager color_5].CGColor;
    _orderRightBtn.titleLabel.font = font_1;
    [_orderRightBtn setTitle:@"再次购买" forState:UIControlStateNormal];
    [_orderRightBtn setTitleColor:color_1 forState:UIControlStateNormal];
    [_orderRightBtn addTarget:self action:@selector(orderTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_orderLeftBtn.frame) + 15, SCREEN_WIDTH, 5)];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = [ResourceManager viewBackgroundColor];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    UIColor *color_1 = [ResourceManager color_1];
    UIColor *color_2 = [ResourceManager mainColor];
    UIColor *color_3 = [ResourceManager color_5];
    UIColor *color_4 = UIColorFromRGB(0xB00000);
//    状态（//0-待付款 1-交易成功 2-交易失败 3-卖家确认(待发货) 4-卖家审核失败 5-已发货  6-确认收货 7-交易关闭  8-退款成功  ）
    NSInteger status = [[_dataDicionary objectForKey:@"status"] intValue];
    
    if (status == 0 || status == 2) {
        _orderLeftBtn.hidden = YES;
        _orderCentreBtn.hidden = NO;
        _orderRightBtn.hidden = NO;
        _orderCentreBtn.layer.borderColor = color_3.CGColor;
        [_orderCentreBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [_orderCentreBtn setTitleColor:color_1 forState:UIControlStateNormal];
        _orderRightBtn.layer.borderColor = color_4.CGColor;
        _orderRightBtn.backgroundColor = color_4;
        [_orderRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_orderRightBtn setTitle:@"付款" forState:UIControlStateNormal];
        
        NSString *countDownTime = [NSString stringWithFormat:@"%@",[_dataDicionary objectForKey:@"countDownTime"]];
        if (countDownTime.length > 0) {
            NSArray *timeArr = [countDownTime componentsSeparatedByString:@":"];
            __block int timeout = 0; //倒计时时间
            timeout = [timeArr[0] intValue] * 60 +  [timeArr[1] intValue] ;

            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            if (!_timer) {
                _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
                dispatch_source_set_event_handler(_timer, ^{
                    if(timeout == 0){ //倒计时结束，关闭
                        dispatch_source_cancel(self.timer);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //倒计时结束，刷新数据，改变订单状态
                            [self.orderRightBtn setTitle:@"付款" forState:UIControlStateNormal];
                            self.orderTimeBlock();
                        });
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //设置界面的按钮显示 根据自己需求设置
                            [self.orderRightBtn  setTitle:[NSString stringWithFormat:@"付款 %@",[self getMMSSFromSS:timeout]] forState:UIControlStateNormal];
                        });
                        timeout--;
                    }
                });
                dispatch_resume(_timer);
            }
        }
       
    }else {
        if (_timer) {
            dispatch_source_cancel(self.timer);
        }
    }
    
    if (status == 1|| status == 3) {
    _orderLeftBtn.hidden = YES;
    _orderCentreBtn.hidden = YES;
    _orderRightBtn.hidden = NO;
    _orderRightBtn.layer.borderColor = color_3.CGColor;
    _orderRightBtn.backgroundColor = [UIColor whiteColor];
    [_orderRightBtn setTitle:@"申请售后" forState:UIControlStateNormal];
    [_orderRightBtn setTitleColor:color_1 forState:UIControlStateNormal];
    }
    
    if (status == 4|| status == 7) {
        _orderLeftBtn.hidden = NO;
        _orderCentreBtn.hidden = YES;
        _orderRightBtn.hidden = NO;
        _orderLeftBtn.width = 80;
        _orderRightBtn.layer.borderColor = color_3.CGColor;
        _orderRightBtn.backgroundColor = [UIColor whiteColor];
        [_orderRightBtn setTitle:@"再次购买" forState:UIControlStateNormal];
        [_orderRightBtn setTitleColor:color_1 forState:UIControlStateNormal];
    }
    
    if (status == 5) {
        _orderLeftBtn.hidden = YES;
        _orderCentreBtn.hidden = NO;
        _orderRightBtn.hidden = NO;
        _orderCentreBtn.layer.borderColor = color_3.CGColor;
        [_orderCentreBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        [_orderCentreBtn setTitleColor:color_1 forState:UIControlStateNormal];
        _orderRightBtn.layer.borderColor = color_3.CGColor;
        _orderRightBtn.backgroundColor = [UIColor whiteColor];
        [_orderRightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        [_orderRightBtn setTitleColor:color_1 forState:UIControlStateNormal];
    }
    
    if (status == 6) {
        _orderLeftBtn.hidden = NO;
        _orderCentreBtn.hidden = NO;
        _orderRightBtn.hidden = NO;
        _orderLeftBtn.width = 50;
        _orderLeftBtn.layer.borderColor = [UIColor clearColor].CGColor;
        _orderLeftBtn.backgroundColor = [UIColor whiteColor];
        [_orderLeftBtn setTitle:@"更多" forState:UIControlStateNormal];
        [_orderLeftBtn setTitleColor:color_1 forState:UIControlStateNormal];
        _orderCentreBtn.layer.borderColor = color_3.CGColor;
        [_orderCentreBtn setTitle:@"再次购买" forState:UIControlStateNormal];
        [_orderCentreBtn setTitleColor:color_1 forState:UIControlStateNormal];
        _orderRightBtn.layer.borderColor = color_3.CGColor;
        _orderRightBtn.backgroundColor = [UIColor whiteColor];
        [_orderRightBtn setTitle:@"评价" forState:UIControlStateNormal];
        [_orderRightBtn setTitleColor:color_1 forState:UIControlStateNormal];
    }
    
    if (status == 8) {
        _orderLeftBtn.hidden = YES;
        _orderCentreBtn.hidden = YES;
        _orderRightBtn.hidden = NO;
        _orderRightBtn.layer.borderColor = color_2.CGColor;
        _orderRightBtn.backgroundColor = [UIColor whiteColor];
        [_orderRightBtn setTitle:@"再次购买" forState:UIControlStateNormal];
        [_orderRightBtn setTitleColor:color_2 forState:UIControlStateNormal];
    }
}

-(void)orderTouch:(UIButton *)sender{
    if (sender.tag == 100) {
        self.orderLeftBlock(sender);
    }else if (sender.tag == 101) {
        self.orderCentreBlock();
    }else{
        self.orderRightBlock();
    }
}



//传入 秒  得到  xx分钟xx秒
-(NSString *)getMMSSFromSS:(NSInteger)totalTime{
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld",totalTime/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%ld",totalTime%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
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
