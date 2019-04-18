//
//  IssueAppraiseViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/14.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "IssueAppraiseViewController.h"

#import "AppraiseSuccessViewController.h"
#import "XHStarRateView.h"

@interface IssueAppraiseViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITextView *_textView;
    UIView *_updataView;
    NSMutableArray *_updataImgArr;
    
    
    UIButton *_anonymityBtn;
}
@property(nonatomic, strong) UILabel *msxfStateLabel;

@property(nonatomic, strong) UILabel *wlfwStateLabel;

@property(nonatomic, strong) UILabel *fwtdStateLabel;

@property(nonatomic, assign) NSInteger msxfStar;

@property(nonatomic, assign) NSInteger wlfwStar;

@property(nonatomic, assign) NSInteger fwtdStar;

@end

@implementation IssueAppraiseViewController

-(void)IssueAppraiseUrl{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"subOrderNo"] = [self.orderDataDic objectForKey:@"subOrderNo"];
    params[@"goodsCode"] = [self.orderDataDic objectForKey:@"goodsCode"];
    params[@"goodsGrade"] = @(_msxfStar);
    params[@"logisticsGrade"] = @(_wlfwStar);
    params[@"serveGrade"] = @(_fwtdStar);
    params[@"isHide"] = @"0";
    if (_anonymityBtn.selected) {
        params[@"isHide"] = @"1";
    }
    if (![_textView.text isEqualToString:@"宝贝满足你的期许吗？说说它的优点和美中不足的地方吧...评论超10个字可送10积分，上传图片可再送5积分哦~"]) {
        params[@"commentText"] = _textView.text;
    }
    
    if (_updataImgArr.count > 0) {
        NSMutableString *imgUrl = [NSMutableString string];
        if (_updataImgArr.count == 1) {
            [imgUrl appendString:_updataImgArr[0]];
        }else{
            NSInteger count = 0;
            for (NSString *str in _updataImgArr) {
                count ++;
                [imgUrl appendString:str];
                if (count < _updataImgArr.count) {
                    [imgUrl appendString:@","];
                }
            }
        }
        params[@"imgUrl"] = imgUrl;
    }
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/orderComment/addComment",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
}

#pragma mark 数据操作
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    AppraiseSuccessViewController *ctl = [[AppraiseSuccessViewController alloc]init];
    ctl.appraiseDataDic = operation.jsonResult.attr;
    [self.navigationController pushViewController:ctl animated:YES];
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"发布评价"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"发布评价"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CustomNavigationBarView *naviView = [self layoutNaviBarViewWithTitle:@"评价"];
    UIButton *issueBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 60,NavHeight - 35, 60, 35)];
    [naviView addSubview:issueBtn];
    [issueBtn setTitle:@"发布" forState:UIControlStateNormal];
    issueBtn .titleLabel.font = [UIFont systemFontOfSize:14];
    [issueBtn setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    [issueBtn addTarget:self action:@selector(IssueAppraise) forControlEvents:UIControlEventTouchUpInside];
    _updataImgArr = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutUI];
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TouchViewKeyBoard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
}

-(void)TouchViewKeyBoard{
    [self.view endEditing:YES];
}

#pragma mark ---  发布评论
-(void)IssueAppraise{
    [self.view endEditing:YES];
    if (_wlfwStar == 0) {
        [MBProgressHUD showErrorWithStatus:@"请评价物流服务" toView:self.view];
        return;
    } if (_fwtdStar == 0) {
        [MBProgressHUD showErrorWithStatus:@"请评价服务态度" toView:self.view];
        return;
    }
    
    [self IssueAppraiseUrl];
}

