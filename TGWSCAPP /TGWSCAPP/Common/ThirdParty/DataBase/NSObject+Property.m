//
//  NSObject+Property.m
//   
//
//  Created on 12-12-15.
//
//

#import "NSObject+Property.h"
#import <objc/runtime.h>

NSString *_getPropertyStr(char *str)
{
    if (str == NULL) return @"";
    NSString *resultString = @(str);
    if ([resultString rangeOfString:@"."].location == NSNotFound)
        return resultString;
    return [resultString componentsSeparatedByString:@"."][1];
}

@implementation NSObject (Property)

 
- (NSArray *)getPropertyList
{
    return [self getPropertyList:[self class]];
}

- (NSArray *)getPropertyList: (Class)clazz
{
    NSMutableArray *propertyList = [[NSMutableArray alloc] init];
    while (clazz)
    {
        //如果超类为BaseModel,则直接返回该类的属性，不获取BaseModel的属性
        if ([NSStringFromClass(clazz) isEqualToString:@"BaseModel"])
        {
            return propertyList;
        }
        u_int count;
        objc_property_t *properties  = class_copyPropertyList(clazz, &count);
        NSMutableArray *propertyArray = [NSMutableArray arrayWithCapacity:count];
        
        for (int i = 0; i < count ; i++)
        {
            const char* propertyName = property_getName(properties[i]);
            [propertyArray addObject: [NSString  stringWithUTF8String: propertyName]];
        }
        
        free(properties);
        clazz = [clazz superclass];
        [propertyList addObjectsFromArray:propertyArray];
    }
    return propertyList;
}

- (NSString *)typeClassName:(NSString *)propertyName
{
    const char * type = property_getAttributes(class_getProperty([self class], [[propertyName lowercaseFirstString] UTF8String]));
    NSLog(@"type is %s",type);
    NSString * typeString = [NSString stringWithUTF8String:type];
    NSArray * attributes = [typeString componentsSeparatedByString:@","];
    NSString * typeAttribute = [attributes objectAtIndex:0];
    NSString * propertyType = [typeAttribute substringFromIndex:1];
    const char * rawPropertyType = [propertyType UTF8String];
    
    if ([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1)
    {
        return [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];
    }
    if (strcmp(rawPropertyType, @encode(BOOL)) == 0)
    {
        return @"BOOL";
    }
    if (strcmp(rawPropertyType, @encode(int)) == 0)
    {
        return @"int";
    }
    if (strcmp(rawPropertyType, @encode(float)) == 0)
    {
        return @"float";
    }
    if (strcmp(rawPropertyType, @encode(double)) == 0)
    {
        return @"double";
    }
    if (strcmp(rawPropertyType, @encode(id)))
    {
        return @"id";
    }
    if (strcmp(rawPropertyType, @encode(long)) == 0)
    {
        return @"long";
    }
    if (strcmp(rawPropertyType, @encode(long long)) == 0)
    {
        return @"long long";
    }
    if (strcmp(rawPropertyType, @encode(unsigned long long)) == 0)
    {
        return @"unsigned long long";
    }
    return @"";
}

@end
