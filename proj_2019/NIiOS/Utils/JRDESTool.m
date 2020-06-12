//
//  JRDESTool.m
//  Pos
//
//  Created by ai-nixs on 2018/9/21.
//  Copyright © 2018年 Shy. All rights reserved.
//

#import "JRDESTool.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation JRDESTool

/*字符串加密
 *参数
 *plainText : 加密明文
 *key        : 密钥 64位
 */
+ (NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    const char *textBytes = [plainText UTF8String];
    NSUInteger dataLength = [plainText length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    Byte iv[] = {1,2,3,4,5,6,7,8};
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          textBytes, dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        
        ciphertext = [self encodeData:data];
    }
    return ciphertext;
}

//解密
+ (NSString *) decryptUseDES:(NSString*)cipherText key:(NSString*)key
{
    NSData* cipherData = [self decodeString:cipherText];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    Byte iv[] = {1,2,3,4,5,6,7,8};
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          iv,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          1024,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return plainText;
}

+ (NSString *)encodeData:(NSData *)originData{
    
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    //    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return encodeResult;
}
+ (NSData *)decodeString:(NSString *)encodeResult{
    
    NSData* decodeData = [[NSData alloc] initWithBase64EncodedString:encodeResult options:0];
    //    NSString* decodeStr = [[NSString alloc] initWithData:decodeData encoding:NSASCIIStringEncoding];
    return decodeData;
}

//---------------------
//
//本文来自 最后的轻羽 的CSDN 博客 ，全文地址请点击：https://blog.csdn.net/gwh111/article/details/52502811?utm_source=copy
@end
