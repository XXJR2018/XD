//
//  ShopModel.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/14.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShopModel : NSObject

@property (nonatomic,assign) int   iShopID;
@property (nonatomic,assign) int   iIsSellOut;  //  "isSellOut": 0 代表售罄 1代表尚有库存
@property (nonatomic,assign) int   iSaleStatus;  // 0 saleStatus  已下架 1 出售中

@property (nonatomic,copy) NSString *strTypeCode;
@property (nonatomic,copy) NSString *strTypeName;


@property (nonatomic,copy) NSString *strCateCode;
@property (nonatomic,copy) NSString *strCateName;
@property (nonatomic,copy) NSString *strGoodsCode;
@property (nonatomic,copy) NSString *strGoodsName;
@property (nonatomic,copy) NSString *strGoodsSubName;
@property (nonatomic,copy) NSString *strGoodsImgUrl;
@property (nonatomic,copy) NSString *strMaxPrice;
@property (nonatomic,copy) NSString *strMinPrice;

// 为活动时， 格外添加的字段
@property (nonatomic,assign) int   iSkipType;  //  0 - 不跳转， 1 - 跳转本地页面，  2 - 跳转URL
@property (nonatomic,copy) NSString *strSkipUrl;


@end

NS_ASSUME_NONNULL_END
