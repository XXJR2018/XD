//
//  IdentifyAlertView.m
//  XXJR
//
//  Created by xxjr02 on 2017/11/1.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import "IdentifyAlertView.h"
#import "UIImageView+WebCache.h"

#define UIColorFromRGB11(rgbValue) \
[UIColor colorWithRed:((rgbValue >> 16) & 0xFF)/255.f \
green:((rgbValue >> 8) & 0xFF)/255.f \
blue:(rgbValue & 0xFF)/255.f \
alpha:1.0f]

static const CGFloat alertviewWidth = 300.0;
static const CGError alertviewHeight = 220.0;
static const CGFloat titleHeight = 50.0;
static const CGFloat imageviewWdith = 80;
static const CGFloat imageviewHeight = 30;
static const CGFloat midviewHeight = 115;
static const CGFloat buttonHeight = 35;


@interface IdentifyAlertView()

@property (strong,nonatomic)UIDynamicAnimator * animator;
@property (strong,nonatomic)UIView * alertview;
@property (strong,nonatomic)UIView * backgroundview;
@property (strong,nonatomic)NSString * title;
@property (strong,nonatomic)NSString * message;
@property (strong,nonatomic)NSString * imgUrl;
@property (strong,nonatomic)NSString * strTime;

@property (assign,nonatomic)long  longTime;

@property (strong,nonatomic)NSString * cancelButtonTitle;
@property (strong,nonatomic)NSString * okButtonTitle;
@property (strong,nonatomic)UIImage * image;
@property (strong,nonatomic)UIButton * buttonVesion;
@property (strong,nonatomic)UITextField *label1_text;
@property (strong,nonatomic)UIImageView * imageview;


@end


@implementation IdentifyAlertView

#pragma mark - Gesture
-(void)click:(UITapGestureRecognizer *)sender{
    // 屏蔽掉点击任何区域，消失
    //    CGPoint tapLocation = [sender locationInView:self.backgroundview];
    //    CGRect alertFrame = self.alertview.frame;
    //    if (!CGRectContainsPoint(alertFrame, tapLocation)) {
    //        [self dismiss];
    //    }
}

#pragma mark -  private function
-(UIButton *)createButtonWithFrame:(CGRect)frame Title:(NSString *)title
{
    UIButton * button = [[UIButton alloc] initWithFrame:frame];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.cornerRadius = 35/2;
    button.backgroundColor = [UIColor orangeColor];
    //button.layer.borderWidth = 0.5;
    //button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [button addTarget:self action:@selector(clickOKButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    return button;
}

// 创建灰色按钮
-(UIButton *)createButtonWithFrame2:(CGRect)frame Title:(NSString *)title
{
    UIButton * button = [[UIButton alloc] initWithFrame:frame];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.cornerRadius = 35/2;
    button.backgroundColor = UIColorFromRGB11(0xd3cdca);
    //button.layer.borderWidth = 0.5;
    //button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setShowsTouchWhenHighlighted:YES];
    return button;
}

#pragma mark ---- 验证图像码， 获取短信验证码
-(void)clickOKButton:(UIButton *)button{

    [MBProgressHUD showHUDAddedTo:self animated:NO];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"telephone"] = _strPhone? _strPhone:@"18688952105";
  
    _strTime = [NSString stringWithFormat:@"%ld_%@",_longTime , [DDGSetting sharedSettings].UUID_MD5];// 当前时间戳
    params[@"page"] = _strTime;
    params[@"imageCode"] = _label1_text.text;
    params[@"appkjType"] = @"1";
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString],_strRequestURL];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray success:^(DDGAFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self animated:NO];
        
        if (operation.jsonResult.success) {
            [self dismiss];
            NSLog(@"----验证码发送成功----");
            
            [[SDImageCache sharedImageCache]  removeImageForKey:_imgUrl];
                
                
            MBProgressHUD *hud  = [MBProgressHUD showSuccessWithStatus:operation.jsonResult.message toView:self.parentVC.view];
            hud.completionBlock = ^{};
        } else {
            NSLog(@"-------验证码发送失败----");
             [MBProgressHUD hideHUDForView:self animated:NO];
            [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self animated:NO];
        [MBProgressHUD showErrorWithStatus:[((DDGAFHTTPRequestOperation *)operation).errorDDG localizedDescription] toView:self];
    }];
    
    [operation start];
 
    
    //
}

-(void)clickButton:(UIButton *)button
{
    [[SDImageCache sharedImageCache]  removeImageForKey:_imgUrl];
    [self dismiss];
}
-(void)dismiss{
    [self.animator removeAllBehaviors];
    [UIView animateWithDuration:0.7 animations:^{
        //        self.alpha = 0.0;
        //        CGAffineTransform rotate = CGAffineTransformMakeRotation(0.9 * M_PI);
        //        CGAffineTransform scale = CGAffineTransformMakeScale(0.1, 0.1);
        //        self.alertview.transform = CGAffineTransformConcat(rotate, scale);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.alertview = nil;
    }];
    
}




