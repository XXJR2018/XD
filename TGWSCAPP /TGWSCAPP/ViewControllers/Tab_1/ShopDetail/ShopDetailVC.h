//
//  ShopDetailVC.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/21.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "CommonViewController.h"
#import "ShopModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShopDetailVC : CommonViewController

@property (nonatomic,strong) ShopModel  *shopModel;

//1.从首页showType进入 est=showType  esi=typeId
//2.从类目查询中进入  est= category esi= cateId
//3.从搜索中进入  est=search
//4.从购物车中进入  est=cart esi= cartId
//5从收藏中进入 est=favorite esi=favoriteId
@property (nonatomic,strong) NSString  *est;
@property (nonatomic,strong) NSString  *esi;

@end

NS_ASSUME_NONNULL_END
