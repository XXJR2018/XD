//
//  DDGUser.m
//  DDGUtils
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import "DDGUser.h"

@implementation DDGUser


- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

/**
 *  从文件中解析对象的时候调
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.realName = [decoder decodeObjectForKey:kRealName];
        self.uid = [decoder decodeObjectForKey:kUser_ID];
        //账号密码
        self.mobile = [decoder decodeObjectForKey:kMobile];
        self.passWord = [decoder decodeObjectForKey:kPassword];
       
       
        
        
    }
    return self;
}

/**
 *  将对象写入文件的时候调用
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.realName forKey:kRealName];
    [encoder encodeObject:self.uid forKey:kUser_ID];
    //账号密码
    [encoder encodeObject:self.mobile forKey:kMobile];
    [encoder encodeObject:self.passWord forKey:kPassword];
       
    
    
    
    
}

@end
