//
//  ShopListView.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/14.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "ShopListView.h"

@implementation ShopListView
{
    NSString *_title;
    NSArray *_items;
    CGFloat _origin_Y;
    int _columnCount;  // 美一样元素的个数
    
    int  _columnOneCount; // 第一行的元素个数
    int  _columnTwoCount; // 第二行之后的 每行的元素个数
}


-(ShopListView*)initWithTitle:(NSString *)title  itemArray:(NSArray *)items  columnCount:(int)columnCount origin_Y:(CGFloat)origin_Y
{
    self =  [super initWithFrame:CGRectMake(0, origin_Y, SCREEN_WIDTH, 100)];
    
    _title = title;
    _items = items;
    _columnCount = columnCount;
    _origin_Y = origin_Y;
    
    [self drawList];
    
    return self;
}


//  columnOneCount - 第一行的元素个数
//  columnTwoCount - 第二行之后的 每行的元素个数
-(ShopListView*)initWithTitle:(NSString *)title  itemArray:(NSArray *)items origin_Y:(CGFloat)origin_Y
               columnOneCount:(int)columnOneCount  columnTwoCount:(int)columnTwoCount
{
    self =  [super initWithFrame:CGRectMake(0, origin_Y, SCREEN_WIDTH, 100)];
    
    _title = title;
    _items = items;
    _origin_Y = origin_Y;
    
    _columnOneCount = columnOneCount;
    _columnTwoCount = columnTwoCount;
    
    [self drawListTwo];
    
    return self;
}

-(void) drawList
{
    float fTopY = 0;
    float fLeftX = 15*ScaleSize;
    int iTitleHeight = 50;
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX, fTopY, SCREEN_WIDTH - fLeftX - 100, iTitleHeight)];
    [self addSubview:labelTitle];
    labelTitle.font = [ResourceManager fontTitle];
    labelTitle.textColor = [ResourceManager color_1];
    labelTitle.text = _title;
    
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, fTopY, 80, iTitleHeight)];
    [self addSubview:btnRight];
    [btnRight setTitleColor:[ResourceManager lightGrayColor] forState:UIControlStateNormal];
    [btnRight setTitle:@"更多>" forState:UIControlStateNormal];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnRight addTarget:self action:@selector(actionMore) forControlEvents:UIControlEventTouchUpInside];
    
    
    fTopY +=labelTitle.height;
    
    float fImgTopY = fTopY;
    if (_items &&
        [_items count])
     {
        ShopModel *sModel= _items[0];
        NSString *strImgName = sModel.strGoodsImgUrl;
        UIImage *imgTemp = [ToolsUtlis getImgFromStr:strImgName];
        if (!imgTemp)
         {
            return;
         }
        
        CGFloat fixelH = CGImageGetHeight(imgTemp.CGImage);
        CGFloat fixelW = CGImageGetWidth(imgTemp.CGImage);
        float fImgHeight = fixelH *FixelScaleSize*ScaleSize;
        float fImgWidth = fixelW *FixelScaleSize*ScaleSize;
        fImgTopY = fTopY;
        float fImgBettewn = 5 *ScaleSize;
        //fLeftX = (SCREEN_WIDTH  - 2 *fImgWidth - fImgBettewn)/2;
        fLeftX = (SCREEN_WIDTH  - _columnCount *fImgWidth - fImgBettewn)/_columnCount;
        float fImgLeftX = fLeftX;
        
        float fLabelNameHeight = 45.f;
        float fLablePriceHeight = 20.f;
        
        for (int i = 0; i < [_items count]; i++)
         {
            UIImageView *imgViewTemp = [[UIImageView alloc] initWithFrame:CGRectMake(fImgLeftX, fImgTopY, fImgWidth, fImgHeight)];
            [self  addSubview:imgViewTemp];
            
            ShopModel *sModel= _items[i];
            NSString *strImgName = sModel.strGoodsImgUrl;
//            imgTemp = [ToolsUtlis getImgFromStr:strImgName];
//            imgViewTemp.image  = imgTemp;
            [imgViewTemp sd_setImageWithURL:[NSURL URLWithString:strImgName] placeholderImage:[UIImage imageNamed:strImgName]];
            
            UILabel *labelShopName = [[UILabel alloc] initWithFrame:CGRectMake(fImgLeftX, fImgTopY + fImgHeight, fImgWidth, fLabelNameHeight)];
            [self addSubview:labelShopName];
            //labelShopName.backgroundColor = [UIColor yellowColor];
            labelShopName.font = [UIFont systemFontOfSize:13];
            labelShopName.textColor = [ResourceManager color_1];
            labelShopName.text = sModel.strGoodsName;
            labelShopName.numberOfLines = 0;
            
            
            UILabel *labelShopPrice = [[UILabel alloc] initWithFrame:CGRectMake(fImgLeftX, fImgTopY + fImgHeight + fLabelNameHeight, fImgWidth, fLablePriceHeight)];
            [self addSubview:labelShopPrice];
            //labelShopName.backgroundColor = [UIColor yellowColor];
            labelShopPrice.font = [UIFont systemFontOfSize:15];
            labelShopPrice.textColor = UIColorFromRGB(0x9f1421);
            labelShopPrice.text = [NSString stringWithFormat:@"￥%@", sModel.strMinPrice];//sModel.strMaxPrice;
            labelShopPrice.numberOfLines = 0;
            
            UIButton *btnTemp = [[UIButton alloc] initWithFrame:imgViewTemp.frame];
            [self addSubview:btnTemp];
            btnTemp.tag = i;
            [btnTemp addTarget:self action:@selector(actionImg:) forControlEvents:UIControlEventTouchUpInside];
            
            if ((i +1) %_columnCount == 0)
             {
                fImgTopY += fImgHeight + fImgBettewn + fLabelNameHeight + fLablePriceHeight + fImgBettewn;
                fImgLeftX = fLeftX;
             }
            else
             {
                fImgLeftX += fImgBettewn + fImgWidth;
             }
            
         }
        
     }
    
    self.height = fImgTopY;
    
    
    
}

