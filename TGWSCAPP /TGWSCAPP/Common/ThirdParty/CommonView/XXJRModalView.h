//
//  PDModalView.h
//  EVTUtils
//
//  Created by paidui-mini on 14-4-10.
//  Copyright (c) 2014年 Paidui, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXJRModalView : UIView
/**
 *  从下弹出层
 *
 *  @param view 需要显示的view
 */
+ (void)showModalView:(UIView *)view;
/*!
 @brief     移除层
 */
+ (void)dismissModalView;

@end
