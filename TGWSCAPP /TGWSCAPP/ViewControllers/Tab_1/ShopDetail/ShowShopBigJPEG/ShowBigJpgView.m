//
//  ShowBigJpgView.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/2/28.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "ShowBigJpgView.h"

@implementation ShowBigJpgView
{
    float fImgHeight;
    NSString *strImgUrl;
    UIImageView *imgView;
    
    UIScrollView *scView;
}

-(ShowBigJpgView*) initWithImgUrl:(NSString *)imgUrl   height:(float) fHeight
{
    self =  [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    fImgHeight = fHeight;
    
    strImgUrl = imgUrl;
    
    [self drawUI];
    
    return self;
}

-(void) drawUI
{
    self.backgroundColor =  [[UIColor blackColor] colorWithAlphaComponent:1.0];
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(actionClose)];
    gesture.numberOfTapsRequired  = 1;
    [self addGestureRecognizer:gesture];
    
    
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50 )];
    [self addSubview:scView];
    scView.contentSize = CGSizeMake(0, fImgHeight);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [UIColor blackColor];//[ResourceManager viewBackgroundColor];
    
    int iTop = 0;
    if (fImgHeight < SCREEN_HEIGHT-50)
     {
        iTop = (SCREEN_HEIGHT - fImgHeight)/2;
     }
    
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, iTop, SCREEN_WIDTH, fImgHeight)];
    [scView addSubview:imgView];
    [imgView sd_setImageWithURL:[NSURL URLWithString:strImgUrl]];
    
    UIButton *btnBottom = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100)/2, SCREEN_HEIGHT - 50, 100, 50)];
    [self addSubview:btnBottom];
    [btnBottom setTitle:@"  保存图片" forState:UIControlStateNormal];
    btnBottom.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnBottom setImage:[UIImage imageNamed:@"com_download"] forState:UIControlStateNormal];
    [btnBottom addTarget:self action:@selector(actionSave) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark ---  action
-(void) actionClose
{
    [self removeAllSubviews];
    [self removeFromSuperview];
    self.hidden = YES;

}

#pragma mark======保存图片到系统相册
-(void)actionSave
{
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

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}


@end
