//
//  MyAPPraiseView.h
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/2/19.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyAPPraiseView : UIView

@property(nonatomic, copy)Block_Void myAppraiseBlock;

@property(nonatomic, copy)Block_Int clickEnlargeBlock;

-(UIView *)initWithAppraiseListViewLayoutUI:(NSDictionary *)dic;


@end

NS_ASSUME_NONNULL_END
