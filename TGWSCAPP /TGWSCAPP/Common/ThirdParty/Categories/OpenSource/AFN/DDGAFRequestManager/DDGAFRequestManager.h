//
//  DDGAFRequestManager.h
//  DDGUtils
//
//  Created by Cary on 15/1/5.
//  Copyright (c) 2015年 Cary. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface DDGAFRequestManager : AFHTTPRequestOperationManager

/**
 *  超时时间
 */
@property NSTimeInterval timeoutInterval;


/**
 *  取消请求
 */
-(void)cancelRequest;

@end
