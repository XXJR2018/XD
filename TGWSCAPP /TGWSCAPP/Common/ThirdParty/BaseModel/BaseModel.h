//
//  BaseModel.h
//  EVTUtils
//
//  Created by Cary on 13/11/13.
//  Copyright (c) 2013 EVT, Inc. All rights reserved.
//


/*
 * 数据解析状态
 */
typedef enum : NSUInteger {
    /*
     * 数据解析状态 - 未处理
     */
    BaseModelDataStateUnDefined,
    /*
     * 数据解析状态 - 成功
     */
    BaseModelDataStateRight,
    /*
     * 数据解析状态 - 失败
     */
    BaseModelDataStateWrong
} BaseModelDataState;

#import <Foundation/Foundation.h>

/*!
 @protocol  BaseModel
 @brief     BaseModel实现的协议
 */
@protocol BaseModel <NSObject>
/*!
 @brief     使用字典初始化一个实例
 @param     dict 包含初始化数据的字典
 @return    id BaseModel实例
 */
+ (id)instanceWithDict:(NSDictionary *)dict;
/*!
 @brief     使用字典初始化一个实例
 @param     dict 包含初始化数据的字典
 @return    id BaseModel实例
 */
- (id)initWithDict:(NSDictionary *)dict;
//- (id)initWithArray:(NSArray *)array;

/*!
 @brief     使用字典按照对应的映射字典初始化一个实例
 @param     dict 包含初始化数据的字典
 @param     mappingDict 字典数据key与实体属性之间的隐射字典
 @return    BaseModel实例
 */
- (id)initWithDict:(NSDictionary *)dict mapping:(NSDictionary *)mappingDict;

/*!
 @brief     传入指定的dictionary数组， 生成对应实体的数组
 @param     dictArray dictionary数组
 @return    视图数组
 */
+ (NSMutableArray *)modelArrayWithDictArray:(NSArray *)dictArray;
/*!
 @brief     将实体转为字典类型
 */
- (NSMutableDictionary *)dictionaryValue;
@end
/*!
 @class BaseModel
 @brief 所有实体类的基类
 */
@interface BaseModel : NSObject<BaseModel>

@property (nonatomic, assign) NSInteger rowId;

/*
 * 数据解析状态，记录是否成功
 **/
@property (nonatomic, assign) BaseModelDataState dataState;

@end
