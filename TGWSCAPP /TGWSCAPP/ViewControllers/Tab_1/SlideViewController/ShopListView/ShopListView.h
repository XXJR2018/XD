//
//  ShopListView.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/14.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"

NS_ASSUME_NONNULL_BEGIN


@protocol ShopListViewDelegate<NSObject>
@optional

-(void)didShopClickButtonAtObejct:(ShopModel*)clickObj;

@end

@interface ShopListView : UIView

// columnCount  每一行元素的个数
-(ShopListView*)initWithTitle:(NSString *)title  itemArray:(NSArray *)items  columnCount:(int)columnCount  origin_Y:(CGFloat)origin_Y;

//  columnOneCount - 第一行的元素个数
//  columnTwoCount - 第二行之后的 每行的元素个数
-(ShopListView*)initWithTitle:(NSString *)title  itemArray:(NSArray *)items origin_Y:(CGFloat)origin_Y
                        columnOneCount:(int)columnOneCount  columnTwoCount:(int)columnTwoCount;

-(void) drawList;

@property (nonatomic, strong) id<ShopListViewDelegate> delegate;

@property (nonatomic,strong) ShopModel  *shopModel;

@end

NS_ASSUME_NONNULL_END
