//
//  PopSelShopView.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/25.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PopSelShopView : UIView


@property (nonatomic,strong) UIViewController  *parentVC;

@property (nonatomic,strong) ShopModel  *shopModel;
@property (nonatomic,strong) NSArray *arrSku;   // 所有Sku 组合
@property (nonatomic,strong) NSArray *arrSkuShow;  // Sku 展示集合

-(void) show;

@end

NS_ASSUME_NONNULL_END
