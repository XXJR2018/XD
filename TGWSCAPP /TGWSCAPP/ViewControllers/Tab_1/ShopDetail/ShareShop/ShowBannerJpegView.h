//
//  ShowBannerJpegView.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/2/28.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShowBannerJpegView : UIView

-(ShowBannerJpegView*) initWithArrImg:(NSArray *)arrImg   withNo:(int) iCurNo;


@property (nonatomic,strong) UIViewController *parentVC;
@property (nonatomic,strong) ShopModel  *shopModel;


@end

NS_ASSUME_NONNULL_END