-(void)setUp{
    self.backgroundview = [[UIView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    self.backgroundview.backgroundColor = [UIColor blackColor];
    self.backgroundview.alpha = 0.4;
    [self addSubview:self.backgroundview];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
    [self.backgroundview addGestureRecognizer:tap];
    
    
    self.alertview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, alertviewWidth, alertviewHeight)];
    self.alertview.layer.cornerRadius = 5;
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    //self.alertview.center = CGPointMake(CGRectGetMidX(keywindow.frame), -CGRectGetMidY(keywindow.frame)-200);
    self.alertview.center = CGPointMake(CGRectGetMidX(keywindow.frame), -CGRectGetMidY(keywindow.frame));
    self.alertview.backgroundColor = [UIColor whiteColor];
    self.alertview.clipsToBounds = YES;
    
    [self addSubview:self.alertview];
    
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,alertviewWidth,titleHeight)];
    titleLabel.text = self.title;
    titleLabel.backgroundColor = [ResourceManager viewBackgroundColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [ResourceManager navgationTitleColor];
    [self.alertview addSubview:titleLabel];
    
    
    float  fLeftX = 70;
    float  fTopY =  titleHeight +20;
    _imageview = [[UIImageView alloc] initWithFrame:CGRectMake(fLeftX,fTopY, imageviewWdith,imageviewHeight)];
    
    NSDate *senddate = [NSDate date];
    //_strTime = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];// 当前时间戳
    _longTime = (long)[senddate timeIntervalSince1970];
    _strTime = [NSString stringWithFormat:@"%ld_%@",_longTime , [DDGSetting sharedSettings].UUID_MD5];// 当前时间戳
    _imgUrl = [NSString stringWithFormat:@"%@%@?page=%@", [PDAPI getBaseUrlString], @"appMall/smsAction/tgImageCode",_strTime];
    [_imageview sd_setImageWithURL:[NSURL URLWithString:_imgUrl] placeholderImage:[UIImage imageNamed:@"tab4_ddsx"]];
    [self.alertview addSubview:_imageview];
    
    
    UIButton * buttonSX = [[UIButton alloc] initWithFrame:CGRectMake(fLeftX + imageviewWdith + 5, fTopY+5, 80, 30)];
    //设置button正常状态下的图片
//    [buttonSX setImage:[UIImage imageNamed:@"tab4_gengxin"] forState:UIControlStateNormal];
    //button图片的偏移量，距上左下右分别(10, 10, 10, 60)像素点
    buttonSX.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [buttonSX setTitle:@"换一张" forState:UIControlStateNormal];
    [buttonSX setTitleColor:UIColorFromRGB11(0x5180bf) forState:UIControlStateNormal];
    buttonSX.titleLabel.font = [UIFont systemFontOfSize:11];
    buttonSX.titleLabel.textAlignment = NSTextAlignmentCenter;
    buttonSX.backgroundColor = [UIColor clearColor];
    [buttonSX addTarget:self action:@selector(actionSX) forControlEvents:UIControlEventTouchUpInside];
    [self.alertview addSubview:buttonSX];
    
    fTopY += 50;
    fLeftX = 30;
    _label1_text = [[UITextField alloc] initWithFrame:CGRectMake(fLeftX, fTopY, alertviewWidth - 2*fLeftX, 30)];
    _label1_text.placeholder = @"  请输入图形中的验证码";
    _label1_text.font = [UIFont systemFontOfSize:14];

    
    //设置边框的颜色
    _label1_text.layer.borderColor = [ResourceManager lightGrayColor].CGColor;
    //设置边框的粗细
    _label1_text.layer.borderWidth = 1;
    //  设置_label1_text为“有焦点状态”
    [_label1_text becomeFirstResponder];
    [self.alertview addSubview:_label1_text];
    
     
    
    CGRect cancelButtonFrame = CGRectMake(0, titleHeight + midviewHeight,alertviewWidth,buttonHeight);
    if (self.okButtonTitle.length != 0 && self.okButtonTitle !=nil) {
        cancelButtonFrame = CGRectMake(alertviewWidth / 2 +10 ,titleHeight + midviewHeight+5, alertviewWidth/2-40,buttonHeight);
        CGRect okButtonFrame = CGRectMake(30,titleHeight + midviewHeight+5, alertviewWidth/2 -40 ,buttonHeight);
        UIButton * okButton = [self createButtonWithFrame2:okButtonFrame Title:self.okButtonTitle];
        okButton.tag = 2;
        [self.alertview addSubview:okButton];
        
    }
    UIButton * cancelButton = [self createButtonWithFrame:cancelButtonFrame Title:self.cancelButtonTitle];
    cancelButton.tag = 1;
    [self.alertview addSubview:cancelButton];
    
//    [[SDImageCache sharedImageCache]  removeImageForKey:key withCompletion:(SDWebImageNoParamsBlock)completion {
//        
//    }];
    
    

}

-(void) actionSX
{
    [[SDImageCache sharedImageCache]  removeImageForKey:_imgUrl withCompletion:^{
        NSLog(@"清除 %@ 图片缓存成功", _imgUrl);
        
        NSDate *senddate = [NSDate date];
        _longTime = (long)[senddate timeIntervalSince1970];
        _strTime = [NSString stringWithFormat:@"%ld_%@", _longTime, [DDGSetting sharedSettings].UUID_MD5];// 当前时间戳
        _imgUrl = [NSString stringWithFormat:@"%@%@?page=%@", [PDAPI getBaseUrlString], @"xxcust/smsAction/imageCode",_strTime];
        
        [_imageview sd_setImageWithURL:[NSURL URLWithString:_imgUrl] placeholderImage:[UIImage imageNamed:@"tab4_ddsx"]];
        
    }];
    
}


#pragma mark -  API
- (void)show {
    
    UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    
    
    CGPoint setCenter = self.center;
    setCenter.y -=150; // 修改弹出框的位置
    UISnapBehavior * sanp = [[UISnapBehavior alloc] initWithItem:self.alertview snapToPoint:setCenter];
    
    
    sanp.damping = 0.5;
    [self.animator addBehavior:sanp];
    
}


-(instancetype)initWithTitle:(NSString *) title
                CancelButton:(NSString *)cancelButton
                    OkButton:(NSString *)okButton{
    if (self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame]) {
        self.title = title;
        self.cancelButtonTitle = cancelButton;
        self.okButtonTitle = okButton;
        
        [self setUp];
    }
    return self;
}


@end
