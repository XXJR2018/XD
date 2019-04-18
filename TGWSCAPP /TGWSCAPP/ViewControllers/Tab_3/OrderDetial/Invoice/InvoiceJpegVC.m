//
//  InvoiceJpegVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/2/13.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "InvoiceJpegVC.h"
#import <Photos/Photos.h>
@interface InvoiceJpegVC ()

@end

@implementation InvoiceJpegVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutNaviBarViewWithTitle:@"发票"];
    
    [self layoutUI];
}

-(void)layoutUI{
    UIScrollView *scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight )];
    [self.view addSubview:scView];
    scView.backgroundColor = [UIColor whiteColor];
    scView.bounces = NO;
    scView.pagingEnabled = NO;
    scView.showsVerticalScrollIndicator = NO;
    
    CGFloat _currentHeight = 0;
    //3.分隔字符串
    NSArray *imgArr = [self.invoiceImgUrl componentsSeparatedByString:@","]; //从字符A中分隔成多个元素的数组
    for (int i = 0; i < imgArr.count; i++) {
        NSString *imgUrl = imgArr[i];
        UIImageView *invoiceImgView = [[UIImageView alloc]init];
        [scView addSubview:invoiceImgView];
        invoiceImgView.backgroundColor = [UIColor whiteColor];
        [invoiceImgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
        UIImage *image = [UIImage imageWithData:data];
        invoiceImgView.frame =CGRectMake( 20, _currentHeight + 10, SCREEN_WIDTH - 40, image.size.height/image.size.width * (SCREEN_WIDTH - 40));
        _currentHeight = CGRectGetMaxY(invoiceImgView.frame);
    }
    
    UIButton *saveImgBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, _currentHeight + 20, SCREEN_WIDTH - 80, 50)];
    [scView addSubview:saveImgBtn];
    saveImgBtn.backgroundColor = UIColorFromRGB(0xCFA971);
    saveImgBtn.layer.cornerRadius = 50/2;
    saveImgBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [saveImgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveImgBtn setTitle:@"保存图片" forState:UIControlStateNormal];
    [saveImgBtn addTarget:self action:@selector(saveImg) forControlEvents:UIControlEventTouchUpInside];
    
    _currentHeight = CGRectGetMaxY(saveImgBtn.frame) + 20;
    scView.contentSize = CGSizeMake(0, _currentHeight);
}

#pragma mark======保存图片到系统相册
-(void)saveImg{
    NSArray *imgArr = [self.invoiceImgUrl componentsSeparatedByString:@","]; //从字符A中分隔成多个元素的数组
    for (NSString *imgStr in imgArr) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgStr]];
        UIImage *image = [UIImage imageWithData:data];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    }
    
}

//保存图片回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
    if (error) {
        NSString *message = [NSString stringWithFormat:@"保存图片失败,失败原因：%@",error];
        [MBProgressHUD showErrorWithStatus:message toView:self.view];
    }else{
        [MBProgressHUD showSuccessWithStatus:@"图片已成功保存到相册" toView:self.view];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
