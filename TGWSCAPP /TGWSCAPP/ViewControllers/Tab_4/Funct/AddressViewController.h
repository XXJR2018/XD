//
//  AddressViewController.h
//  TGWSCAPP
//
//  Created by xxjr03 on 2018/12/27.
//  Copyright © 2018 xxjr03. All rights reserved.
//

#import "MJRefreshViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddressViewController : MJRefreshViewController

@property(nonatomic, assign) NSInteger selectType;

@property(nonatomic, copy)Block_String selectAddressBlock;

@property(nonatomic, copy)Block_Id selAddressBlock;

@end

NS_ASSUME_NONNULL_END
