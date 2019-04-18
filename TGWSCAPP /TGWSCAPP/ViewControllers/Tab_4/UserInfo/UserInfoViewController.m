//
//  UserInfoViewController.m
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/24.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "UserInfoViewController.h"

#import "NickNameViewController.h"
#import "AccountSecurityViewController.h"


@interface UserInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIButton *_sexBtn;
    NSMutableArray *_sexBtnArr;
    NSInteger _sexNum;
}
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *sexLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UIButton *loginOutBtn;

@property(nonatomic, strong) UIView *sexAlertView;

@property (weak, nonatomic) IBOutlet UILabel *cacheNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutTop;

@end

@implementation UserInfoViewController

-(void)changeCustInfoUrl{
    [MBProgressHUD showHUDAddedTo:self.view];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"gender"] = @(_sexNum);
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/cust/info/changeCustInfo",[PDAPI getBaseUrlString]]
                                                                               parameters:params HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [self handleData:operation];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [self handleErrorData:operation];
                                                                                  }];
    [operation start];
}

-(void)logoutUrl{
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/login/logout",[PDAPI getBaseUrlString]]
                                                                               parameters:nil HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                     
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      
                                                                                  }];
    [operation start];
}

#pragma mark 数据操作
-(void)handleData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showSuccessWithStatus:@"性别设置成功" toView:self.view];
    //发送通知更新用户信息
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGNotificationAccountNeedRefresh object:nil];

}

-(void)handleErrorData:(DDGAFHTTPRequestOperation *)operation{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"个人资料"];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"个人资料"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutNaviBarViewWithTitle:@"个人资料"];
    self.view.backgroundColor = [UIColor whiteColor];
    _sexBtnArr = [NSMutableArray array];
    
    [self layoutUI];
}

-(void)layoutUI{
    
    if (iOS11Less) {
        self.layoutTop.constant = NavHeight;
    }
    self.loginOutBtn.layer.cornerRadius = 3;
    self.loginOutBtn.layer.borderWidth = 0.5;
    self.loginOutBtn.layer.borderColor = [ResourceManager mainColor].CGColor;
    
    self.cacheNumLabel.text = [NSString stringWithFormat:@"%.2f M",[self folderSizeAtPath]];
    
    NSString *bundleStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text  = [NSString stringWithFormat:@"版本: v%@", bundleStr];
    
    UITapGestureRecognizer * gestureSearch = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(uploadImg)];
    gestureSearch.numberOfTapsRequired  = 1;
    [self.headImgView addGestureRecognizer:gestureSearch];
    
    if ([CommonInfo userInfo].count > 0) {
        NSDictionary *dic = [CommonInfo userInfo];
        //头像
        if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"headImgUrl"]].length > 0) {
            [self.headImgView sd_setImageWithURL:[dic objectForKey:@"headImgUrl"] placeholderImage:[UIImage imageNamed:@"Tab_4-2"]];
        }
        //昵称
        if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"nickName"]].length > 0) {
            self.nickNameLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"nickName"]];
        }
        //性别
        if ([[dic objectForKey:@"gender"] intValue] == 1) {
            self.sexLabel.text = @"男";
        }else if ([[dic objectForKey:@"gender"] intValue] == 2) {
            self.sexLabel.text = @"女";
        }
        //电话
        if ([NSString stringWithFormat:@"%@",[dic objectForKey:@"hideTelephone"]].length == 11) {
            self.phoneLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"hideTelephone"]];
        }
    }
    
}

//设置昵称
- (IBAction)nicknameTouch:(id)sender {
    NickNameViewController *ctl = [[NickNameViewController alloc]init];
    ctl.nickNameBlock = ^(NSString *nickName){
        if (nickName.length > 0) {
            self.nickNameLabel.text = nickName;
        }
    };
    
    [self.navigationController pushViewController:ctl animated:YES];
}

//设置性别
- (IBAction)sexTouch:(id)sender {
    [self sexAlertViewUI];
}

//账户安全
- (IBAction)securityTouch:(id)sender {
    AccountSecurityViewController *ctl = [[AccountSecurityViewController alloc]init];
    [self.navigationController pushViewController: ctl animated:YES];
}

//退出登录
- (IBAction)loginOut:(id)sender {
    [self logoutUrl];
    [CommonInfo AllDeleteInfo];
    [self.navigationController popToRootViewControllerAnimated:NO];
    //发送退出登录通知
    [[NSNotificationCenter defaultCenter] postNotificationName:DDGAccountEngineDidLogoutNotification object:nil];
}

