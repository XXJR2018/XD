//
//  ShareShopJpegView.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/2/28.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShareShopJpegView : UIView

-(ShareShopJpegView*) initWithArrImg:(NSArray *)arrImg   withNo:(int) iCurNo  withShopModel:(ShopModel*) sModel;


@property (nonatomic,strong) UIViewController *parentVC;
@property (nonatomic,strong) ShopModel  *shopModel;

@end

NS_ASSUME_NONNULL_END
