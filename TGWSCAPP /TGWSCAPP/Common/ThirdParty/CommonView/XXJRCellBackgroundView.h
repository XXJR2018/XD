//
//  DDGCellBackgroundView.h
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @brief     <#abstract#>
 */
typedef enum
{
    CellBackgroundViewPositionSingle = 0,
    CellBackgroundViewPositionTop,
    CellBackgroundViewPositionBottom,
    CellBackgroundViewPositionMiddle
} CellBackgroundViewPosition;


@interface XXJRCellBackgroundView : UIView

/*!
 @property  <#class#> <#name#>
 @brief     <#abstract#>
 */
@property (nonatomic, assign) CellBackgroundViewPosition position;

/*!
 @property  <#class#> <#name#>
 @brief     <#abstract#>
 */
@property (nonatomic) BOOL isSelectedView;

/*!
 @property  <#class#> <#name#>
 @brief     <#abstract#>
 */
+ (XXJRCellBackgroundView *)backgroundView;
/*!
 @property  <#class#> <#name#>
 @brief     <#abstract#>
 */
+ (XXJRCellBackgroundView *)backgroundViewIsSelectedView:(BOOL)isSeleced;


@end
