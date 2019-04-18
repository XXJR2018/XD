//
//  WCAlertview.h
//  WCAlertView
//
//  Created by huangwenchen on 15/2/17.
//  Copyright (c) 2015年 huangwenchen. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WCALertviewDelegate<NSObject>
@optional
-(void)didClickButtonAtIndex:(NSUInteger)index;

@end

@interface WCAlertview : UIView
@property (weak,nonatomic) id<WCALertviewDelegate> delegate;

-(instancetype)initWithTitle:(NSString *) title Image:(UIImage *)image OkButton:(NSString *)okButton CancelButton:(NSString *)cancelButton;


-(instancetype)initWithTitle:(NSString *) title Message:(NSString*)message  Image:(UIImage *)image OkButton:(NSString *)okButton CancelButton:(NSString *)cancelButton;

-(instancetype)initWithTitle:(NSString *) title Message:(NSString*)message OkButton:(NSString *)okButton CancelButton:(NSString *)cancelButton;

- (void)show;

@property (strong,nonatomic)NSString * strVerion;
@end
