//
//  RefundReCommitVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/15.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "RefundReCommitVC.h"
#import "PickerView.h"

#define   orderCellHeight    120

@interface RefundReCommitVC ()<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIScrollView  *scView;
    
    UIImageView *img1;       //  图片1
    NSString    *strImgUrl1;
    UIImageView *img2;       //  图片2
    NSString    *strImgUrl2;
    UIImageView *img3;       //  图片3
    NSString    *strImgUrl3;
    int  iSelImg;    // 1, 2, 3,
    
    PickerView *pickerView_reason;            // 理由选择器
    int iReasonNO;
    
    UITextField *textFieldTKSM;   // 退款说明
    
    NSMutableArray *arrReason;
    NSDictionary *dicUI;
    NSMutableArray *arrUI;
}

@property(nonatomic, strong)UIImageView *productImgView;  //商品图片

@property(nonatomic, strong)UILabel *productNameLabel;  //商品名称

@property(nonatomic, strong)UILabel *productDescLabel;    //商品描述

@property(nonatomic, strong)UILabel *productPriceLabel;   //商品价格

@property(nonatomic, strong)UILabel *productNumLabel;   //商品数量


/*!
 @brief     需要上传的图片
 */
@property (nonatomic, strong) NSData *imageData;

@end

@implementation RefundReCommitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    

    [self layoutNaviBarViewWithTitle:@"重新申请"];
    
    

    
    
    [self getReason];
    
    //[self getUIDataFormWeb];
    

    
    
    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
}

-(void) initData
{
    arrReason = [[NSMutableArray alloc] init];
    dicUI = [[NSDictionary alloc] init];
    dicUI = _dicParams;
    
    arrUI = [[NSMutableArray alloc] init];
    [arrUI addObject:dicUI];
    
    iReasonNO = 0;
}


