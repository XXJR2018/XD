//
//  ShareShopJpegView.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/2/28.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "ShareShopJpegView.h"



@interface ShareShopJpegView ()<UIScrollViewDelegate>
{
    UIScrollView * scrolView;
    UILabel  *labelIndex;
    
    NSArray *arrImgURL;
    NSMutableArray *arrImg;
    int iCurNO;  // 从1开始计数
    
    NSString *qrcodeUrl;
    UIImage *imageEWM;
    int iIMGSaveNo;     // 当为零时， 确认保存图片成功
}

@end


@implementation ShareShopJpegView

-(ShareShopJpegView*) initWithArrImg:(NSArray *)arr   withNo:(int) iNo  withShopModel:(ShopModel*) sModel
{
    self =  [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    arrImgURL = arr;
    
    iCurNO = iNo;
    
    arrImg = [[NSMutableArray alloc] init];
    
    _shopModel = [[ShopModel alloc] init];
    
    _shopModel = sModel;
    
    [self getShareQrcode];
    
    [self drawUI];
    
    return self;
}

-(void) drawUI
{
    self.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.85];
    
    int iTopY = 10;
    if (IS_IPHONE_X_MORE)
     {
        iTopY = 70;
     }
    int iLeftX = 15;
    UIButton *btnSaveAllImg = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 150, 50)];
    [self addSubview:btnSaveAllImg];
    [btnSaveAllImg setTitle:@"  保存全部图片" forState:UIControlStateNormal];
    btnSaveAllImg.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnSaveAllImg setImage:[UIImage imageNamed:@"com_download"] forState:UIControlStateNormal];
    [btnSaveAllImg addTarget:self action:@selector(actionSaveAll) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btnColse = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - iLeftX - 50, iTopY, 50, 50)];
    [self addSubview:btnColse];
    [btnColse setImage:[UIImage imageNamed:@"com_colse3"] forState:UIControlStateNormal];
    [btnColse addTarget:self action:@selector(actionClose) forControlEvents:UIControlEventTouchUpInside];
    
    // 布局图片
    scrolView = [[UIScrollView alloc]init];
    scrolView.pagingEnabled  = YES;
    scrolView.delegate = self;
    scrolView.showsVerticalScrollIndicator = NO;
    scrolView.showsHorizontalScrollIndicator = NO;
    scrolView.userInteractionEnabled = YES;
    
    scrolView.alwaysBounceVertical = NO;
    scrolView.alwaysBounceHorizontal = NO;
    
    [self addSubview:scrolView];
    
    int iBetwwen = 50;
