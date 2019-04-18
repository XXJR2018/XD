//
//  IdentifyAlertView.h
//  XXJR
//
//  Created by xxjr02 on 2017/11/1.
//  Copyright © 2017年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdentifyAlertView : UIView

@property (strong,nonatomic) UIViewController  *parentVC;
@property (strong,nonatomic) NSString   *strPhone;
@property (strong,nonatomic) NSString   *strRequestURL;




//  初始化
-(instancetype)initWithTitle:(NSString *) title  CancelButton:(NSString *)cancelButton OkButton:(NSString *)okButton;

- (void)show;

@end
