//
//  ShareView.h
//  DDGAPP
//
//  Created by ddgbank on 15/8/8.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareView : UIView

/**
 *  回调
 */
@property (nonatomic,copy) Block_Tap block;

/**
 *  弹出分享的视图
 *
 *  @param viewController 当前所在的视图
 *  @param types          要分享的类型
 */
+(void)showIn:(UIViewController *)viewController types:(NSArray *)types block:(Block_Tap)block;

@end