-(void)layoutUI{
    
    UIColor *color_1 = [ResourceManager color_1];
    UIColor *color_2 = [ResourceManager color_6];
    UIFont *font_1 = [UIFont systemFontOfSize:14];
    UIFont *font_2 = [UIFont systemFontOfSize:13];
    
    UIImageView *iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, NavHeight + 10, 45, 45)];
    [self.view addSubview:iconImgView];
    [iconImgView sd_setImageWithURL:[NSURL URLWithString:[self.orderDataDic objectForKey:@"goodsUrl"]]];
    
    UILabel *msxfLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconImgView.frame) + 10, CGRectGetMidY(iconImgView.frame) - 10, 65, 20)];
    [self.view addSubview:msxfLabel];
    msxfLabel.font = font_1;
    msxfLabel.textColor = color_1;
    msxfLabel.text = @"描述相符";
    
    XHStarRateView *msStarRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(msxfLabel.frame), CGRectGetMidY(iconImgView.frame) - 8, 140, 16) finish:^(CGFloat currentScore) {
         [self.view endEditing:YES];
        self.msxfStar = (NSInteger)currentScore;
        NSArray *starArr = @[@"非常差",@"差",@"一般",@"好",@"非常好"];
        self.msxfStateLabel.text = starArr[self.msxfStar - 1];
    }];
    [self.view addSubview:msStarRateView];
    
    msStarRateView.currentScore = 5;
    self.msxfStar = 5;
    
    _msxfStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(msStarRateView.frame) + 15, CGRectGetMidY(iconImgView.frame) - 10, 65, 20)];
    [self.view addSubview:_msxfStateLabel];
    _msxfStateLabel.font = font_1;
    _msxfStateLabel.textColor = color_2;
    _msxfStateLabel.text = @"非常好";
 
    UIView *lineView_1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImgView.frame) + 10, SCREEN_WIDTH, 0.5)];
    [self.view addSubview:lineView_1];
    lineView_1.backgroundColor = [ResourceManager color_5];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView_1.frame) + 10, SCREEN_WIDTH - 20, 120)];
    [self.view addSubview:_textView];
    _textView.delegate = self;
    _textView.font = font_2;
    _textView.textColor = color_2;
    _textView.text = @"宝贝满足你的期许吗？说说它的优点和美中不足的地方吧...评论超10个字可送10积分，上传图片可再送5积分哦~";
    
    CGFloat imgWidth = (SCREEN_WIDTH - 10 * 6)/5;
    
    _updataView =  [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_textView.frame) + 10, SCREEN_WIDTH, imgWidth)];
    [self.view addSubview:_updataView];
    _updataView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < 1; i++) {
        UIImageView *updataImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, imgWidth, imgWidth)];
        [_updataView addSubview:updataImgView];
        updataImgView.layer.borderWidth = 0.5;
        updataImgView.layer.borderColor = [ResourceManager color_5].CGColor;
        updataImgView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *updataTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(updateImg)];
        updataTap.numberOfTapsRequired = 1;
        [updataImgView addGestureRecognizer:updataTap];
        
        UIImageView *cameraImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(updataImgView.frame) - 10 - 23/2, CGRectGetMidY(updataImgView.frame) - 16/2 - 8, 23, 16)];
        [updataImgView addSubview:cameraImgView];
        cameraImgView.image = [UIImage imageNamed:@"Tab_4-38"];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(cameraImgView.frame) +5, imgWidth, 20)];
        [updataImgView addSubview:titleLabel];
        titleLabel.font = [UIFont systemFontOfSize:11];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = color_2;
        titleLabel.text = @"添加图片";
    }
    
    UIView *lineView_2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_updataView.frame) + 20, SCREEN_WIDTH, 0.5)];
    [self.view addSubview:lineView_2];
    lineView_2.backgroundColor = [ResourceManager color_5];
    
    _anonymityBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView_2.frame) + (45 - 17)/2, 17, 17)];
    [self.view addSubview:_anonymityBtn];
    [_anonymityBtn setImage:[UIImage imageNamed:@"Tab_4-28"] forState:UIControlStateNormal];
    [_anonymityBtn setImage:[UIImage imageNamed:@"Tab_4-29"] forState:UIControlStateSelected];
    [_anonymityBtn addTarget:self action:@selector(anonymity:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *anonymityLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_anonymityBtn.frame) + 8, CGRectGetMaxY(lineView_2.frame), 200, 45)];
    [self.view addSubview:anonymityLabel];
    anonymityLabel.font = font_1;
    anonymityLabel.textColor = color_1;
    anonymityLabel.text = @"匿名";
    
    UILabel *anonymityTSLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 210, CGRectGetMaxY(lineView_2.frame), 200, 45)];
    [self.view addSubview:anonymityTSLabel];
    anonymityTSLabel.font = [UIFont systemFontOfSize:12];
    anonymityTSLabel.textAlignment = NSTextAlignmentRight;
    anonymityTSLabel.textColor = color_2;
    anonymityTSLabel.text = @"你的评价能帮助其他小伙伴呦~";
    
    UIView *lineView_3 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(anonymityLabel.frame), SCREEN_WIDTH, 10)];
    [self.view addSubview:lineView_3];
    lineView_3.backgroundColor = [ResourceManager viewBackgroundColor];
    
    UILabel *wlfwLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView_3.frame) + 25, 65, 20)];
    [self.view addSubview:wlfwLabel];
    wlfwLabel.font = font_1;
    wlfwLabel.textColor = color_1;
    wlfwLabel.text = @"物流服务";
    
    XHStarRateView *wlStarRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(wlfwLabel.frame), CGRectGetMidY(wlfwLabel.frame) - 8, 140, 16) finish:^(CGFloat currentScore) {
         [self.view endEditing:YES];
        self.wlfwStar = (NSInteger)currentScore;
        NSArray *starArr = @[@"非常差",@"差",@"一般",@"好",@"非常好"];
        self.wlfwStateLabel.text = starArr[self.wlfwStar - 1];
    }];
    [self.view addSubview:wlStarRateView];
    
    _wlfwStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(wlStarRateView.frame) + 15, CGRectGetMidY(wlfwLabel.frame) - 10, 65, 20)];
    [self.view addSubview:_wlfwStateLabel];
    _wlfwStateLabel.font = font_1;
    _wlfwStateLabel.textColor = color_2;
    
    UILabel *fwtdLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(wlfwLabel.frame) + 25, 65, 20)];
    [self.view addSubview:fwtdLabel];
    fwtdLabel.font = font_1;
    fwtdLabel.textColor = color_1;
    fwtdLabel.text = @"服务态度";
    
    XHStarRateView *fwStarRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(fwtdLabel.frame), CGRectGetMidY(fwtdLabel.frame) - 8, 140, 16) finish:^(CGFloat currentScore) {
         [self.view endEditing:YES];
        self.fwtdStar = (NSInteger)currentScore;
        NSArray *starArr = @[@"非常差",@"差",@"一般",@"好",@"非常好"];
        self.fwtdStateLabel.text = starArr[self.fwtdStar - 1];
    }];
    [self.view addSubview:fwStarRateView];
    
    _fwtdStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(fwStarRateView.frame) + 15, CGRectGetMidY(fwtdLabel.frame) - 10, 65, 20)];
    [self.view addSubview:_fwtdStateLabel];
    _fwtdStateLabel.font = font_1;
    _fwtdStateLabel.textColor = color_2;
}