// 全部用正方形来画图
-(void) drawListTwo
{
    float fTopY = 0;
    float fLeftX = 15*ScaleSize;
    int iTitleHeight = 50;
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(fLeftX, fTopY, SCREEN_WIDTH - fLeftX - 100, iTitleHeight)];
    [self addSubview:labelTitle];
    labelTitle.font = [ResourceManager fontTitle];
    labelTitle.textColor = [ResourceManager color_1];
    labelTitle.text = _title;
    
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, fTopY, 80, iTitleHeight)];
    [self addSubview:btnRight];
    [btnRight setTitleColor:[ResourceManager lightGrayColor] forState:UIControlStateNormal];
    [btnRight setTitle:@"更多>" forState:UIControlStateNormal];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnRight addTarget:self action:@selector(actionMore) forControlEvents:UIControlEventTouchUpInside];
    
    
    fTopY +=labelTitle.height;
    
    float fImgTopY = fTopY;
    if (_items &&
        [_items count])
     {
        int iShopCount = (int)[_items count];
        
        float fImgBettewn = 5 *ScaleSize;
        float fImgHeight = (SCREEN_WIDTH - 2*fLeftX - (_columnOneCount -1)* fImgBettewn) / _columnOneCount;
        float fImgWidth = fImgHeight;
        fImgTopY = fTopY;
        float fImgLeftX = fLeftX;
        
        float fLabelNameHeight = 45.f;
        float fLablePriceHeight = 20.f;
        
        for (int i = 0; i < _columnOneCount; i++)
         {
            UIImageView *imgViewTemp = [[UIImageView alloc] initWithFrame:CGRectMake(fImgLeftX, fImgTopY, fImgWidth, fImgHeight)];
            [self  addSubview:imgViewTemp];
            
            ShopModel *sModel= _items[i];
            NSString *strImgName = sModel.strGoodsImgUrl;
            //imgTemp = [ToolsUtlis getImgFromStr:strImgName];
            //imgViewTemp.image  = imgTemp;
            [imgViewTemp sd_setImageWithURL:[NSURL URLWithString:strImgName] placeholderImage:[UIImage imageNamed:strImgName]];
            
            
            UILabel *labelShopName = [[UILabel alloc] initWithFrame:CGRectMake(fImgLeftX, fImgTopY + fImgHeight, fImgWidth, fLabelNameHeight)];
            [self addSubview:labelShopName];
            //labelShopName.backgroundColor = [UIColor yellowColor];
            labelShopName.font = [UIFont systemFontOfSize:14];
            labelShopName.textColor = [ResourceManager color_1];
            labelShopName.text = sModel.strGoodsName;
            labelShopName.numberOfLines = 0;
            
            
            UILabel *labelShopPrice = [[UILabel alloc] initWithFrame:CGRectMake(fImgLeftX, fImgTopY + fImgHeight + fLabelNameHeight, fImgWidth, fLablePriceHeight)];
            [self addSubview:labelShopPrice];
            //labelShopName.backgroundColor = [UIColor yellowColor];
            labelShopPrice.font = [UIFont systemFontOfSize:16];
            labelShopPrice.textColor = UIColorFromRGB(0x9f1421);
            labelShopPrice.text =  [NSString stringWithFormat:@"￥%@", sModel.strMinPrice];
            labelShopPrice.numberOfLines = 0;
            
            UIButton *btnTemp = [[UIButton alloc] initWithFrame:imgViewTemp.frame];
            [self addSubview:btnTemp];
            btnTemp.tag = i;
            [btnTemp addTarget:self action:@selector(actionImg:) forControlEvents:UIControlEventTouchUpInside];
            
            fImgLeftX += fImgBettewn + fImgWidth;
            
            
         }
        
        
        // 如果只有一排
        if (_columnOneCount == iShopCount)
         {
            fImgTopY += fImgHeight + 2*fImgBettewn;
            self.height = fImgTopY  + fLabelNameHeight + fLablePriceHeight + 10 ;
            return;
         }
        

        fImgHeight = (SCREEN_WIDTH - 2*fLeftX - (_columnTwoCount -1)* fImgBettewn) / _columnTwoCount;
        fImgWidth = fImgHeight;
        fImgTopY += fImgHeight + 2*fImgBettewn + fLabelNameHeight + fLablePriceHeight + fImgBettewn;
        fImgBettewn = 5 *ScaleSize;
        fImgLeftX = fLeftX;

        fLabelNameHeight = 45.f;
        fLablePriceHeight = 20.f;

        for (int i = _columnOneCount; i < iShopCount; i++)
         {
            UIImageView *imgViewTemp = [[UIImageView alloc] initWithFrame:CGRectMake(fImgLeftX, fImgTopY, fImgWidth, fImgHeight)];
            [self  addSubview:imgViewTemp];

            ShopModel *sModel= _items[i];
            NSString *strImgName = sModel.strGoodsImgUrl;
            //imgTemp = [ToolsUtlis getImgFromStr:strImgName];
            //imgViewTemp.image  = imgTemp;
            [imgViewTemp sd_setImageWithURL:[NSURL URLWithString:strImgName] placeholderImage:[UIImage imageNamed:strImgName]];

            UILabel *labelShopName = [[UILabel alloc] initWithFrame:CGRectMake(fImgLeftX, fImgTopY + fImgHeight, fImgWidth, fLabelNameHeight)];
            [self addSubview:labelShopName];
            //labelShopName.backgroundColor = [UIColor yellowColor];
            labelShopName.font = [UIFont systemFontOfSize:14];
            labelShopName.textColor = [ResourceManager color_1];
            labelShopName.text = sModel.strGoodsName;
            labelShopName.numberOfLines = 0;


            UILabel *labelShopPrice = [[UILabel alloc] initWithFrame:CGRectMake(fImgLeftX, fImgTopY + fImgHeight + fLabelNameHeight, fImgWidth, fLablePriceHeight)];
            [self addSubview:labelShopPrice];
            //labelShopName.backgroundColor = [UIColor yellowColor];
            labelShopPrice.font = [UIFont systemFontOfSize:16];
            labelShopPrice.textColor = UIColorFromRGB(0x9f1421);
            labelShopPrice.text = [NSString stringWithFormat:@"￥%@", sModel.strMinPrice];//sModel.strMaxPrice;
            labelShopPrice.numberOfLines = 0;

            UIButton *btnTemp = [[UIButton alloc] initWithFrame:imgViewTemp.frame];
            [self addSubview:btnTemp];
            btnTemp.tag = i;
            [btnTemp addTarget:self action:@selector(actionImg:) forControlEvents:UIControlEventTouchUpInside];

            if ((i +1 - _columnOneCount) %_columnTwoCount == 0)
             {
                fImgTopY += fImgHeight + fImgBettewn + fLabelNameHeight + fLablePriceHeight + fImgBettewn;
                fImgLeftX = fLeftX;
             }
            else
             {
                fImgLeftX += fImgBettewn + fImgWidth;
             }

         }
        
     }
    
    self.height = fImgTopY;
    
    
    
}

#pragma mark --- action
-(void) actionMore
{
    if ([self.delegate respondsToSelector:@selector(didShopClickButtonAtObejct:)]) {
        ShopModel *mode = [[ShopModel alloc] init];
        mode = _shopModel;
        mode.iShopID = -1;
        [self.delegate didShopClickButtonAtObejct:mode];
    }
}

-(void) actionImg:(UIButton*) sender
{
    int iTag = (int)sender.tag;
    if (iTag < [_items count])
     {
        ShopModel *sModel = _items[iTag];
        if ([self.delegate respondsToSelector:@selector(didShopClickButtonAtObejct:)]) {
            [self.delegate didShopClickButtonAtObejct:sModel];
        }
     }
}


@end
