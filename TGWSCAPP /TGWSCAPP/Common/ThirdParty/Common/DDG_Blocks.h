//
//  DDG_Blocks.h
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#ifndef DDGUtils_DDG_Blocks_h
#define DDGUtils_DDG_Blocks_h

#import <UIKit/UIKit.h>
typedef void (^Block_View)(UIView *view);

typedef void (^Block_Void)(void);

typedef void (^Block_Bool)(BOOL yesOrNo);

typedef void (^Block_Id)(id obj);

typedef void (^Block_Id_Int)(id obj,int index);

typedef void  (^Block_Int)(int index);

typedef void (^Block_String)(NSString *string);

typedef void (^Block_Tap)(int);

#endif