//匿名
-(void)anonymity:(UIButton *)sender{
     [self.view endEditing:YES];
    sender.selected = !sender.selected;
}

#pragma  mark-- 改变上传图片控件布局
-(void)changeUpdateImgViewUI{
    [_updataView removeAllSubviews];
    
    CGFloat imgWidth = (SCREEN_WIDTH - 10 * 6)/5;
    if (_updataImgArr.count == 0) {
        UIImageView *updataImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, imgWidth, imgWidth)];
        [_updataView addSubview:updataImgView];
        updataImgView.layer.borderWidth = 0.5;
        updataImgView.layer.borderColor = [ResourceManager color_5].CGColor;
        updataImgView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *updataTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(updateImg)];
        updataTap.numberOfTapsRequired = 1;
        [updataImgView addGestureRecognizer:updataTap];
        
        UIImageView *cameraImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMidX(updataImgView.frame) - 10 - 23/2, CGRectGetMidY(updataImgView.frame) - 16/2 - 8, 23, 16)];
        [updataImgView addSubview:cameraImgView];
        cameraImgView.image = [UIImage imageNamed:@"Tab_4-38"];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(cameraImgView.frame) +5, imgWidth, 20)];
        [updataImgView addSubview:titleLabel];
        titleLabel.font = [UIFont systemFontOfSize:11];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [ResourceManager color_6];
        titleLabel.text = @"添加图片";
    }else{
        NSInteger count = 0;
        if (_updataImgArr.count < 5) {
            count = _updataImgArr.count + 1;
        }else{
            count = 5;
        }
        for (int i = 0; i < count; i++) {
            UIImageView *updataImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + (imgWidth + 10) * i, 0, imgWidth, imgWidth)];
            [_updataView addSubview:updataImgView];
            updataImgView.layer.borderWidth = 0.5;
            updataImgView.layer.borderColor = [ResourceManager color_5].CGColor;
            if (_updataImgArr.count == 5) {
                [updataImgView sd_setImageWithURL:[NSURL URLWithString:_updataImgArr[i]]];
                UIButton *deleteImgBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(updataImgView.frame) - 15, -15, 30, 30)];
                [_updataView addSubview:deleteImgBtn];
                deleteImgBtn.tag = i;
                [deleteImgBtn setImage:[UIImage imageNamed:@"Tab_4-39"] forState:UIControlStateNormal];
                [deleteImgBtn addTarget:self action:@selector(deleteImg:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                if (i < _updataImgArr.count) {
                    [updataImgView sd_setImageWithURL:[NSURL URLWithString:_updataImgArr[i]]];
                    UIButton *deleteImgBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(updataImgView.frame) - 15, -15, 30, 30)];
                    [_updataView addSubview:deleteImgBtn];
                    deleteImgBtn.tag = i;
                    [deleteImgBtn setImage:[UIImage imageNamed:@"Tab_4-39"] forState:UIControlStateNormal];
                    [deleteImgBtn addTarget:self action:@selector(deleteImg:) forControlEvents:UIControlEventTouchUpInside];
                    
                }else if (i == _updataImgArr.count) {
                    updataImgView.userInteractionEnabled = YES;
                    UITapGestureRecognizer *updataTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(updateImg)];
                    updataTap.numberOfTapsRequired = 1;
                    [updataImgView addGestureRecognizer:updataTap];
                    
                    UIImageView *cameraImgView = [[UIImageView alloc]initWithFrame:CGRectMake((imgWidth - 23)/2, CGRectGetMidY(updataImgView.frame) - 16/2 - 8, 23, 16)];
                    [updataImgView addSubview:cameraImgView];
                    cameraImgView.image = [UIImage imageNamed:@"Tab_4-38"];
                    
                    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(cameraImgView.frame) +5, imgWidth, 20)];
                    [updataImgView addSubview:titleLabel];
                    titleLabel.font = [UIFont systemFontOfSize:11];
                    titleLabel.textAlignment = NSTextAlignmentCenter;
                    titleLabel.textColor = [ResourceManager color_6];
                    if (i == 1) {
                        titleLabel.text = @"1/5";
                    }else if (i == 2) {
                        titleLabel.text = @"2/5";
                    }else if (i == 3) {
                        titleLabel.text = @"3/5";
                    }else if (i == 4) {
                        titleLabel.text = @"4/5";
                    }
                }
            }
            
        }
    }
    
}

