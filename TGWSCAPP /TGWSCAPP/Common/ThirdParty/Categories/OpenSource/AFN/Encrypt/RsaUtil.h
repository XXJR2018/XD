//
//  IOS使用OpenSSL 生成的公私玥字符串进行RSA加解密
//  RsaUtil.h
//
//  Created by kokjuis on 16/8/19.
//
//

#import <Foundation/Foundation.h>

@interface RsaUtil : NSObject


/*
 注意，RSA加解密的特征是：公钥加密->私钥解密、私钥加密->公钥解密。
 */


// return base64 encoded string
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey;
// return raw data
+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey;
// return base64 encoded string
+ (NSString *)encryptString:(NSString *)str privateKey:(NSString *)privKey;
// return raw data
+ (NSData *)encryptData:(NSData *)data privateKey:(NSString *)privKey;

// decrypt base64 encoded string, convert result to string(not base64 encoded)
+ (NSString *)decryptString:(NSString *)str publicKey:(NSString *)pubKey;
+ (NSData *)decryptData:(NSData *)data publicKey:(NSString *)pubKey;
+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;
+ (NSData *)decryptData:(NSData *)data privateKey:(NSString *)privKey;


// 16进制编码, 字符串加密
+ (NSString *)encrypt16String:(NSString *)str publicKey:(NSString *)pubKey;

// 16进制编码, 字符串解密
+ (NSString *)decrypt16String:(NSString *)str privateKey:(NSString *)privKey;

@end


