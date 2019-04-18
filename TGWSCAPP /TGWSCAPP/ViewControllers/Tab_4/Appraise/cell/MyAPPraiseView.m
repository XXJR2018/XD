//
//  MyAPPraiseView.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/19.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "MyAPPraiseView.h"

@interface MyAPPraiseView ()

@property(nonatomic, assign)CGFloat currentHeight;

@end

@implementation MyAPPraiseView

-(UIView *)initWithAppraiseListViewLayoutUI:(NSDictionary *)dic{
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CellHeight44)];

    if (self) {
        _currentHeight = 0;
        self.backgroundColor = [UIColor whiteColor];
        
        [self layoutCellUI:dic];
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, _currentHeight);
    }
    
    return self;
}

-(void)layoutCellUI:(NSDictionary *)dic{
    UIColor *color_1 = [ResourceManager color_1];
    UIColor *color_2 = [ResourceManager color_6];
    UIFont *font_1 = [UIFont systemFontOfSize:14];
    UIFont *font_2 = [UIFont systemFontOfSize:12];
    
    UIImageView *headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    [self addSubview:headImgView];
    headImgView.layer.masksToBounds = YES;
    headImgView.layer.cornerRadius = 30/2;
    [headImgView sd_setImageWithURL:[dic objectForKey:@"headImgUrl"]];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImgView.frame) + 10, CGRectGetMidY(headImgView.frame) - 10, 250, 20)];
    [self addSubview:nameLabel];
    nameLabel.font = font_2;
    nameLabel.textColor = color_1;
    nameLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"nickName"]];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(headImgView.frame), CGRectGetMaxY(headImgView.frame), SCREEN_WIDTH - 20, 20)];
    [self addSubview:timeLabel];
    timeLabel.font = font_2;
    timeLabel.textColor = color_2;
    timeLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"createTime"]];
    
    _currentHeight = CGRectGetMaxY(timeLabel.frame);
    //评价内容
    if ([dic objectForKey:@"commentText"] && [NSString stringWithFormat:@"%@",[dic objectForKey:@"commentText"]].length > 0) {
        UILabel *appraiseTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(headImgView.frame), _currentHeight + 10, SCREEN_WIDTH - 20, 20)];
        [self addSubview:appraiseTextLabel];
        appraiseTextLabel.numberOfLines = 0;
        appraiseTextLabel.font = font_1;
        appraiseTextLabel.textColor = color_1;
        appraiseTextLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"commentText"]];
        CGSize maximumLabelSize = CGSizeMake(SCREEN_WIDTH - 20, 200);//labelsize的最大值
        //关键语句
        CGSize expectSize = [appraiseTextLabel sizeThatFits:maximumLabelSize];
        //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
        appraiseTextLabel.frame = CGRectMake(CGRectGetMinX(headImgView.frame), _currentHeight + 10, expectSize.width, expectSize.height);
        
         _currentHeight = CGRectGetMaxY(appraiseTextLabel.frame);
    }
    
    //评价图片
    if ([dic objectForKey:@"imgUrl"] && [NSString stringWithFormat:@"%@",[dic objectForKey:@"imgUrl"]].length > 0) {
        //3.分隔字符串
        NSString *imgUrls =[NSString stringWithFormat:@"%@",[dic objectForKey:@"imgUrl"]];
        NSArray *imgArr = [imgUrls componentsSeparatedByString:@","]; //从字符A中分隔成多个元素的数组
        CGFloat imgWidth = (SCREEN_WIDTH - 40)/3;
        CGFloat imgTop = _currentHeight + 15;
        for (int i = 0; i < 2; i++) {
            for (int j = 0; j < 3; j++) {
                if (i * 3 + j < imgArr.count) {
                    UIImageView *appraiseImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + (imgWidth + 10) * j, imgTop + (imgWidth + 10) * i, imgWidth, imgWidth)];
                    [self addSubview:appraiseImgView];
                    [appraiseImgView sd_setImageWithURL:[NSURL URLWithString:imgArr[i * 3 + j]]];
                    appraiseImgView.userInteractionEnabled = YES;
                    
                    //添加手势点击空白处隐藏键盘
                    UITapGestureRecognizer * tapGeture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickEnlarge:)];
                    tapGeture.numberOfTapsRequired  = 1;
                    [appraiseImgView addGestureRecognizer:tapGeture];
                    [tapGeture view].tag = i * 3 + j;
                    
                    _currentHeight = CGRectGetMaxY(appraiseImgView.frame);
                }
            }
        }
    }
    
    //商家回复评价内容
    if ([dic objectForKey:@"replyText"] && [NSString stringWithFormat:@"%@",[dic objectForKey:@"replyText"]].length > 0) {
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(headImgView.frame), _currentHeight + 10, SCREEN_WIDTH - 20, 20)];
        [self addSubview:titleLabel];
        titleLabel.font = font_2;
        titleLabel.textColor = [ResourceManager mainColor];
        titleLabel.text = @"商家回复:";
        
        UILabel *replyAppraiseLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(headImgView.frame), CGRectGetMaxY(titleLabel.frame) + 10, SCREEN_WIDTH - 20, 20)];
        [self addSubview:replyAppraiseLabel];
        replyAppraiseLabel.numberOfLines = 0;
        replyAppraiseLabel.font = font_1;
        replyAppraiseLabel.textColor = [ResourceManager mainColor];
        replyAppraiseLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"replyText"]];
        CGSize maximumLabelSize = CGSizeMake(SCREEN_WIDTH - 20, 200);//labelsize的最大值
        //关键语句
        CGSize expectSize = [replyAppraiseLabel sizeThatFits:maximumLabelSize];
        //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
        replyAppraiseLabel.frame = CGRectMake(CGRectGetMinX(headImgView.frame), CGRectGetMaxY(titleLabel.frame) + 10, expectSize.width, expectSize.height);
        
        _currentHeight = CGRectGetMaxY(replyAppraiseLabel.frame) + 10;
    }
    
    //已追评
    if ([[dic objectForKey:@"commentStatus"] intValue] == 3) {
        //追评时间
        if ([dic objectForKey:@"appendDate"] && [NSString stringWithFormat:@"%@",[dic objectForKey:@"appendDate"]].length > 0) {
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _currentHeight + 10, SCREEN_WIDTH - 20, 0.5)];
            [self addSubview:lineView];
            lineView.backgroundColor = [ResourceManager color_5];
            
            UILabel *reviewtimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(headImgView.frame), _currentHeight + 20, SCREEN_WIDTH - 20, 20)];
            [self addSubview:reviewtimeLabel];
            reviewtimeLabel.font = font_1;
            reviewtimeLabel.textColor = UIColorFromRGB(0xF66455);
            reviewtimeLabel.text = [NSString stringWithFormat:@"用户%@天后追评",[dic objectForKey:@"appendDate"]];
            if ([[dic objectForKey:@"appendDate"] intValue] == 0) {
                reviewtimeLabel.text = @"用户当天追评";
            }
            _currentHeight = CGRectGetMaxY(reviewtimeLabel.frame);
        }
        
        //追评内容
        if ([dic objectForKey:@"appendText"] && [NSString stringWithFormat:@"%@",[dic objectForKey:@"appendText"]].length > 0) {
            UILabel *reviewAppraiseTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(headImgView.frame), _currentHeight + 10, SCREEN_WIDTH - 20, 20)];
            [self addSubview:reviewAppraiseTextLabel];
            reviewAppraiseTextLabel.numberOfLines = 0;
            reviewAppraiseTextLabel.font = font_1;
            reviewAppraiseTextLabel.textColor = color_1;
            reviewAppraiseTextLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"appendText"]];
            CGSize maximumLabelSize = CGSizeMake(SCREEN_WIDTH - 20, 200);//labelsize的最大值
            //关键语句
            CGSize expectSize = [reviewAppraiseTextLabel sizeThatFits:maximumLabelSize];
            //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
            reviewAppraiseTextLabel.frame = CGRectMake(CGRectGetMinX(headImgView.frame), _currentHeight + 10, expectSize.width, expectSize.height);
            
            _currentHeight = CGRectGetMaxY(reviewAppraiseTextLabel.frame);
        }
        
        //追评图片
        if ([dic objectForKey:@"appendImgUrl"] && [NSString stringWithFormat:@"%@",[dic objectForKey:@"appendImgUrl"]].length > 0) {
            //3.分隔字符串
            NSString *imgUrls =[NSString stringWithFormat:@"%@",[dic objectForKey:@"appendImgUrl"]];
            NSArray *imgArr = [imgUrls componentsSeparatedByString:@","]; //从字符A中分隔成多个元素的数组
            CGFloat imgWidth = (SCREEN_WIDTH - 40)/3;
            CGFloat imgTop = _currentHeight + 15;
            for (int i = 0; i < 2; i++) {
                for (int j = 0; j < 3; j++) {
                    if (i * 3 + j < imgArr.count) {
                        UIImageView *appraiseImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + (imgWidth + 10) * j, imgTop + (imgWidth + 10) * i, imgWidth, imgWidth)];
                        [self addSubview:appraiseImgView];
                        [appraiseImgView sd_setImageWithURL:[NSURL URLWithString:imgArr[i * 3 + j]]];
                        appraiseImgView.userInteractionEnabled = YES;
                        
                        //添加手势点击空白处隐藏键盘
                        UITapGestureRecognizer * tapGeture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickEnlarge:)];
                        tapGeture.numberOfTapsRequired  = 1;
                        [appraiseImgView addGestureRecognizer:tapGeture];
                        [tapGeture view].tag = i * 3 + j + 100;
                        
                        _currentHeight = CGRectGetMaxY(appraiseImgView.frame);
                    }
                }
            }
        }
        
        //商家回复追评内容
        if ([dic objectForKey:@"replyAppendText"] && [NSString stringWithFormat:@"%@",[dic objectForKey:@"replyAppendText"]].length > 0) {
            
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(headImgView.frame), _currentHeight + 10, SCREEN_WIDTH - 20, 20)];
            [self addSubview:titleLabel];
            titleLabel.font = font_2;
            titleLabel.textColor = [ResourceManager mainColor];
            titleLabel.text = @"商家回复:";
            
            UILabel *replyAppraiseLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(headImgView.frame), CGRectGetMaxY(titleLabel.frame) + 10, SCREEN_WIDTH - 20, 20)];
            [self addSubview:replyAppraiseLabel];
            replyAppraiseLabel.numberOfLines = 0;
            replyAppraiseLabel.font = font_1;
            replyAppraiseLabel.textColor = [ResourceManager mainColor];
            replyAppraiseLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"replyAppendText"]];
            CGSize maximumLabelSize = CGSizeMake(SCREEN_WIDTH - 20, 200);//labelsize的最大值
            //关键语句
            CGSize expectSize = [replyAppraiseLabel sizeThatFits:maximumLabelSize];
            //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
            replyAppraiseLabel.frame = CGRectMake(CGRectGetMinX(headImgView.frame), CGRectGetMaxY(titleLabel.frame) + 10, expectSize.width, expectSize.height);
            
            _currentHeight = CGRectGetMaxY(replyAppraiseLabel.frame) + 10;
        }
    }
    
    UIView *productView = [[UIView alloc]initWithFrame:CGRectMake(10, _currentHeight + 10, SCREEN_WIDTH - 20, 90)];
    [self addSubview:productView];
    productView.backgroundColor = [ResourceManager viewBackgroundColor];
    
    UIImageView *productImgView =  [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 70, 70)];
    [productView addSubview:productImgView];
    [productImgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"goodsUrl"]]];
    
    UILabel *productNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(productImgView.frame) + 20, CGRectGetMinY(productImgView.frame) + 5, 200, 20)];
    [productView addSubview:productNameLabel];
    productNameLabel.font = font_1;
    productNameLabel.textColor = color_1;
    productNameLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"goodsName"]];
    
     UILabel *productDescLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(productImgView.frame) + 20, CGRectGetMaxY(productNameLabel.frame) + 5, 200, 20)];
    [productView addSubview:productDescLabel];
    productDescLabel.font = font_2;
    productDescLabel.textColor = color_2;
    productDescLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"skuDesc"]];
    
    UILabel *productPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 180, CGRectGetMinY(productImgView.frame) + 5, 150, 20)];
    [productView addSubview:productPriceLabel];
    productPriceLabel.textAlignment = NSTextAlignmentRight;
    productPriceLabel.font = font_1;
    productPriceLabel.textColor = color_2;
    productPriceLabel.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"price"]];
    
    UILabel *productNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 180, CGRectGetMaxY(productPriceLabel.frame) + 5, 150, 20)];
    [productView addSubview:productNumLabel];
    productNumLabel.textAlignment = NSTextAlignmentRight;
    productNumLabel.font = font_2;
    productNumLabel.textColor = color_2;
    productNumLabel.text = [NSString stringWithFormat:@"x%@",[dic objectForKey:@"num"]];
    
    _currentHeight = CGRectGetMaxY(productView.frame) + 10;
    
