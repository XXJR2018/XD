//
//  SlideModel.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/14.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SlideModel : NSObject

@property (nonatomic,assign) int   iSlideID; // 本地的序号，和后台无关
@property (nonatomic,copy) NSString *cateName;  // 类目的名称
@property (nonatomic,copy) NSString *cateCode;  // 类目的code 



@end

NS_ASSUME_NONNULL_END
