//
//  NSObject+ThreegModel.m
//  runtime002
//
//  Created by ai-nixs on 2020/7/20.
//  Copyright © 2020 nixs. All rights reserved.
//

#import "NSObject+ThreegModel.h"

@implementation NSObject (ThreegModel)
+(instancetype)GG_initWithDictionaryForModel:(NSDictionary *)dic{
    id myObj = [[self alloc]init];
    unsigned int outCount;
    //获取类中所有成员属性
    objc_property_t *arrPropertys = class_copyPropertyList([self class], &outCount);
    for (int i=0; i<outCount; i++) {
        //获取属性名字符串
        objc_objectptr_t property = arrPropertys[i];
        //model中的属性名
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        id propertyValue = dic[propertyName];
        if (propertyValue!=nil) {
            [myObj setValue:propertyValue forKey:propertyName];
        }
    }
    //注意runtime获取属性的时候，并不是ARC Object-C的对象所有需要释放
    free(arrPropertys);
    return myObj;
}

-(void)getAllProperty{
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList([Person class], &propertyCount);
    for (unsigned int i = 0; i < propertyCount; i++ ) {
        objc_property_t *thisProperty = propertyList[i];
        const char* propertyName = property_getName(*thisProperty);
        NSLog(@"Person拥有的属性为: '%s'", propertyName);
    }
}
@end
