//
//  ShowBannerJpegView.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/2/28.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "ShowBannerJpegView.h"
#import "ShareShopJpegView.h"


@interface ShowBannerJpegView ()<UIScrollViewDelegate>
{
    UIScrollView * scrolView;
    UILabel  *labelIndex;
    
    NSArray *arrImgURL;
    NSMutableArray *arrImg;
    int iCurNO;
}


@end


@implementation ShowBannerJpegView




-(ShowBannerJpegView*) initWithArrImg:(NSArray *)arr   withNo:(int) iNo
{
    self =  [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    arrImgURL = arr;
    
    iCurNO = iNo;
    
    arrImg = [[NSMutableArray alloc] init];
    
    _shopModel = [[ShopModel alloc] init];
    
    [self drawUI];
    
    return self;
}

-(void) drawUI
{
    self.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:0.9];
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionClose)];
    gesture.numberOfTapsRequired  = 1;
    [self addGestureRecognizer:gesture];
    
    labelIndex = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 20)];
    [self addSubview:labelIndex];
    labelIndex.textColor = [UIColor whiteColor];
    labelIndex.font = [UIFont systemFontOfSize:14];
    labelIndex.textAlignment = NSTextAlignmentCenter;
    
    scrolView = [[UIScrollView alloc]init];
    scrolView.pagingEnabled  = YES;
    scrolView.delegate = self;
    scrolView.showsVerticalScrollIndicator = NO;
    scrolView.showsHorizontalScrollIndicator = NO;
    scrolView.userInteractionEnabled = YES;
    
    scrolView.alwaysBounceVertical = NO;
    scrolView.alwaysBounceHorizontal = NO;
    
    [self addSubview:scrolView];
    scrolView.frame = CGRectMake(0, 130, SCREEN_WIDTH, SCREEN_WIDTH);
    scrolView.backgroundColor = [UIColor whiteColor];
    
    
    for (int i = 0; i < arrImgURL.count; i ++)
     {
        
        UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
        
        //int iBetwwen = 20;
        //UIImageView * img = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH + iBetwwen, 0, SCREEN_WIDTH - 2*iBetwwen, SCREEN_WIDTH - 2*iBetwwen)];
        
        img.userInteractionEnabled = YES;
        
        [img sd_setImageWithURL:[NSURL URLWithString:arrImgURL[i]] ];
        
        [arrImg addObject:img];
        
        [scrolView addSubview:img];
     }
    
    scrolView.contentSize = CGSizeMake(arrImgURL.count*SCREEN_WIDTH, 0);
    
    labelIndex.text = [NSString stringWithFormat:@"%d/%d",(int)iCurNO,(int)arrImgURL.count];
    
    if (iCurNO > 1)
     {
        [scrolView setContentOffset:CGPointMake((iCurNO-1)*SCREEN_WIDTH,0) animated:YES];
     }
    
    
    // 布局底部图片
    UIButton *btnBottom = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/2 - 100)/2, SCREEN_HEIGHT - 50, 100, 50)];
    [self addSubview:btnBottom];
    [btnBottom setTitle:@"  保存图片" forState:UIControlStateNormal];
    btnBottom.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnBottom setImage:[UIImage imageNamed:@"com_download"] forState:UIControlStateNormal];
    [btnBottom addTarget:self action:@selector(actionSave) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btnBottomR = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+ (SCREEN_WIDTH/2 - 150)/2, SCREEN_HEIGHT - 50, 150, 50)];
    [self addSubview:btnBottomR];
    [btnBottomR setTitle:@"  生成商品二维码" forState:UIControlStateNormal];
    btnBottomR.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnBottomR setImage:[UIImage imageNamed:@"com_ewm"] forState:UIControlStateNormal];
    [btnBottomR addTarget:self action:@selector(actionEWM) forControlEvents:UIControlEventTouchUpInside];
    
    
}


#pragma mark - scrollView的代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/self.bounds.size.width;
    iCurNO = (int)index+1;
    
    //self.indexLab.hidden = NO;
    labelIndex.text = [NSString stringWithFormat:@"%d/%d",(int)index+1,(int)arrImgURL.count];
    
}

#pragma mark  ---  action
-(void) actionClose
{
    [self removeAllSubviews];
    [self removeFromSuperview];
    self.hidden = YES;
}


-(void)actionEWM
{
    // 纯图片的处理方式
    ShareShopJpegView  *View = [[ShareShopJpegView alloc] initWithArrImg:arrImgURL  withNo:(int)iCurNO withShopModel:_shopModel];
    [self addSubview:View];
}


-(void)actionSave
{
    UIImageView *imgView = (UIImageView*)arrImg[iCurNO -1];
    UIImage *image = imgView.image;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}


//保存图片回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    if (error) {
        NSString *message = [NSString stringWithFormat:@"保存图片失败,失败原因：%@",error];
        [MBProgressHUD showErrorWithStatus:message toView:self];
    }else{
        [MBProgressHUD showSuccessWithStatus:@"图片已成功保存到相册" toView:self];
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