//    if (IS_IPHONE_X_MORE)
//     {
//        iBetwwen = 50;
//     }
    int iTopImgHeight = 100;
    int iTaiImgHeight = 90;
    int iViewImgWidth = SCREEN_WIDTH  - 2*iBetwwen;
    int iScrolViewHeight = iTopImgHeight +  iViewImgWidth  + iTaiImgHeight + 20;
    iTopY += btnColse.height + 10 ;
    scrolView.frame = CGRectMake(0, iTopY, SCREEN_WIDTH, iScrolViewHeight);
    //scrolView.backgroundColor = [UIColor yellowColor];
    
    
    
    
    NSString *strTopImgUrl =  [CommonInfo getKey:K_ShopTopImgUrl];
    
    
    for (int i = 0; i < arrImgURL.count; i ++)
     {
        
        // 加入整体的viewImg
        UIView *viewImg = [[UIView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH + iBetwwen, 0, iViewImgWidth, iScrolViewHeight)];
        [scrolView addSubview:viewImg];
        viewImg.backgroundColor = [UIColor whiteColor];
        [arrImg addObject:viewImg];
 
        
        // 加入头部的LOGO图片
        UIImageView * imgLogo = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, iViewImgWidth, iTopImgHeight)];
        [imgLogo sd_setImageWithURL:[NSURL URLWithString:strTopImgUrl]];
        [viewImg addSubview:imgLogo];

        // 加入中部的商品详情图片
        UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(0, iTopImgHeight, iViewImgWidth, iViewImgWidth)];
        img.userInteractionEnabled = YES;
        NSString *strUrl = arrImgURL[i];
        [img sd_setImageWithURL:[NSURL URLWithString:strUrl]];
        [viewImg addSubview:img];
        //[scrolView addSubview:img];
        
        // 加入底部的 二维码图片 和 商品基本信息
        int iTailTop = iTopImgHeight + iViewImgWidth;
        int iLabelWidth = iViewImgWidth - 10  - iTopImgHeight;
        UILabel *labelShopName = [[UILabel alloc] initWithFrame:CGRectMake(10, iTailTop + 5, iLabelWidth, 50)];
        [viewImg addSubview:labelShopName];
        //labelShopName.backgroundColor = [UIColor yellowColor];
        labelShopName.textColor = [ResourceManager color_1];
        labelShopName.font = [UIFont systemFontOfSize:14];
        labelShopName.numberOfLines = 0;
        labelShopName.text = _shopModel.strGoodsName;
        
        UILabel *labelPrice = [[UILabel alloc] initWithFrame:CGRectMake(10, iTailTop + 10 + 50+ 5, iLabelWidth, 20)];
        [viewImg addSubview:labelPrice];
        labelPrice.textColor = [ResourceManager priceColor];
        labelPrice.font = [UIFont systemFontOfSize:17];
        //labelPrice.text = [NSString stringWithFormat:@"¥%@",_shopModel.strMinPrice];
        if (![_shopModel.strMinPrice isEqualToString:_shopModel.strMaxPrice])
         {
            NSString *strAll = [NSString stringWithFormat:@"¥%@起",_shopModel.strMinPrice];;
            NSString *strSub = @"起";
            NSRange range = [strAll rangeOfString:strSub];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strAll];
            //[str addAttribute:NSForegroundColorAttributeName value:[ResourceManager priceColor] range:range]; //设置字体颜色
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:14.0] range:range]; //设置字体字号和字体类别
            
            strSub = @"¥";
            range = [strAll rangeOfString:strSub];
            //[str addAttribute:NSForegroundColorAttributeName value:[ResourceManager priceColor] range:range]; //设置字体颜色
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:14.0] range:range]; //设置字体字号和字体类别
            
            labelPrice.attributedText = str;
         }
        else
         {
          
            NSString *strAll = [NSString stringWithFormat:@"¥%@",_shopModel.strMinPrice];;
            NSString *strSub = @"¥";
            NSRange range = [strAll rangeOfString:strSub];
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strAll];
            //[str addAttribute:NSForegroundColorAttributeName value:[ResourceManager priceColor] range:range]; //设置字体颜色
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:14.0] range:range]; //设置字体字号和字
        
            labelPrice.attributedText = str;
         }
        
        UILabel *labelNote = [[UILabel alloc] initWithFrame:CGRectMake(0, iTailTop + iTaiImgHeight, iViewImgWidth-10, 20)];
        [viewImg addSubview:labelNote];
        //labelShopName.backgroundColor = [UIColor yellowColor];
        labelNote.textColor = [ResourceManager color_1];
        labelNote.font = [UIFont systemFontOfSize:9];
        labelNote.text = @"长按进入小程序";
        labelNote.textAlignment = NSTextAlignmentRight;
        
        if (imageEWM)
         {
            UIImageView *imgViewEWM = [[UIImageView alloc] initWithFrame:CGRectMake(iViewImgWidth - iTaiImgHeight+5, iTailTop+5, iTaiImgHeight-10, iTaiImgHeight-10)];
            [viewImg addSubview:imgViewEWM];
            imgViewEWM.image = imageEWM;
         }
        
     }
    
    scrolView.contentSize = CGSizeMake(arrImgURL.count*SCREEN_WIDTH, 0);
    
    if (iCurNO > 1)
     {
        [scrolView setContentOffset:CGPointMake((iCurNO-1)*SCREEN_WIDTH,0) animated:YES];
     }
    
    // 加入底部的分享
    UIColor *color1 =  [UIColor whiteColor];
    
    int iIMGWdith = 50;
    int iViewWdith = SCREEN_WIDTH/3;
    iTopY += scrolView.height +  10;
    
    iLeftX = 0;
    
    // 保存到图片和按钮
    {
       UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(iLeftX, iTopY, iViewWdith, 100)];
       [self addSubview:view1];
       
       UIImageView *imag1 = [[UIImageView alloc] initWithFrame:CGRectMake((iViewWdith-iIMGWdith)/2, 20, iIMGWdith, iIMGWdith)];
       [view1 addSubview:imag1];
       imag1.image = [UIImage imageNamed:@"com_wedownload"];
       
       UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20+iIMGWdith, iViewWdith, 20)];
       label1.font = [UIFont systemFontOfSize:12];
       label1.textColor = color1;
       label1.text = @"保存此图片";
       label1.textAlignment = NSTextAlignmentCenter;
       [view1 addSubview:label1];
       
       UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionSave)];
       [view1 addGestureRecognizer:singleTap];
    }
    
    
    // 微信好友图片和按钮
    {
       UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(iLeftX + iViewWdith, iTopY, iViewWdith, 100)];
       [self addSubview:view1];
       
       UIImageView *imag1 = [[UIImageView alloc] initWithFrame:CGRectMake((iViewWdith-iIMGWdith)/2, 20, iIMGWdith, iIMGWdith)];
       [view1 addSubview:imag1];
       imag1.image = [UIImage imageNamed:@"com_wechat"];
       
       UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20+iIMGWdith, iViewWdith, 20)];
       label1.font = [UIFont systemFontOfSize:12];
       label1.textColor = color1;
       label1.text = @"微信好友";
       label1.textAlignment = NSTextAlignmentCenter;
       [view1 addSubview:label1];
       
       UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionWeChat)];
       [view1 addGestureRecognizer:singleTap];
    }
    
    // 微信好友图片和按钮
    {
       UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(iLeftX + 2*iViewWdith, iTopY, iViewWdith, 100)];
       [self addSubview:view1];
       
       UIImageView *imag1 = [[UIImageView alloc] initWithFrame:CGRectMake((iViewWdith-iIMGWdith)/2, 20, iIMGWdith, iIMGWdith)];
       [view1 addSubview:imag1];
       imag1.image = [UIImage imageNamed:@"com_wepyq"];
       
       UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20+iIMGWdith, iViewWdith, 20)];
       label1.font = [UIFont systemFontOfSize:12];
       label1.textColor = color1;
       label1.text = @"朋友圈";
       label1.textAlignment = NSTextAlignmentCenter;
       [view1 addSubview:label1];
       
       UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionWePYQ)];
       [view1 addGestureRecognizer:singleTap];
    }
    
    
}