#pragma mark--  性别选择弹窗
-(void)sexAlertViewUI{
    [_sexAlertView removeFromSuperview];
    
    _sexAlertView = [[UIView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:_sexAlertView];
    _sexAlertView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    
    UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 150, SCREEN_WIDTH, 150)];
    [_sexAlertView addSubview:alertView];
    alertView.backgroundColor = [UIColor whiteColor];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    [alertView addSubview:cancelBtn];
    cancelBtn.tag = 100;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [cancelBtn addTarget:self action:@selector(closeTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 80, 0, 80, 40)];
    [alertView addSubview:confirmBtn];
    confirmBtn.tag = 101;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [confirmBtn addTarget:self action:@selector(closeTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *titleArr = @[@"男",@"女"];
    for (int i = 0; i < titleArr.count; i++) {
        _sexBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 200)/2, CGRectGetMaxY(confirmBtn.frame) + 45 * i, 200, 45)];
        [alertView addSubview:_sexBtn];
        _sexBtn.tag = 100 + i;
        [_sexBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        [_sexBtn setTitleColor:[ResourceManager color_1] forState:UIControlStateNormal];
        [_sexBtn setTitleColor:[ResourceManager mainColor] forState:UIControlStateSelected];
        _sexBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_sexBtn addTarget:self action:@selector(sexSelectTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *viewX = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(_sexBtn.frame), SCREEN_WIDTH - 40, 0.5)];
        [alertView addSubview:viewX];
        viewX.backgroundColor=  [ResourceManager color_5];
        
        [_sexBtnArr addObject:_sexBtn];

    }
    
}

-(void)closeTouch:(UIButton *)sender{
    [_sexAlertView removeFromSuperview];
    if (sender.tag == 100) {
        NSDictionary *dic = [CommonInfo userInfo];
        if ([[dic objectForKey:@"gender"] intValue] == 1) {
            self.sexLabel.text = @"男";
        }else if ([[dic objectForKey:@"gender"] intValue] == 2) {
            self.sexLabel.text = @"女";
        }else{
            self.sexLabel.text = @"点击设置性别";
        }
    }else{
        if (self.sexLabel.text.length == 1) {
            //修改用户基本信息
            [self  changeCustInfoUrl];
        }
    }
    
}

-(void)sexSelectTouch:(UIButton *)sender{
    if (sender != _sexBtn) {
        _sexBtn.selected = NO;
        _sexBtn = sender;
    }
    _sexBtn.selected = YES;
    if (sender.tag == 100) {
        self.sexLabel.text = @"男";
        _sexNum = 1;
    }else {
        self.sexLabel.text = @"女";
        _sexNum = 2;
    }
}


#pragma mark--  上传头像
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
    params[@"fileType"] = @"headImg";
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
            [self uploadHeadImgUrl:imgUrlStr];
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

//图片提交到数据库
-(void)uploadHeadImgUrl:(NSString *)imgUrlStr{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    DDGAFHTTPRequestOperation *operation = [[DDGAFHTTPRequestOperation alloc] initWithURL:[NSString stringWithFormat:@"%@appMall/account/cust/info/changeCustInfo",[PDAPI getBaseUrlString]]
                                                                               parameters:@{@"headImgUrl":imgUrlStr} HTTPCookies:[DDGAccountManager sharedManager].sessionCookiesArray
                                                                                  success:^(DDGAFHTTPRequestOperation *operation, id responseObject){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      //上传成功展示新头像
                                                                                      [self.headImgView sd_setImageWithURL:[NSURL URLWithString:imgUrlStr]];
                                                                                      //发送通知更新用户信息
                                                                                      [[NSNotificationCenter defaultCenter] postNotificationName:DDGNotificationAccountNeedRefresh object:nil];
                                                                                  }
                                                                                  failure:^(DDGAFHTTPRequestOperation *operation, NSError *error){
                                                                                      [MBProgressHUD hideHUDForView:self.view animated:NO];
                                                                                      [MBProgressHUD showErrorWithStatus:operation.jsonResult.message toView:self.view];
                                                                                  }];
    [operation start];
}

//清除本地缓存
- (IBAction)clearLocalCache:(UIButton *)sender {
    NSString *cacheStr = [NSString stringWithFormat:@"缓存大小为%@,确定要清除吗?",self.cacheNumLabel.text];
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"清除缓存" message:cacheStr preferredStyle:UIAlertControllerStyleAlert];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self clearCaches];
        self.cacheNumLabel.text = [NSString stringWithFormat:@"%.2f M",[self folderSizeAtPath]];
    }]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - 单个文件大小的计算
-(long long)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}

#pragma mark----文件夹大小的计算(要利用上面的$1提供的方法)
-(float)folderSizeAtPath{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    long long folderSize=0;
    if ([fileManager fileExistsAtPath:cachePath]){
        NSArray *childerFiles=[fileManager subpathsAtPath:cachePath];
        for (NSString *fileName in childerFiles){
            NSString *fileAbsolutePath=[cachePath stringByAppendingPathComponent:fileName];
            long long size=[self fileSizeAtPath:fileAbsolutePath];
            folderSize += size;
            NSLog(@"fileAbsolutePath=%@",fileAbsolutePath);
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize+=[[SDImageCache sharedImageCache] getSize];
        return folderSize/1024.0/1024.0;
    }
    return 0;
}

#pragma mark----清除缓存
//同样也是利用NSFileManager API进行文件操作，SDWebImage框架自己实现了清理缓存操作，我们可以直接调用。
-(void)clearCaches{
    NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
//    cachePath=[cachePath stringByAppendingPathComponent:path];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:cachePath]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:cachePath];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *fileAbsolutePath=[cachePath stringByAppendingPathComponent:fileName];
            NSLog(@"fileAbsolutePath=%@",fileAbsolutePath);
            [fileManager removeItemAtPath:fileAbsolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] clearMemory];
}


@end
