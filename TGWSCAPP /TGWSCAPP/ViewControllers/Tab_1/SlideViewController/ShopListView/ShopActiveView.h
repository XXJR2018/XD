//
//  ShopActiveView.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/22.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "CommonViewController.h"
#import "ShopListView.h"
#import "ShopModel.h"

NS_ASSUME_NONNULL_BEGIN


@protocol ShopActiveViewDelegate<NSObject>
@optional

-(void)didShopActiveClickButtonAtObejct:(ShopModel*)clickObj;

@end

@interface ShopActiveView : UIView




//  columnOneCount - 第一行的元素个数
//  columnTwoCount - 第二行之后的 每行的元素个数
-(ShopActiveView*)initWithTitle:(NSString *)title  itemArray:(NSArray *)items origin_Y:(CGFloat)origin_Y
                        columnOneCount:(int)columnOneCount  columnTwoCount:(int)columnTwoCount;


-(void) drawList;


@property (nonatomic, strong) id<ShopActiveViewDelegate> delegate;

@property (nonatomic,strong) ShopModel  *shopModel;

@end

NS_ASSUME_NONNULL_END