#pragma mark  ---   布局UI
-(void) layoutUI
{
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight - 100)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 300);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [UIColor whiteColor];
    
    // 商品列表
    int iTopY = [self layoutShopList];
    
    UIView *viewFG = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 10)];
    [scView addSubview:viewFG];
    viewFG.backgroundColor = [ResourceManager viewBackgroundColor];
    
    UIColor *color_kuang = [ResourceManager lightGrayColor];
    iTopY += 20;
    int iLeftX = 10;
    // 退款原因
    UILabel *lableT1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH, 20)];
    [scView addSubview:lableT1];
    lableT1.textColor = [ResourceManager color_1];
    lableT1.font = [UIFont systemFontOfSize:14];
    lableT1.text = @"退款原因";
    
    iTopY += lableT1.height + 10;
    __weak typeof(self) weakSelf = self;
    pickerView_reason = [[PickerView alloc] initWithTitle:@"" placeHolder:@"请选择" width:SCREEN_WIDTH-35 itemArray:arrReason origin_Y:iTopY];
    pickerView_reason.finishedBlock = ^(int index){
        //_loanType = _pickerView_loanType.itemsArray[index];
        iReasonNO = index +1;
    };
    pickerView_reason.beginBlock = ^{
        [weakSelf resignKeyboard];
    };
    [scView addSubview:pickerView_reason];
    //pickerView_reason.backgroundColor = [UIColor blueColor];
    
    int resionId = [dicUI[@"resionId"] intValue] -1;
    [pickerView_reason setSelectedIndex:resionId ];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 46)];
    [scView addSubview:label];
    label.borderColor = color_kuang;
    label.borderWidth = 0.5;
    label.cornerRadius = 5;
    
    
    iTopY += label.height + 15;
    // 退款金额
    UILabel *lableT2 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH, 20)];
    [scView addSubview:lableT2];
    lableT2.textColor = [ResourceManager color_1];
    lableT2.font = [UIFont systemFontOfSize:14];
    lableT2.text = @"退款金额（不能修改）";
    
    iTopY += lableT2.height + 10;
    UITextField *textFieldTKJE = [[UITextField alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2 *iLeftX, 46)];
    [scView addSubview:textFieldTKJE];
    textFieldTKJE.textColor = [ResourceManager color_1];
    textFieldTKJE.font = [UIFont systemFontOfSize:14];
    textFieldTKJE.borderColor = color_kuang;
    textFieldTKJE.borderWidth = 0.5;
    textFieldTKJE.cornerRadius = 5;
    textFieldTKJE.leftViewMode = UITextFieldViewModeAlways;
    textFieldTKJE.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    textFieldTKJE.text = [NSString stringWithFormat:@"%@元",dicUI[@"refundTotalAmt"]];
    textFieldTKJE.userInteractionEnabled = NO;
    
    
    iTopY += textFieldTKJE.height + 15;
    // 退款邮费等
    UILabel *labelTKYF = [[UILabel alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 30)];
    [scView addSubview:labelTKYF];
    labelTKYF.backgroundColor = [ResourceManager viewBackgroundColor];
    labelTKYF.textColor = [ResourceManager color_1];
    labelTKYF.font = [UIFont systemFontOfSize:14];
    labelTKYF.text = [NSString stringWithFormat:@"   最多可退¥%@，包含发货邮费¥%@",dicUI[@"refundTotalAmt"],dicUI[@"freightAmt"]];;
    
    
    iTopY += labelTKYF.height + 10;
    // 退款说明
    UILabel *lableT3 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH, 20)];
    [scView addSubview:lableT3];
    lableT3.textColor = [ResourceManager color_1];
    lableT3.font = [UIFont systemFontOfSize:14];
    lableT3.text = @"退款说明（可不填）";
    
    iTopY += lableT3.height + 10;
    textFieldTKSM = [[UITextField alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2 *iLeftX, 46)];
    [scView addSubview:textFieldTKSM];
    textFieldTKSM.textColor = [ResourceManager color_1];
    textFieldTKSM.font = [UIFont systemFontOfSize:14];
    textFieldTKSM.borderColor = color_kuang;
    textFieldTKSM.borderWidth = 0.5;
    textFieldTKSM.cornerRadius = 5;
    textFieldTKSM.leftViewMode = UITextFieldViewModeAlways;
    textFieldTKSM.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    textFieldTKSM.placeholder = @"200字以内";
    textFieldTKSM.delegate = self;
    textFieldTKSM.tag = 1000;
    //textFieldTKSM.text = [NSString stringWithFormat:@"%@元",_dicParams[@"totalOrderAmt"]];
    
    // 上传图片
    iTopY += textFieldTKSM.height + 15;
    UILabel *lableT4 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH, 20)];
    [scView addSubview:lableT4];
    lableT4.textColor = [ResourceManager color_1];
    lableT4.font = [UIFont systemFontOfSize:14];
    lableT4.text = @"图片举证（可上传3张图片）";
    
    
    iTopY += lableT4.height + 10;
    int iImgWdith = 90;
    int iImgLeft = iLeftX;
    img1 = [[UIImageView alloc] initWithFrame:CGRectMake(iImgLeft, iTopY, iImgWdith , iImgWdith)];
    img1.tag = 1;
    [img1 setImage:[UIImage imageNamed:@"Rfund_sctp"]];
    img1.userInteractionEnabled = YES;
    [scView addSubview:img1];
    
    //添加图片手势
    UITapGestureRecognizer *imgGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgBtn:)];
    [img1 addGestureRecognizer:imgGesture];
    
    iImgLeft += iImgWdith + iLeftX;
    img2 = [[UIImageView alloc] initWithFrame:CGRectMake(iImgLeft, iTopY, iImgWdith , iImgWdith)];
    [img2 setImage:[UIImage imageNamed:@"Rfund_sctp"]];
    img2.tag = 2;
    img2.userInteractionEnabled = YES;
    img2.hidden = YES;
    [scView addSubview:img2];
    
    //添加图片手势
    UITapGestureRecognizer *imgGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgBtn:)];
    [img2 addGestureRecognizer:imgGesture2];
    
    iImgLeft += iImgWdith + iLeftX;
    img3 = [[UIImageView alloc] initWithFrame:CGRectMake(iImgLeft, iTopY, iImgWdith , iImgWdith)];
    [img3 setImage:[UIImage imageNamed:@"Rfund_sctp"]];
    img3.tag = 3;
    img3.userInteractionEnabled = YES;
    img3.hidden = YES;
    [scView addSubview:img3];
    
    //添加图片手势
    UITapGestureRecognizer *imgGesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgBtn:)];
    [img3 addGestureRecognizer:imgGesture3];
    
    strImgUrl1 = nil;
    strImgUrl2 = nil;
    strImgUrl3 = nil;
    
    iTopY += iImgWdith + 10;
    scView.contentSize = CGSizeMake(0, iTopY);
    
    [self layoutTail];
    
}

