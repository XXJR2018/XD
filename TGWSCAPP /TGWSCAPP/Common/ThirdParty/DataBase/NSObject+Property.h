//
//  NSObject+Property.h
//   
//
//  Created on 12-12-15.
//
//


FOUNDATION_EXPORT NSString *_getPropertyStr(char *str);

#define PropertyStr(aa) _getPropertyStr(#aa)

@interface NSObject (Property)
/*!
 @brief     获得对象的所有属性
 */
- (NSArray *)getPropertyList;
/*!
 @brief     获得对象的所有属性
 @prama     clazz 对应的实体类
 */
- (NSArray *)getPropertyList: (Class)clazz;
/*!
 @brief     获得对应属性名的属性类型
 @prama     propertyName 属性名
 */
- (NSString *)typeClassName:(NSString *)propertyName;

@end
