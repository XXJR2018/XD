//
//  ShopMoreAtTimeVC.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/27.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopMoreAtTimeVC : CommonViewController

@property (nonatomic,strong) NSString  *strTypeCode;
@property (nonatomic,strong) NSString  *strTypeName;
@property (nonatomic,assign) bool   isGoodType;  // 是商品类型的查询

@end

NS_ASSUME_NONNULL_END
