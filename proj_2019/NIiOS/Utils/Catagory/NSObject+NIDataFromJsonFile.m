//
//  NSObject+NIDataFromJsonFile.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/19.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "NSObject+NIDataFromJsonFile.h"

@implementation NSObject (NIDataFromJsonFile)
+(instancetype)NIDataFromJsonFileName:(NSString*)jsonFileName andDataType:(jsonDataType)jsonDataType{
    switch (jsonDataType) {
        case jsonArray:{
            NSArray* arrayData = [NSArray array];
            //可以放到数据源的懒加载中
            NSURL* url = [[NSBundle mainBundle] URLForResource:jsonFileName withExtension:nil];
            //加载json文件
            NSData* data = [NSData dataWithContentsOfURL:url];
            arrayData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            return arrayData;
            break;
        }
        case jsonDictionary:{
            NSDictionary* dicData = [NSDictionary dictionary];
            //可以放到数据源的懒加载中
            NSURL* url = [[NSBundle mainBundle] URLForResource:jsonFileName withExtension:nil];
            //加载json文件
            NSData* data = [NSData dataWithContentsOfURL:url];
            dicData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            return dicData;
            break;
        }
        default:
            break;
    }
}
+(NSArray*)NIArrayFromJsonFileName:(NSString*)jsonFileName{
    NSArray* arrayData = [NSArray array];
    //可以放到数据源的懒加载中
    NSURL* url = [[NSBundle mainBundle] URLForResource:jsonFileName withExtension:nil];
    //加载json文件
    NSData* data = [NSData dataWithContentsOfURL:url];
    arrayData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return arrayData;
}
+(NSDictionary*)NIDictionaryFromJSONFileName:(NSString*)jsonFileName{
    NSDictionary* dicData = [NSDictionary dictionary];
    //可以放到数据源的懒加载中
    NSURL* url = [[NSBundle mainBundle] URLForResource:jsonFileName withExtension:nil];
    //加载json文件
    NSData* data = [NSData dataWithContentsOfURL:url];
    dicData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return dicData;
}
+(NSString*)NIDataFromFileName:(NSString*)fileName{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return content;
}


@end