#pragma  mark-- 上传图片
-(void)updateImg{
    [self.view endEditing:YES];
    [self uploadImg];
}

-(void)deleteImg:(UIButton *)sender {
    [self.view endEditing:YES];
    [_updataImgArr removeObjectAtIndex:sender.tag];
    [self changeUpdateImgViewUI];
}

#pragma mark--  上传图片
-(void)uploadImg{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            return;
        }
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.delegate = self;
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        pickerController.allowsEditing = YES;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            pickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:
                                           UIImagePickerControllerSourceTypeCamera];
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        [self.navigationController presentViewController:pickerController animated:YES completion:nil];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            return;
        }
        UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
        pickerController.editing=YES;
        pickerController.delegate=self;
        pickerController.allowsEditing=YES;
        pickerController.navigationBar.translucent=NO;   //去除毛玻璃效果
        pickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        pickerController.navigationBar.tintColor = [ResourceManager mainColor];
        [self.navigationController presentViewController:pickerController animated:YES completion:nil];
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    //把action添加到actionSheet里
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];
    
    //相当于之前的[actionSheet show];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark -
#pragma mark UINavigationControllerDelegate
/**
 *  解决取消按钮点击不灵敏问题
 */
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([UIDevice currentDevice].systemVersion.floatValue < 11){
        return;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")]){
        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop){
            // iOS 11之后，图片编辑界面最上层会出现一个宽度<42的view，会遮盖住左下方的cancel按钮，使cancel按钮很难被点击到，故改变该view的层级结构
            if (obj.frame.size.width < 42){
                [viewController.view sendSubviewToBack:obj];
                *stop = YES;
            }
        }];
    }
}
#pragma mark -
#pragma mark UIImagePickerViewControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
#define dataSize 1024.0f
#define imageSize CGSizeMake(600.0f, 600.0f)
    //先把原图保存到图片库
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageWriteToSavedPhotosAlbum(originalImage, nil, nil, nil);
    }
    //获取用户选取的图片并转换成NSData
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //缩小图片的size
    image = [self imageByRedraw:image];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    if (imageData){
        self.imageData = imageData;
        // 上传
        [self upLoadImgData];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
/**
 *  截图
 *  @return UIImage
 */
- (UIImage *)imageByRedraw:(UIImage *)image
{
    if (image.size.width == image.size.height)
    {
        UIGraphicsBeginImageContext(imageSize);
        CGRect rect = CGRectZero;
        rect.size = imageSize;
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
        CGContextFillRect(ctx, rect);
        [image drawInRect:rect];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }else{
        CGFloat ratio = image.size.width / image.size.height;
        CGSize size = CGSizeZero;
        
        if (image.size.width > imageSize.width)
        {
            size.width = imageSize.width;
            size.height = size.width / ratio;
        }
        else if (image.size.height > imageSize.height)
        {
            size.height = imageSize.height;
            size.width = size.height * ratio;
        }
        else
        {
            size.width = image.size.width;
            size.height = image.size.height;
        }
        //这里的size是最终获取到的图片的大小
        UIGraphicsBeginImageContext(imageSize);
        CGRect rect = CGRectZero;
        rect.size = imageSize;
        //先填充整个图片区域的颜色为黑色
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(ctx, [UIColor blackColor].CGColor);
        CGContextFillRect(ctx, rect);
        rect.origin = CGPointMake((imageSize.width - size.width)/2, (imageSize.height - size.height)/2);
        rect.size = size;
        //画图
        [image drawInRect:rect];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return image;
}

-(void)upLoadImgData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fileType"] = @"goodsCommImg";
    params[@"signId"] = [CommonInfo signId];
    params[kUUID] = [DDGSetting sharedSettings].UUID_MD5;
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    NSString *versionStr = [NSString stringWithFormat:@"tgwscIOS-%@",currentVersion];
    params[@"appVersion"] = versionStr;
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestManager POST:[PDAPI getSendFileAPI] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:self.imageData name:@"img" fileName:@"head.jpg" mimeType:@"image/jpg"];
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        int iSuccess = [[(NSDictionary *)json objectForKey:@"success"] intValue];
        if (iSuccess != 0) {
            [MBProgressHUD showSuccessWithStatus:@"上传成功" toView:self.view];
            [DDGSetting sharedSettings].accountNeedRefresh = YES;
            NSDictionary *dic = [(NSDictionary *)json objectForKey:@"attr"];
            NSString *imgUrlStr = [dic objectForKey:@"url"];
            
            //将上传图片加入到图片数组里面
            [_updataImgArr addObject:imgUrlStr];
            [self changeUpdateImgViewUI];
        }else{
            [MBProgressHUD showErrorWithStatus:[(NSDictionary *)json objectForKey:@"message"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showErrorWithStatus:[operation.error localizedDescription] toView:self.view];
        //清空数据，防止覆盖下次数据
        self.imageData = [NSData new];
    }];
}

#pragma mark---- UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"宝贝满足你的期许吗？说说它的优点和美中不足的地方吧...评论超10个字可送10积分，上传图片可再送5积分哦~"]) {
        textView.text = nil;
        textView.textColor = [ResourceManager color_1];
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        textView.text = @"宝贝满足你的期许吗？说说它的优点和美中不足的地方吧...评论超10个字可送10积分，上传图片可再送5积分哦~";
        textView.textColor = [ResourceManager color_6];
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