// 得到商品的分享的图片 （仅仅只有二维码）
-(void) getShareQrcode
{

    NSString *strUrl = [NSString stringWithFormat:@"%@%@?signId=%@&goodsCode=%@", [PDAPI getBusiUrlString],kURLgetXcxQrcode, [CommonInfo signId],_shopModel.strGoodsCode];
    qrcodeUrl = strUrl;
    
    // 获取底部二维码图片
    imageEWM = [ToolsUtlis getImgFromStr:qrcodeUrl];
}


#pragma mark - scrollView的代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/self.bounds.size.width;
    iCurNO = (int)index+1;
    
    //self.indexLab.hidden = NO;
    //labelIndex.text = [NSString stringWithFormat:@"%d/%d",(int)index+1,(int)arrImgURL.count];
    
}

#pragma mark --- action
-(void) actionClose
{
    [self removeAllSubviews];
    [self removeFromSuperview];
    self.hidden = YES;
}

-(void) actionSaveAll
{
    [self getShareQrcode];
    
    iIMGSaveNo = (int)arrImg.count -1;
    for (int i =0 ; i <arrImg.count; i++)
     {
        UIView *imgView = (UIView*)arrImg[i];
        
        // 设置绘制图片的大小
        UIGraphicsBeginImageContextWithOptions(imgView.bounds.size, NO, 0.0);
        // 绘制图片
        [imgView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
     }
}



-(void)actionSave
{
    iIMGSaveNo = 0;
    UIImageView *imgView = (UIImageView*)arrImg[iCurNO -1];
    
    // 设置绘制图片的大小
    UIGraphicsBeginImageContextWithOptions(imgView.bounds.size, NO, 0.0);
    // 绘制图片
    [imgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

-(void) actionWeChat
{
    NSMutableDictionary *parmams = [[NSMutableDictionary alloc] init];
    parmams[@"strUrl"] = [NSString stringWithFormat:@"/pages/product/product?goodsCode=%@&goodsName=%@",_shopModel.strGoodsCode,_shopModel.strGoodsName];
    parmams[@"strImgUrl"] = _shopModel.strGoodsImgUrl;
    parmams[@"strDesc"] = _shopModel.strGoodsName;
    parmams[@"strName"] = _shopModel.strGoodsName;
    
    [[DDGShareManager shareManager] weChatShareXCX:parmams];
    
    [[DDGShareManager  shareManager] setBlock:^(id obj) {
        
        NSDictionary *dic = (NSDictionary *)obj;
        if ([[dic objectForKey:@"success"] boolValue]) {
            [MBProgressHUD showSuccessWithStatus:@"分享成功" toView:self];
        }else{
            [MBProgressHUD showErrorWithStatus:@"分享失败" toView:self];
        }
    }];
}


-(void) actionWePYQ
{
    
    UIImageView *imgView = (UIImageView*)arrImg[iCurNO -1];
    
    // 设置绘制图片的大小
    UIGraphicsBeginImageContextWithOptions(imgView.bounds.size, NO, 0.0);
    // 绘制图片
    [imgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *data=  UIImageJPEGRepresentation(image,0.5);
    
    
    NSMutableDictionary *parmams = [[NSMutableDictionary alloc] init];
    parmams[@"image"] = data;
    [[DDGShareManager shareManager] weChatShare:parmams shareScene:1];
    
    [[DDGShareManager  shareManager] setBlock:^(id obj) {
        
        NSDictionary *dic = (NSDictionary *)obj;
        if ([[dic objectForKey:@"success"] boolValue]) {
            [MBProgressHUD showSuccessWithStatus:@"分享成功" toView:self];
        }else{
            [MBProgressHUD showErrorWithStatus:@"分享失败" toView:self];
        }
    }];
}

//保存图片回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    if (error) {
        NSString *message = [NSString stringWithFormat:@"保存图片失败,失败原因：%@",error];
        [MBProgressHUD showErrorWithStatus:message toView:self];
    }else{
        if ( 0 == iIMGSaveNo)
         {
            [MBProgressHUD showSuccessWithStatus:@"图片已成功保存到相册" toView:self];
         }
        iIMGSaveNo--;
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
