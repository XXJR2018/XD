//
//  HeaderCollectionReusableView.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2018/12/27.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HeaderCollectionReusableView : UICollectionReusableView

-(void)setSHCollectionReusableViewHearderTitle:(NSString *)title;

@property (nonatomic,strong) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
