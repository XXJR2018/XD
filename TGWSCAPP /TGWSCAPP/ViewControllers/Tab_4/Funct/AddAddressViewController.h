//
//  AddAddressViewController.h
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/27.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddAddressViewController : CommonViewController

@property(nonatomic, copy)NSDictionary *addressDic;

@property(nonatomic, copy)NSString *titleStr;

@property(nonatomic, copy)Block_Void addressBlock;

@end

NS_ASSUME_NONNULL_END