-(int) layoutShopList
{
    
    int iTopY = 0;
    int iCellLeftX = 15;
    int iCellTopY = 0;
    
    NSArray *orderDtlListArr = arrUI;//[_dicParams objectForKey:@"orderDtlList"];
    if (orderDtlListArr.count == 0) {
        return  0;
    }
    
    UIColor *color_1 = [ResourceManager color_1];
    UIColor *color_2 = [ResourceManager color_6];
    UIFont *font_1 = [UIFont systemFontOfSize:13];
    UIFont *font_2 = [UIFont systemFontOfSize:12];
    
    for (int i = 0; i < orderDtlListArr.count; i++) {
        
        NSDictionary *dic = orderDtlListArr[i];
        UIView *viewCell = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, orderCellHeight)];
        [scView addSubview:viewCell];
        viewCell.backgroundColor = [UIColor whiteColor];
        
        iCellTopY = 15;
        iCellLeftX = 15;
        _productImgView = [[UIImageView alloc]initWithFrame:CGRectMake(iCellLeftX, iCellTopY, 70, 70)];
        [viewCell addSubview:_productImgView];
        _productImgView.backgroundColor = UIColorFromRGB(0xf6f6f6);
        [_productImgView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"goodsUrl"]]];
        
        _productNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_productImgView.frame) + 10, CGRectGetMinY(_productImgView.frame) + 5, 200, 20)];
        [viewCell addSubview:_productNameLabel];
        _productNameLabel.font = font_1;
        _productNameLabel.textColor = color_1;
        _productNameLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"goodsName"]];
        
        _productDescLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_productImgView.frame) + 10, CGRectGetMaxY(_productNameLabel.frame) + 5, 200, 20)];
        [viewCell addSubview:_productDescLabel];
        _productDescLabel.font = font_2;
        _productDescLabel.textColor = color_2;
        _productDescLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"skuDesc"]];
        
        _productPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, CGRectGetMinY(_productImgView.frame) + 5, 150, 20)];
        [viewCell addSubview:_productPriceLabel];
        _productPriceLabel.textAlignment = NSTextAlignmentRight;
        _productPriceLabel.font = font_1;
        _productPriceLabel.textColor = color_2;
        _productPriceLabel.text = [NSString stringWithFormat:@"￥%@",[dic objectForKey:@"refundPrice"]];
        
        _productNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 160, CGRectGetMaxY(_productPriceLabel.frame) + 5, 150, 20)];
        [viewCell addSubview:_productNumLabel];
        _productNumLabel.textAlignment = NSTextAlignmentRight;
        _productNumLabel.font = font_2;
        _productNumLabel.textColor = color_2;
        _productNumLabel.text = [NSString stringWithFormat:@"x%@",[dic objectForKey:@"refundNum"]];
        
        
        UIView *lineViewX = [[UIView alloc]initWithFrame:CGRectMake(0, orderCellHeight -1, SCREEN_WIDTH, 1)];
        [viewCell addSubview:lineViewX];
        lineViewX.backgroundColor = [ResourceManager color_5];
        
        iTopY += orderCellHeight;
    }
    
    
    return iTopY;
}

-(void) layoutTail
{
    UIView *viewTail = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-95, SCREEN_WIDTH, 95)];
    [self.view addSubview:viewTail];
    viewTail.backgroundColor = [UIColor whiteColor];
    
    UILabel *labelNote = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 30)];
    [viewTail addSubview:labelNote];
    labelNote.textColor = [ResourceManager priceColor];
    labelNote.font = [UIFont systemFontOfSize:10];
    labelNote.numberOfLines = 0;
    labelNote.text = @"温馨提示：订单退款金额以实际支付金额为准，不包括优惠券抵扣金额，无质量问题退货所产生的物流费由购买者承担，从退款中直接抵扣。";
    
    //    NSString *strWeb = dicUI[@"tipMsg"];
    //    if (strWeb &&
    //        strWeb.length > 0)
    //     {
    //        labelNote.text = strWeb;
    //     }
    
    UIButton *btnCommit = [[UIButton alloc] initWithFrame:CGRectMake(15, 50, SCREEN_WIDTH - 30, 40)];
    [viewTail addSubview:btnCommit];
    [btnCommit setTitle:@"提交退款申请" forState:UIControlStateNormal];
    [btnCommit setTitleColor:[ResourceManager mainColor] forState:UIControlStateNormal];
    btnCommit.titleLabel.font = [UIFont systemFontOfSize:14];
    btnCommit.borderColor = [ResourceManager mainColor];
    btnCommit.borderWidth = 1;
    btnCommit.backgroundColor = [UIColor whiteColor];
    [btnCommit addTarget:self action:@selector(actionCommit) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark  --- action
-(void) imgBtn:(id)sender
{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    int iTag = (int)[singleTap view].tag;
    iSelImg = iTag;
    NSLog(@"iTag:%d",iTag);
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        return;
    }
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate=self;
    //pickerController.allowsEditing=YES;
    pickerController.navigationBar.translucent=NO;   //去除毛玻璃效果, 可以把navvigatiaonBar正常显示
    pickerController.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.navigationBar.tintColor = [ResourceManager mainColor];
    [self.navigationController presentViewController:pickerController animated:YES completion:nil];
    
}


