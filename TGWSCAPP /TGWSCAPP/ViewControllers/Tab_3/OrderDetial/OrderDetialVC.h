//
//  OrderDetialVC.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/3.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetialVC : CommonViewController

@property (nonatomic,assign) int iType;    //  1 - 商品详情直接购买，  2 - 购物车直接购买
@property (nonatomic,strong) NSMutableDictionary*  dicToWeb;  // 发送到Web的请求参数

@end

NS_ASSUME_NONNULL_END
