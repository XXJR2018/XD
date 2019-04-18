//
//  MessageListVC.h
//  TGWSCAPP
//
//  Created by xxjr02 on 2019/1/14.
//  Copyright © 2019 xxjr03. All rights reserved.
//


#import "MJRefreshViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageListVC : MJRefreshViewController

@property (nonatomic, assign)  int  msgType;  // 1 通知消息  2资产提醒消息

@end

NS_ASSUME_NONNULL_END