//    UILabel *appraiseNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(productView.frame), 100, 40)];
//    [self addSubview:appraiseNumLabel];
//    appraiseNumLabel.font = font_2;
//    appraiseNumLabel.textColor = color_2;
//    appraiseNumLabel.text = [NSString stringWithFormat:@"评论%@次",[dic objectForKey:@"commCount"]];
//    appraiseNumLabel.frame = CGRectMake(10, CGRectGetMaxY(productView.frame) + 10, 100, 30);
    
//    _currentHeight = CGRectGetMaxY(appraiseNumLabel.frame);
    
    //追评按钮
   if ([[dic objectForKey:@"commentStatus"] intValue] == 2) {
        UIButton *reviewAppraiseBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 90, _currentHeight, 80, 30)];
       [self addSubview:reviewAppraiseBtn];
       reviewAppraiseBtn.layer.cornerRadius = 3;
       reviewAppraiseBtn.layer.borderWidth = 0.5;
       reviewAppraiseBtn.layer.borderColor = [ResourceManager color_5].CGColor;
       reviewAppraiseBtn.titleLabel.font = font_1;
       [reviewAppraiseBtn setTitle:@"写追评" forState:UIControlStateNormal];
       [reviewAppraiseBtn setTitleColor:color_1 forState:UIControlStateNormal];
       [reviewAppraiseBtn addTarget:self action:@selector(reviewAppraise) forControlEvents:UIControlEventTouchUpInside];
       
       _currentHeight = CGRectGetMaxY(reviewAppraiseBtn.frame) + 10;
    }
    
 
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _currentHeight, SCREEN_WIDTH, 10)];
    [self addSubview:lineView];
    lineView.backgroundColor = [ResourceManager viewBackgroundColor];
    
    _currentHeight = CGRectGetMaxY(lineView.frame);
}


-(void)reviewAppraise{
    if (self.myAppraiseBlock) {
        self.myAppraiseBlock();
    }
}

//点击图片放大
-(void)clickEnlarge:(UITapGestureRecognizer *)tapGesture{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)tapGesture;
    if (self.clickEnlargeBlock) {
        self.clickEnlargeBlock((int)singleTap.view.tag);
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
