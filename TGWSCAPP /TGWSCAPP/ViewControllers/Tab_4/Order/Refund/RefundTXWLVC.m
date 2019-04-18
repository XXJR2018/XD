//
//  RefundTXWLVC.m
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/12.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "RefundTXWLVC.h"
#import "TextFieldView.h"

@interface RefundTXWLVC ()<UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIScrollView *scView;
    
    TextFieldView *textWLGS;  // 物流公司
    TextFieldView *textWLDH;  // 物流单号
    
    TextFieldView *textSJHM;  // 手机号码
    TextFieldView *textBZXX;  // 备注消息
    
    
    UIImageView *img1;       //  图片1
    NSString    *strImgUrl1;
    UIImageView *img2;       //  图片2
    NSString    *strImgUrl2;
    UIImageView *img3;       //  图片3
    NSString    *strImgUrl3;
    int  iSelImg;    // 1, 2, 3,
}

/*!
 @brief     需要上传的图片
 */
@property (nonatomic, strong) NSData *imageData;

@end

@implementation RefundTXWLVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutNaviBarViewWithTitle:@"填写物流"];
    
    [self layoutUI];
}

#pragma  mark --- 布局UI
-(void)layoutUI
{

    //添加手势点击空白处隐藏键盘
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboard)];
    gesture.numberOfTapsRequired  = 1;
    [self.view addGestureRecognizer:gesture];
    
    scView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.f, NavHeight, SCREEN_WIDTH, SCREEN_HEIGHT - NavHeight)];
    [self.view addSubview:scView];
    scView.contentSize = CGSizeMake(0, 500);
    scView.pagingEnabled = NO;
    scView.bounces = NO;
    scView.showsVerticalScrollIndicator = FALSE;
    scView.showsHorizontalScrollIndicator = FALSE;
    scView.backgroundColor = [ResourceManager viewBackgroundColor];
    
    int iTopY = 0 ;
    int iLeftX = 10;
    textWLGS = [[TextFieldView alloc] initWithTitle:@"物流公司" placeHolder:@"请输入物流公司" textAlignment:NSTextAlignmentLeft width:SCREEN_WIDTH - 100  originY:iTopY  fieldViewType:TextFieldViewDefault];
    [scView addSubview:textWLGS];
    textWLGS.linetype = LineTypeBotton;
    
    iTopY += CellHeight44;
    textWLDH = [[TextFieldView alloc] initWithTitle:@"物流单号" placeHolder:@"请输入物流单号" textAlignment:NSTextAlignmentLeft width:SCREEN_WIDTH - 100 originY:iTopY  fieldViewType:TextFieldViewDefault];
    [scView addSubview:textWLDH];
    //textWLGS.linetype = LineTypeBotton;
    
    iTopY += CellHeight44+ 10;
    textSJHM = [[TextFieldView alloc] initWithTitle:@"手机号码" placeHolder:@"请输入手机号码" textAlignment:NSTextAlignmentLeft width:SCREEN_WIDTH - 100 originY:iTopY  fieldViewType:TextFieldViewNumber];
    [scView addSubview:textSJHM];
    textSJHM.linetype = LineTypeBotton;

    
    iTopY += CellHeight44;
    textBZXX = [[TextFieldView alloc] initWithTitle:@"备注消息" placeHolder:@"请输入备注消息" textAlignment:NSTextAlignmentLeft width:SCREEN_WIDTH - 100 originY:iTopY  fieldViewType:TextFieldViewDefault];
    [scView addSubview:textBZXX];
    textBZXX.linetype = LineTypeBotton;
    
    
    iTopY += CellHeight44;
    UIView *viewPhoto = [[UIView alloc] initWithFrame:CGRectMake(0, iTopY, SCREEN_WIDTH, 160)];
    [scView addSubview:viewPhoto];
    viewPhoto.backgroundColor = [UIColor whiteColor];
    
    UILabel *lableT1 = [[UILabel alloc] initWithFrame:CGRectMake(iLeftX, iTopY, 100, CellHeight44)];
    [scView addSubview:lableT1];
    lableT1.textColor = [ResourceManager color_1];
    lableT1.font = [UIFont systemFontOfSize:14];
    lableT1.text = @"图片举证";
    
    UILabel *lableT1_A = [[UILabel alloc] initWithFrame:CGRectMake(85, iTopY, 200, CellHeight44)];
    [scView addSubview:lableT1_A];
    lableT1_A.textColor = [ResourceManager lightGrayColor];
    lableT1_A.font = [UIFont systemFontOfSize:14];
    lableT1_A.text = @"可上传3张图片";
    
    iTopY += lableT1_A.height + 10;
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
    
    iTopY += iImgWdith + 30;
    
    UIButton *btnTXWL = [[UIButton alloc] initWithFrame:CGRectMake(iLeftX, iTopY, SCREEN_WIDTH - 2*iLeftX, 40)];
    [scView addSubview:btnTXWL];
    btnTXWL.backgroundColor = [ResourceManager mainColor];
    btnTXWL.cornerRadius = 5;
    [btnTXWL setTitle:@"提交物流信息" forState:UIControlStateNormal];
    [btnTXWL setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnTXWL.titleLabel.font = [UIFont systemFontOfSize:14];
    [btnTXWL addTarget:self action:@selector(actionTXWl) forControlEvents:UIControlEventTouchUpInside];
    
    scView.contentSize = CGSizeMake(0, iTopY);
    
    //[self layoutTail];
    
    

}

#pragma mark ---  action
-(void) actionTXWl
{
    if (textWLGS.textField.text.length <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请输入物流公司" toView:self.view];
        return;
     }
    if (textWLDH.textField.text.length <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请输入物流单号" toView:self.view];
        return;
     }
    if (textSJHM.textField.text.length <= 0)
     {
        [MBProgressHUD showErrorWithStatus:@"请输入手机号码" toView:self.view];
        return;
     }

    [self goodCommit];
    
}


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


#pragma mark  ---  网络通讯
-(void) goodCommit
{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"refundNo"] = _dicParams[@"refundNo"];
    params[@"logisticsId"] = _dicParams[@"logisticsId"];;
    params[@"expressCompany"] = textWLGS.textField.text;
    params[@"expressNo"] = textWLDH.textField.text;
    params[@"custRemark"] = textBZXX.textField.text;
    params[@"custTel"] = textSJHM.textField.text;
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
    
    NSString *strUrl = [NSString stringWithFormat:@"%@%@",[PDAPI getBaseUrlString], kURLsaveLogistics];
    
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:strUrl
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                      //[MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                  }];
    
    operation.tag = 1000;
    [operation start];
    
}


-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    if (1000 == operation.tag)
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
