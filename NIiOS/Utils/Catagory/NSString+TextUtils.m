//
//  NSString+TextUtils.m
//  COMB
//
//  Created by dongyangyang on 17/1/19.
//  Copyright © 2017年 gengych. All rights reserved.
//

#import "NSString+TextUtils.h"

@implementation NSString (TextUtils)

+(BOOL)isEmpty:(NSString *)stringValue
{
    // add checking for NSNull scenario.
    BOOL isNSNull = NO;
    if (!stringValue
        || (isNSNull = [stringValue isKindOfClass:[NSNull class]])
        || [stringValue isEqualToString:@""]
        || [stringValue isEqualToString:@"(null)"]) {
        
        if (isNSNull) {
            NSLog(@"TextUtils, isEmpty, string is NSNull object");
        }
        return YES;
    }
    //add by:nixs 2018年12月28日
    if ([[stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {//这种情况说明字符串有中是空格键
        return YES;
    }
    return NO;
}

+(NSString *)isEmptyCheckString:(NSString *)stringValue {
    
    if ([NSString isEmpty:stringValue]) {
        return @"";
    }else{
        return stringValue;
    }
}

+(BOOL)equals:(NSString*)str1 str2:(NSString*)str2 {
    if (str1 == nil && str2 == nil) {
        return YES;
    }
    if (str1 == nil || str2 == nil) {
        return NO;
    }
    return [str1 isEqualToString:str2];
}

+ (NSString *)isNullOrEmpty:(NSString*)str
{
    if ([str isKindOfClass:[NSNull class]] || str == nil || [str isEqualToString:@""] || [str isEqualToString:@"(null)"]) {
        return @"";
    }
    return str;
}

+ (NSString *)formatForDecimalString:(NSString *)str {
    NSString * string = [self isNullOrEmpty:str];
    if ([@"" isEqualToString:string]) {
        return @"0.0";
    }
    
    return string;
}

+ (NSString *)positiveFormat:(NSString *)text{    
    if(!text || [text floatValue] == 0){
        return @"0.00";
    }else if (text.floatValue < 1000) {
        return  [NSString stringWithFormat:@"%.2f",text.floatValue];
    }else if([[text substringToIndex:2] isEqualToString:@"0."]) {
        return text;
    }else{
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setPositiveFormat:@",###.00;"];
        return [numberFormatter stringFromNumber:[NSNumber numberWithDouble:[text doubleValue]]];
    }
    return @"";
}

- (NSString *)stringFormatToThreeBit:(NSString *)string{
    if (string.length <= 0) {
        return @"".mutableCopy;
    }
    NSString *tempRemoveD = [string stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSMutableString *stringM = [NSMutableString stringWithString:tempRemoveD];
    NSInteger n = 2;
    for (NSInteger i = tempRemoveD.length - 3; i > 0; i--) {
        n++;
        if (n == 3) {
            [stringM insertString:@"," atIndex:i];
            n = 0;
        }
    }
    
    return stringM;
}

- (NSString *)moneyFormat:(NSString *)money{
    NSArray *moneys = [money componentsSeparatedByString:@"."];
    if (moneys.count > 2) {
        return money;
    }
    else if (moneys.count < 2) {
        return [self stringFormatToThreeBit:money];
    }
    else {
        NSString *frontMoney = [self stringFormatToThreeBit:moneys[0]];
        if([frontMoney isEqualToString:@""]){
            frontMoney = @"0";
        }
        return [NSString stringWithFormat:@"%@.%@", frontMoney,moneys[1]];
    }
}

+ (NSString *)pureFloatString:(NSString *)str {
    NSString *cashString = [str
                            stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    NSString *lastCashString = [cashString
                                stringByReplacingOccurrencesOfString:@"," withString:@""];
    return lastCashString;
    
}

+(NSString *)stringDeleteString:(NSString *)str
{
    NSMutableString *str1 = [NSMutableString stringWithString:str];
    for (int i = 0; i < str1.length; i++) {
        unichar c = [str1 characterAtIndex:i];
        NSRange range = NSMakeRange(i, 1);
        if ( c == ',') {  //c 是字符 ，不能用 isEqualToString 这个方法，只能用  == ''   我这里是要把字符串中的“,”删掉
            [str1 deleteCharactersInRange:range];
            --i;
        }
    }
    NSString *newstr = [NSString stringWithString:str1];
    return newstr;
}

@end
