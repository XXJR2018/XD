//
//  CustomerServiceManager.h
//  XXJR
//
//  Created by Cary on 16/1/8.
//  Copyright © 2016年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CustomerServiceViewTag  89880

@interface CustomerServiceManager : NSObject

//+(CustomerServiceManager *)shareManager;

+(void)showServiceView:(UIViewController *)viewController name:(NSString *)name phone:(NSString *)phone;

@end
