//
//  Encryption.h
//  RSA
//
//  Created by Cary on 14/12/31.
//  Copyright (c) 2014年 Cary. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSString;

@interface NSData (Encryption)

- (NSData *)AES256EncryptWithKey:(NSString *)key;   //加密

- (NSData *)AES256DecryptWithKey:(NSString *)key;   //解密

@end
