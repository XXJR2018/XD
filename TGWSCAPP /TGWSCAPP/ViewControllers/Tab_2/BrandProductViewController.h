//
//  BrandProductViewController.h
//  TGWSCAPP
//
//  Created by xxjr03 on 2019/3/22.
//  Copyright © 2019 xxjr03. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BrandProductViewController : CommonViewController

@property(nonatomic, copy)NSString *titleStr;

@property(nonatomic, assign)NSInteger cateId;

@property(nonatomic, copy)NSArray *sortDataArr;

@end

NS_ASSUME_NONNULL_END
