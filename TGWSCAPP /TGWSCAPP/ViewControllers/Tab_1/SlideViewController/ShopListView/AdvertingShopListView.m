//
//  AdvertingShopListView.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/14.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "AdvertingShopListView.h"

@implementation AdvertingShopListView
{
    NSString *_title;
    NSArray *_items;
    CGFloat _origin_Y;
    int  _columnOneCount; // 第一行的元素个数
    int  _columnTwoCount; // 第二行之后的 每行的元素个数
}



-(AdvertingShopListView*)initWithTitle:(NSString *)title  itemArray:(NSArray *)items origin_Y:(CGFloat)origin_Y
{
    self =  [super initWithFrame:CGRectMake(0, origin_Y, SCREEN_WIDTH, 100)];
    
    _title = title;
    _items = items;
    _origin_Y = origin_Y;
    
    [self drawList];
    
    return self;
}


-(AdvertingShopListView*)initWithTitle:(NSString *)title  itemArray:(NSArray *)items origin_Y:(CGFloat)origin_Y
                         columnOneCount:(int)columnOneCount  columnTwoCount:(int)columnTwoCount
{
    self =  [super initWithFrame:CGRectMake(0, origin_Y, SCREEN_WIDTH, 100)];
    
    _title = title;
    _items = items;
    _origin_Y = origin_Y;
    _columnOneCount = columnOneCount; // 第一行的元素个数
    _columnTwoCount = columnTwoCount; // 第二行之后的 每行的元素个数
    
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
    
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, fTopY+3, 80, iTitleHeight)];
    //[self addSubview:btnRight];
    [btnRight setTitleColor:[ResourceManager lightGrayColor] forState:UIControlStateNormal];
    [btnRight setTitle:@"更多>" forState:UIControlStateNormal];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnRight addTarget:self action:@selector(actionMore) forControlEvents:UIControlEventTouchUpInside];
    
    
    fTopY +=labelTitle.height;
    
    float fImgTopY = fTopY;
    if (_items &&
        [_items count])
     {
        //ShopModel *sModel= _items[0];
        NSString *strImgName = @"Tab1_TJSP";//sModel.strShopImgUrl;
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
        fLeftX = (SCREEN_WIDTH  - 2 *fImgWidth - fImgBettewn)/2;
        float fImgLeftX = fLeftX;
        
        for (int i = 0; i < [_items count]; i++)
         {
            UIImageView *imgViewTemp = [[UIImageView alloc] initWithFrame:CGRectMake(fImgLeftX, fImgTopY, fImgWidth, fImgHeight)];
            [self  addSubview:imgViewTemp];
            
            ShopModel *sModel= _items[i];
            NSString *strImgName = sModel.strGoodsImgUrl;
            //imgTemp = [ToolsUtlis getImgFromStr:strImgName];
            //imgViewTemp.image  = imgTemp;
            [imgViewTemp sd_setImageWithURL:[NSURL URLWithString:strImgName] placeholderImage:[UIImage imageNamed:strImgName]];
            
            UIButton *btnTemp = [[UIButton alloc] initWithFrame:imgViewTemp.frame];
            [self addSubview:btnTemp];
            btnTemp.tag = i;
            [btnTemp addTarget:self action:@selector(actionImg:) forControlEvents:UIControlEventTouchUpInside];
            
            if ((i +1) %2 == 0)
             {
                fImgTopY += fImgHeight + fImgBettewn;
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


// 根据特殊参数来画
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
    
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, fTopY+3, 80, iTitleHeight)];
    [self addSubview:btnRight];
    [btnRight setTitleColor:[ResourceManager lightGrayColor] forState:UIControlStateNormal];
    //[btnRight setTitle:@"更多>" forState:UIControlStateNormal];
    btnRight.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnRight addTarget:self action:@selector(actionMore) forControlEvents:UIControlEventTouchUpInside];
    
    
    fTopY +=labelTitle.height;
    
    
    float fImgTopY = fTopY;
    if (_items &&
        [_items count])
     {
        
        int iShopCount = (int)[_items count];
        // 画第一行
        //ShopModel *sModel= _items[0];
        //NSString *strImgName = sModel.strShopImgUrl;
        NSString *strImgName = @"Tab1_TJSP";//
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
        float fImgBettewn = 1.5 *ScaleSize;
        fLeftX = (SCREEN_WIDTH  - _columnOneCount *fImgWidth - (_columnOneCount - 1)*fImgBettewn)/ 2;
        
        if (_columnOneCount == 1)
         {
            fLeftX = 11 * ScaleSize;
            fImgWidth = SCREEN_WIDTH - 2*fLeftX;
         }
        
        float fImgLeftX = fLeftX;
        
        for (int i = 0;  i < _columnOneCount; i++)
         {
            UIImageView *imgViewTemp = [[UIImageView alloc] initWithFrame:CGRectMake(fImgLeftX, fImgTopY, fImgWidth, fImgHeight)];
            [self  addSubview:imgViewTemp];
            
            ShopModel *sModel= _items[i];
            NSString *strImgName = sModel.strGoodsImgUrl;
            //imgTemp = [ToolsUtlis getImgFromStr:strImgName];
            //imgViewTemp.image  = imgTemp;
            [imgViewTemp sd_setImageWithURL:[NSURL URLWithString:strImgName] placeholderImage:[UIImage imageNamed:strImgName]];
            
            UIButton *btnTemp = [[UIButton alloc] initWithFrame:imgViewTemp.frame];
            [self addSubview:btnTemp];
            btnTemp.tag = i;
            [btnTemp addTarget:self action:@selector(actionImg:) forControlEvents:UIControlEventTouchUpInside];
            

            
            fImgLeftX += fImgBettewn + fImgWidth;
            
         }
        
        
        
        // 如果只有一排
        if (_columnOneCount == iShopCount)
         {
            fImgTopY += fImgHeight + fImgBettewn;
            self.height = fImgTopY;
            return;
         }
        
        // 画第二排
        //ShopModel *sModel2= _items[_columnOneCount];
        NSString *strImgName2 = @"Tab1_TJSP";//sModel2.strShopImgUrl;
        UIImage *imgTemp2 = [ToolsUtlis getImgFromStr:strImgName2];
        if (!imgTemp2)
         {
            return;
         }
        
        
        fixelH = CGImageGetHeight(imgTemp2.CGImage);
        fixelW = CGImageGetWidth(imgTemp2.CGImage);
        fImgHeight = fixelH *FixelScaleSize*ScaleSize;
        fImgWidth = fixelW *FixelScaleSize*ScaleSize;
        //fImgTopY = fTopY;
        fImgTopY += fImgHeight + fImgBettewn;
        fImgBettewn = 1.5 *ScaleSize;
        fLeftX = (SCREEN_WIDTH  - _columnTwoCount *fImgWidth - (_columnTwoCount - 1)*fImgBettewn)/2;

        if (_columnTwoCount == 1)
         {
            fLeftX = 11 * ScaleSize;
            fImgWidth = SCREEN_WIDTH - 2*fLeftX;
         }
        
        fImgLeftX = fLeftX;
        
        for (int i = _columnOneCount; i < iShopCount; i++)
         {
            UIImageView *imgViewTemp = [[UIImageView alloc] initWithFrame:CGRectMake(fImgLeftX, fImgTopY, fImgWidth, fImgHeight)];
            [self  addSubview:imgViewTemp];
            
            ShopModel *sModel= _items[i];
            NSString *strImgName = sModel.strGoodsImgUrl;
            //imgTemp = [ToolsUtlis getImgFromStr:strImgName];
            //imgViewTemp.image  = imgTemp;
            [imgViewTemp sd_setImageWithURL:[NSURL URLWithString:strImgName] placeholderImage:[UIImage imageNamed:strImgName]];
            
            UIButton *btnTemp = [[UIButton alloc] initWithFrame:imgViewTemp.frame];
            [self addSubview:btnTemp];
            btnTemp.tag = i;
            [btnTemp addTarget:self action:@selector(actionImg:) forControlEvents:UIControlEventTouchUpInside];
            
            if ((i +1 - _columnOneCount) %_columnTwoCount == 0)
             {
                fImgTopY += fImgHeight + fImgBettewn;
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
    if ([self.delegate respondsToSelector:@selector(didClickButtonAtObejct:)]) {
        ShopModel *mode = [[ShopModel alloc] init];
        mode = _shopModel;
        _shopModel.iShopID = -1;
        [self.delegate didClickButtonAtObejct:_shopModel];
    }
}

-(void) actionImg:(UIButton*) sender
{
    int iTag = (int)sender.tag;
    if (iTag < [_items count])
     {
        ShopModel *sModel = _items[iTag];
        if ([self.delegate respondsToSelector:@selector(didClickButtonAtObejct:)]) {
            [self.delegate didClickButtonAtObejct:sModel];
        }
     }
}

@end
