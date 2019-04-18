//
//  JMKAccountEngine.h
//  DDGAPP
//
//  Created by Cary on 15/3/3.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^LoginFinishBlock)(); //完成登录执行block
typedef void (^LoginCancelBlock)();	//取消登录执行block

@interface DDGUserInfoEngine : NSObject


/*!
 @property  JMKUserInfoEngine engine
 @brief     单例JMKUserInfoEngine
 */
+ (DDGUserInfoEngine *)engine;

/*!
 @property  BOOL isLogging
 @brief     是否正在完善
 */
@property (nonatomic, assign) BOOL isLogging;

/*!
 @property  UIViewController parentViewController
 @brief     需要弹出完善资料的界面的 view controller
 */
@property (nonatomic, weak) UIViewController *parentViewController;

/**
 *	完善资料viewController
 */
@property (nonatomic, strong) UIViewController *loginViewController;

/*!
 @property  LoginFinishBlock loginFinishBlock
 @brief     完成完善资料执行的block
 */
@property (nonatomic, copy) LoginFinishBlock loginFinishBlock;
/*!
 @property  LoginFinishBlock loginFinishBlock
 @brief     取消完善资料执行的block
 */
@property (nonatomic, copy) LoginCancelBlock loginCancelBlock;

/**
 *  从手势密码界面跳转，标记是否需要重置手势密码
 */
@property (nonatomic, assign)BOOL isNeedReSetGesture;

/**
 *  从手势密码界面跳转，用登录密码   替换  手势密码 验证
 */
@property (nonatomic, assign)BOOL isWithoutGestureLogin;

/*!
 @brief     弹出完善资料界面，完成动作
 */
- (void)finishUserInfoWithFinish:(void (^)(void))block;
/*!
 @brief     弹出完善资料界面，完成动作 取消动作
 */
- (void)finishUserInfoWithFinish:(void (^)(void))block cancel:(void(^)(void))cancelBlock;

/*!
 @brief     关闭登录界面
 */
- (void)dismissFinishUserInfoController:(Block_Void)block;

/*!
 @brief     完成登录block
 */
- (void)finishDoBlock;
/*!
 @brief     取消登录block
 */
- (void)cancelDoBlock;



@end
