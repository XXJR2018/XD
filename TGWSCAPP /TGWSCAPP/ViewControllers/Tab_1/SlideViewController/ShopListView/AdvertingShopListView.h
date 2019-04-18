//
//  AdvertingShopListView.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/14.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"


NS_ASSUME_NONNULL_BEGIN


@protocol AdvertingShopListViewDelegate<NSObject>
@optional

-(void)didClickButtonAtObejct:(ShopModel*)clickObj;

@end

@interface AdvertingShopListView : UIView


// 固定每行2个元素
-(AdvertingShopListView*)initWithTitle:(NSString *)title  itemArray:(NSArray *)items origin_Y:(CGFloat)origin_Y;

//  columnOneCount - 第一行的元素个数
//  columnTwoCount - 第二行之后的 每行的元素个数
-(AdvertingShopListView*)initWithTitle:(NSString *)title  itemArray:(NSArray *)items origin_Y:(CGFloat)origin_Y
                        columnOneCount:(int)columnOneCount  columnTwoCount:(int)columnTwoCount;

-(void) drawList;


@property (nonatomic, strong) id<AdvertingShopListViewDelegate> delegate;

@property (nonatomic,strong) ShopModel  *shopModel;

@end

NS_ASSUME_NONNULL_END
