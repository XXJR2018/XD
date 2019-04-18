//
//  AllAppraiseView.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/25.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "AllAppraiseView.h"

#import "XHStarRateView.h"

@interface AllAppraiseView ()

@property(nonatomic, assign)CGFloat currentHeight;

@end

@implementation AllAppraiseView

-(UIView *)initWithAppraiseListViewLayoutUI:(NSDictionary *)dic{
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CellHeight44)];
    
    if (self) {
        _currentHeight = 0;
        self.backgroundColor = [UIColor whiteColor];
        
        [self layoutCellUI:dic];
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, _currentHeight + 10);
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
    [nameLabel sizeToFit];
    
    XHStarRateView *msStarRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame) + 5, CGRectGetMidY(nameLabel.frame) - 5, 80, 10)];
    [self addSubview:msStarRateView];
    msStarRateView.currentScore = [[dic objectForKey:@"goodsGrade"] intValue];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(headImgView.frame), CGRectGetMaxY(headImgView.frame), SCREEN_WIDTH - 20, 20)];
    [self addSubview:timeLabel];
    timeLabel.font = font_2;
    timeLabel.textColor = color_2;
    timeLabel.text = [NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"createTime"],[dic objectForKey:@"skuDesc"]];
    
    _currentHeight = CGRectGetMaxY(timeLabel.frame);
    //评价内容
    if ([dic objectForKey:@"commentText"] && [NSString stringWithFormat:@"%@",[dic objectForKey:@"commentText"]].length > 0) {
        UILabel *appraiseTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(headImgView.frame), _currentHeight + 5, SCREEN_WIDTH - 20, 20)];
        [self addSubview:appraiseTextLabel];
        appraiseTextLabel.numberOfLines = 0;
        appraiseTextLabel.font = font_1;
        appraiseTextLabel.textColor = color_1;
        appraiseTextLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"commentText"]];
        CGSize maximumLabelSize = CGSizeMake(SCREEN_WIDTH - 20, 200);//labelsize的最大值
        //关键语句
        CGSize expectSize = [appraiseTextLabel sizeThatFits:maximumLabelSize];
        //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
        appraiseTextLabel.frame = CGRectMake(CGRectGetMinX(headImgView.frame), _currentHeight + 5, expectSize.width, expectSize.height);
        
        _currentHeight = CGRectGetMaxY(appraiseTextLabel.frame);
    }
    
    //评价图片
    if ([dic objectForKey:@"imgUrl"] && [NSString stringWithFormat:@"%@",[dic objectForKey:@"imgUrl"]].length > 0) {
        //3.分隔字符串
        NSString *imgUrls =[NSString stringWithFormat:@"%@",[dic objectForKey:@"imgUrl"]];
        NSArray *imgArr = [imgUrls componentsSeparatedByString:@","]; //从字符A中分隔成多个元素的数组
        CGFloat imgWidth = (SCREEN_WIDTH - 40)/3;
        CGFloat imgTop = _currentHeight + 10;
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
        
        UIView *replyView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(headImgView.frame), _currentHeight + 10, SCREEN_WIDTH - 20, 20)];
        [self addSubview:replyView];
        replyView.backgroundColor = [ResourceManager viewBackgroundColor];
        replyView.layer.cornerRadius = 5;
        
        UILabel *replyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, replyView.frame.size.width - 20, 20)];
        [replyView addSubview:replyLabel];
        replyLabel.numberOfLines = 0;
        replyLabel.font = font_1;
        replyLabel.textColor = [ResourceManager mainColor];
        NSString *replyStr = [NSString stringWithFormat:@"商家回复：%@",[dic objectForKey:@"replyText"]];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]
                                              initWithString:replyStr];
        //2.匹配字符串
        [attrStr addAttribute:NSForegroundColorAttributeName value:[ResourceManager mainColor] range:NSMakeRange(0, 5)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:color_1 range:NSMakeRange(5, replyStr.length - 5)];
        replyLabel.attributedText = attrStr;
        
        CGSize maximumLabelSize = CGSizeMake(replyView.frame.size.width - 20, 200);//labelsize的最大值
        //关键语句
        CGSize expectSize = [replyLabel sizeThatFits:maximumLabelSize];
        //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
        replyLabel.frame = CGRectMake(10, 10, expectSize.width, expectSize.height);
        
        replyView.height = CGRectGetMaxY(replyLabel.frame) + 10;
        _currentHeight = CGRectGetMaxY(replyView.frame);
    }
    
    //已追评
    if ([[dic objectForKey:@"commentStatus"] intValue] == 3) {
        //追评时间
        if ([dic objectForKey:@"appendDate"] && [NSString stringWithFormat:@"%@",[dic objectForKey:@"appendDate"]].length > 0) {
            UILabel *reviewtimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(headImgView.frame), _currentHeight + 10, SCREEN_WIDTH - 20, 20)];
            [self addSubview:reviewtimeLabel];
            reviewtimeLabel.font = font_1;
            reviewtimeLabel.textColor = [ResourceManager mainColor];
            reviewtimeLabel.text = [NSString stringWithFormat:@"用户%@天后追加评论",[dic objectForKey:@"appendDate"]];
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
            UIView *replyAppendView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(headImgView.frame), _currentHeight + 10, SCREEN_WIDTH - 20, 20)];
            [self addSubview:replyAppendView];
            replyAppendView.backgroundColor = [ResourceManager viewBackgroundColor];
            replyAppendView.layer.cornerRadius = 5;
            
            UILabel *replyAppendLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, replyAppendView.frame.size.width - 20, 20)];
            [replyAppendView addSubview:replyAppendLabel];
            replyAppendLabel.numberOfLines = 0;
            replyAppendLabel.font = font_1;
            replyAppendLabel.textColor = [ResourceManager mainColor];
            NSString *replyStr = [NSString stringWithFormat:@"商家回复：%@",[dic objectForKey:@"replyAppendText"]];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]
                                                  initWithString:replyStr];
            //2.匹配字符串
            [attrStr addAttribute:NSForegroundColorAttributeName value:[ResourceManager mainColor] range:NSMakeRange(0, 5)];
            [attrStr addAttribute:NSForegroundColorAttributeName value:color_1 range:NSMakeRange(5, replyStr.length - 5)];
            replyAppendLabel.attributedText = attrStr;
            
            CGSize maximumLabelSize = CGSizeMake(replyAppendView.frame.size.width - 20, 200);//labelsize的最大值
            //关键语句
            CGSize expectSize = [replyAppendLabel sizeThatFits:maximumLabelSize];
            //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
            replyAppendLabel.frame = CGRectMake(10, 10, expectSize.width, expectSize.height);
            
            replyAppendView.height = CGRectGetMaxY(replyAppendLabel.frame) + 10;
            _currentHeight = CGRectGetMaxY(replyAppendView.frame);
        }
    }
    
}

//点击图片放大
-(void)clickEnlarge:(UITapGestureRecognizer *)tapGesture{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)tapGesture;
    if (self.clickEnlargeBlock) {
        self.clickEnlargeBlock((int)singleTap.view.tag);
    }
}


@end
