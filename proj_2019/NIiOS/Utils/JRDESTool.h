//
//  JRDESTool.h
//  Pos
//
//  Created by ai-nixs on 2018/9/21.
//  Copyright © 2018年 Shy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRDESTool : NSObject

/**
 加密

 @param plainText 待加密字符串
 @param key key
 @return 加密后字符串
 */
+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;

/**
 解密
 
 @param cipherText 待加密字符串
 @param key key
 @return 解密后字符串
 */
+ (NSString *) decryptUseDES:(NSString*)cipherText key:(NSString*)key;

@end