-(void) actionCommit
{
    if (iReasonNO <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请选择退款原因" toView:self.view];
        return;
     }
    
    [self goodCommit];
}


#pragma mark ---  网络通讯
-(void) getReason
{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString], kURLresionList];
    
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                      //[MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                  }];
    [operation start];
    operation.tag = 1000;
}



-(void) goodCommit
{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"refundNo"] = _dicParams[@"refundNo"];
//    params[@"subOrderNos"] = _subOrderNo;
    params[@"refundType"] =  [NSString stringWithFormat:@"%@", _dicParams[@"refundType"]];
    params[@"resionId"] = @(iReasonNO);
    params[@"refundDesc"] = textFieldTKSM.text;
    params[@"resionId"] = @(iReasonNO);
    if (strImgUrl1)
     {
        params[@"imgUrl1"] = strImgUrl1;
     }
    if (strImgUrl2)
     {
        params[@"imgUrl2"] = strImgUrl2;
     }
    if (strImgUrl3)
     {
        params[@"imgUrl3"] = strImgUrl3;
     }
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString], kURLagainApplyRefund];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                      //[MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                  }];
    
    operation.tag = 1002;
    [operation start];
    
}

-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    if (1000 == operation.tag)
     {
        NSArray* arr = operation.jsonResult.rows;
        if (!arr &&
            arr.count <= 0)
         {
            return;
         }
        
        [arrReason removeAllObjects];
        for (int i = 0; i < arr.count; i++)
         {
            NSDictionary *obj = arr[i];
            NSString *str = [NSString stringWithFormat:@"%@", obj[@"resionDesc"]];
            [arrReason addObject:str];
         }
        
        [self layoutUI];
     }
    else if (1001 == operation.tag)
     {

        //[self layoutUI];
     }
    else if (1002 == operation.tag)
     {
        [MBProgressHUD showErrorWithStatus:@"申请提交成功" toView:self.view];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];// 延迟执行
        return;
     }
    
}



-(void) delayMethod
{
    //[self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGSwitchTabNotification object:@{@"tab":@(4),@"index":@(0)}];
}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}

#pragma mark UIImagePickerViewControllerDelegate
/**
 *  Tells the delegate that the user picked a still image or movie.
 *
 *  @param picker
 *  @param info
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
#define dataSize 1024.0f
#define imageSize CGSizeMake(600.0f, 600.0f)
    //    //先把原图保存到图片库
    //    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    //     {
    //        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    //        UIImageWriteToSavedPhotosAlbum(originalImage, nil, nil, nil);
    //     }
    //获取用户选取的图片并转换成NSData
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //缩小图片的size
    //image = [self imageByRedraw:image];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.2f);
    if (imageData){
        self.imageData = imageData;
        // 上传
        [self upLoadImageData];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}
/**
 *  截图
 *
 *  @param image
 *
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

-(void)upLoadImageData{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"fileType"] = @"refundImg";
    params[@"signId"] = [DDGSetting sharedSettings].signId;
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
        //把图片添加到视图框内
        
        
        id json = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        
        int iSuccess = [[(NSDictionary *)json objectForKey:@"success"] intValue];
        if (iSuccess != 0) {
            [MBProgressHUD showSuccessWithStatus:@"上传成功" toView:self.view];
            
            NSDictionary *dic = [(NSDictionary *)json objectForKey:@"attr"];
            NSString *imgUrlStr = [dic objectForKey:@"url"];
            
            if (iSelImg == 1)
             {
                img1.image=[UIImage imageWithData:self.imageData];
                strImgUrl1 = imgUrlStr;
                img2.hidden = NO;
                
             }
            else if (iSelImg == 2)
             {
                img2.image=[UIImage imageWithData:self.imageData];
                strImgUrl2 = imgUrlStr;
                img3.hidden = NO;
             }
            else if (iSelImg == 3)
             {
                img3.image=[UIImage imageWithData:self.imageData];
                strImgUrl3 = imgUrlStr;
             }
            
            
        }
        else{
            [MBProgressHUD showErrorWithStatus:[(NSDictionary *)json objectForKey:@"message"] toView:self.view];
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [MBProgressHUD showErrorWithStatus:[operation.error localizedDescription] toView:self.view];
        self.imageData = nil;
    }];
}



@end
