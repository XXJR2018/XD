//
//  UserInfoViewController.h
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/24.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoViewController : CommonViewController

/*!
 @brief     需要上传的图片
 */
@property (nonatomic, strong) NSData *imageData;

@end

NS_ASSUME_NONNULL_END
