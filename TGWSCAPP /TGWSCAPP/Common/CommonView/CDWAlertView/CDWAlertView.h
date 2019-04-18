//
//  GoldAlertView.h
//  DDGAPP
//
//  Created by ddgbank on 15/11/18.
//  Copyright © 2015年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCLabel.h"

@interface AlertButton : UIButton

typedef void (^ActionBlock)(void);

// Action Types
typedef NS_ENUM(NSInteger, SCLActionType)
{
    None,
    Selector,
    Block
};


@property SCLActionType actionType;

@property (nonatomic, copy) ActionBlock actionBlock;

@property (nonatomic, assign) BOOL showRed;
@property (nonatomic, assign) BOOL showMyColor;
@property (nonatomic, strong) UIColor*  myColor;


@property id target;

@property SEL selector;

@end


@interface CDWAlertView : UIViewController

/** Dismiss on tap outside
 *
 * A boolean value that determines whether to dismiss when tapping outside the SCLAlertView.
 * (Default = NO)
 */
@property (nonatomic, assign) BOOL shouldDismissOnTapOutside;
@property (nonatomic, assign) BOOL isBtnCenter;  // 按钮局中


@property (nonatomic, assign) RTTextAlignment textAlignment;  // 字体的方向

/** Hide SCLAlertView
 *
 * TODO
 */
- (void)hideView;

/** 增加当前Alert的高度
 *
 * TODO
 */
- (void) addAlertCurHeight:(CGFloat) fValue;

/** 降低当前Alert的高度
 *
 * TODO
 */
- (void) subAlertCurHeight:(CGFloat) fValue;

/** Add Button
 *
 * TODO
 */
- (AlertButton *)addButton:(NSString *)title red:(BOOL)showRed actionBlock:(ActionBlock)action;


/** Add Button
 *
 *   */
- (AlertButton *)addButton:(NSString *)title  color:(UIColor*)color actionBlock:(ActionBlock)action;

/** Add Button
 *
 * TODO
 */
- (AlertButton *)addCanelButton:(NSString *)title  actionBlock:(ActionBlock)action;




/** Add Button
 *
 * TODO
 */
//- (AlertButton *)addButton:(NSString *)title target:(id)target selector:(SEL)selector;

/** Show DDGAlertView
 *
 * TODO
 */
- (void)showAlertView:(UIViewController *)vc duration:(NSTimeInterval)duration;

-(void)addTitle:(NSString *)title;

-(void)addSubTitle:(NSString *)subTitle;

/** Add View
 *
 * TODO
 */
- (void ) addView:(UIView*) view   leftX:(int) leftX;



@end


