//
//  ShopAllVC.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/2/20.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopAllVC : CommonViewController

@property (nonatomic,strong) NSString  *strTypeCode;
@property (nonatomic,strong) NSString  *strTypeName;
@property (nonatomic,assign) bool   isGoodType;  // 是商品类型的查询

@end

NS_ASSUME_NONNULL_END
