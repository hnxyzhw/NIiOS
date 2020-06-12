//
//  NSString+TextUtils.h
//  COMB
//
//  Created by dongyangyang on 17/1/19.
//  Copyright © 2017年 gengych. All rights reserved.
//

/**
 * 字符串为空校验
 */

#import <Foundation/Foundation.h>

@interface NSString (TextUtils)

/**
 * 检验字符串对象是否为空（nil, NSNull, @""）
 */
+(BOOL)isEmpty:(NSString *)stringValue;

/**
 判断字符串是否为空，为空则返回@""，反之返回原String

 @param stringValue 判断String
 @return 返回String
 */
+(NSString *)isEmptyCheckString:(NSString *)stringValue;

/**
 * 校验两个字符串是否相同
 */
+(BOOL)equals:(NSString*)str1 str2:(NSString*)str2;

/**
 * 校验字符串对象是否为 nil NSNULL 
 * return 是：返回 @"" 否：返回原数据
 */
+ (NSString *)isNullOrEmpty:(NSString*)str;

/**
 将空字符串转化成 @“0”，用于计算
 否则返回原数据
 */
+ (NSString *)formatForDecimalString:(NSString *)str;

/**
 将字符串添加千分符和保留小数两位

 @param text 要转化的字符串
 @return 转化后的字符串
 */
+ (NSString *)positiveFormat:(NSString *)text;

/**
 展示纯净的数字字符串

 @param str 带特殊符号的
 @return 数字字符串
 */
+ (NSString *)pureFloatString:(NSString *)str;

/**
 将字符串添加千分符

 @param money 字符串
 @return 字符串
 */
- (NSString *)moneyFormat:(NSString *)money;

/**
 去除字符串中的,逗号
 @param str 待去除的,逗号的目标字符串
 @return result(NSString*)
 */
+(NSString *)stringDeleteString:(NSString *)str;


@end
