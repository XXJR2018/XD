//
//  Enums.h
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

/*!
 @brief 枚举定义
 */
#ifndef DDGUtils_Enums_h
#define DDGUtils_Enums_h

typedef NS_ENUM(NSUInteger, CellLineType){
    CellLineTypeMiddle,
    CellLineTypeUp,
    CellLineTypeDown
};

/*!
 @brief 题目类型
 */
typedef NS_ENUM(NSUInteger, TitleType)
{
    /*!
     @brief
     */
    TitleType1 = 0,
    /**
     @brief 英语题
     */
    TitleType2
};

#endif
