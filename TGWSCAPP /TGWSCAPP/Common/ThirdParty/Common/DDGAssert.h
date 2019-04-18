//
//  PDAssert.h
//  EVTUtils
//
//  Created by well xeon on 15/11/12.
//  Copyright (c) 2012 Paidui, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @brief 断言， 调试模式下有效, nimbus
 */
#ifdef DEBUG

#import <TargetConditionals.h>

extern BOOL DDGBeingDebugged(void);

#if TARGET_IPHONE_SIMULATOR
// We leave the __asm__ in this macro so that when a break occurs, we don't have to step out of
// a "breakInDebugger" function.
#define DDGASSERT(xx) { if (!(xx)) { DDGVerboseLog(@"PDASSERT failed: %s", #xx); \
if (DDGBeingDebugged()) { __asm__("int $3\n" : : ); } } \
} ((void)0)
#else

#define DDGASSERT(xx) { if (!(xx)) { DDGVerboseLog(@"PDASSERT failed: %s", #xx); \
if (DDGBeingDebugged()) { raise(SIGTRAP); } } \
} ((void)0)
#endif // #if TARGET_IPHONE_SIMULATOR

#else

#define DDGASSERT(xx) ((void)0)

#endif // #ifdef DEBUG

