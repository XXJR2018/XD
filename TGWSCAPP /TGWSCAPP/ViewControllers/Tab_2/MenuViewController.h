//
//  MenuViewController.h
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/21.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MenuViewController : CommonViewController

@property(nonatomic, copy)NSString *titleStr;

@property(nonatomic, assign)NSInteger cateId;

@property(nonatomic, copy)NSArray *sortDataArr;

@end

NS_ASSUME_NONNULL_END
