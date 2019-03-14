//
//  NSObject+NIDataFromJsonFile.h
//  NIiOS
//
//  Created by ai-nixs on 2018/11/19.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 目标文件里存储字符串json类型 by:nixs
 */
typedef NS_ENUM(NSInteger,jsonDataType){
    jsonArray = 0, //目标json串为-数组
    jsonDictionary = 1 //目标json串为-字典
};

/**
 读取文件里json字符串 NIDataFromJsonFile 分类
 */
@interface NSObject (NIDataFromJsonFile)

/**
 读取文件里json串数据 by:nixs
 
 @param jsonFileName 本地json文件名称
 @param jsonDataType json文件里json串类型(数组 or 字典)
 @return 读取结果(NSArray or NSDictionary)
 */
+(instancetype)NIDataFromJsonFileName:(NSString*)jsonFileName andDataType:(jsonDataType)jsonDataType;

/**
 据json配置文件名称求数组
 
 @param jsonFileName 文件名称
 @return NSArray
 */
+(NSArray*)NIArrayFromJsonFileName:(NSString*)jsonFileName;

/**
 据json配置文件名称求字典
 
 @param jsonFileName 文件名称
 @return NSDictionary
 */
+(NSDictionary*)NIDictionaryFromJSONFileName:(NSString*)jsonFileName;

/**
 读取txt文件内容(注:XXX.txt文件内容换行就只能读取第一行数据了)

 @param fileName txt文件内容
 @return txt文件内容里的字符串
 */
+(NSString*)NIDataFromFileName:(NSString*)fileName;

@end
