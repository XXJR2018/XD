//
//  ReviewAppraiseViewController.h
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/18.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ReviewAppraiseViewController : CommonViewController

/*!
 @brief     需要上传的图片
 */
@property (nonatomic, strong) NSData *imageData;

@property(nonatomic, copy)NSDictionary *orderDataDic;

@end

NS_ASSUME_NONNULL_END
