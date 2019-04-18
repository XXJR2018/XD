//
//  MBProgressHUD+PD.h
//  EVTUtils
//
//  Created by lijian qiu on 12-6-19.
//  Copyright (c) 2012年 Paidui, Inc. All rights reserved.
//

#import <MBProgressHUD.h>

@interface MBProgressHUD (PD)

/*!
 @property  <#class#>
 @brief     只弹出菊花
 */
+ (id)showHUDAddedTo:(UIView *)view;
/*!
 @property  <#class#>
 @brief     网络出错时弹出提示文字
 */
+ (id)showNoNetworkHUDToView:(UIView *)view;
/*!
 @property  <#class#> <#name#>
 @brief     弹出菊花和文字
 */
+ (id)showWithStatus:(NSString *)string toView:(UIView *)view;
/*!
 @property  <#class#> <#name#>
 @brief     成功状态弹出对号加文字
 */
+ (id)showSuccessWithStatus:(NSString *)string toView:(UIView *)view;
/*!
 @property  <#class#> <#name#>
 @brief     失败状态弹窗哭脸加文字
 */
+ (id)showErrorWithStatus:(NSString *)string toView:(UIView *)view;
/*!
 @property  <#class#> <#name#>
 @brief     仅显示文本信息
 */
+ (id)showOnlyText:(NSString *)string toView:(UIView *)view;

/*!
 @property  <#class#> <#name#>
 @brief     <#abstract#>
 */
- (void)toShowSuccessWithStatus:(NSString *)string;
/*!
 @property  <#class#> <#name#>
 @brief     <#abstract#>
 */
- (void)toShowErrorWithStatus:(NSString *)string;
/*!
 @property  <#class#> <#name#>
 @brief     <#abstract#>
 */
- (void)toShowNoNetwork;

@end
