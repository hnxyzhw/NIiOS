//
//  main.m
//  runtime002
//
//  Created by nixs on 2020/7/15.
//  Copyright © 2020 nixs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "MyGame.h"
#import "NSObject+ThreegModel.h"

//遍历获取所有属性Property
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSDictionary *dicTest = @{@"Name":@"飞翔",
                          @"Type":@"励志",
                          @"Des":@"我要飞翔追逐梦想！",
                          @"Motto":@"脚踏实地一步一个脚印！"
                          };
        NSLog(@"--%@",dicTest);
                
        unsigned int count;
        //获取属性列表
//        objc_property_t *propertyList = class_copyPropertyList([Person class], &count);
//        for (unsigned int i=0; i<count; i++) {
//            const char *propertyName = property_getName(propertyList[i]);
//            NSLog(@"property---->%@", [NSString stringWithUTF8String:propertyName]);
//        }
        //获取方法列表
//        Method *methodList = class_copyMethodList([Person class], &count);
//        for (unsigned int i; i<count; i++) {
//            Method method = methodList[i];
//            NSLog(@"method---->%@", NSStringFromSelector(method_getName(method)));
//        }
        //获取成员变量列表
//        Ivar *ivarList = class_copyIvarList([Person class], &count);
//        for (unsigned int i; i<count; i++) {
//            Ivar myIvar = ivarList[i];
//            const char *ivarName = ivar_getName(myIvar);
//            NSLog(@"Ivar---->%@", [NSString stringWithUTF8String:ivarName]);
//        }
        //获取协议列表
        __unsafe_unretained Protocol **protocolList = class_copyProtocolList([Person class], &count);
        NSLog(@"---获取协议列表:%d",count);
        for (unsigned int i; i<count; i++) {
            Protocol *myProtocal = protocolList[i];
            const char *protocolName = protocol_getName(myProtocal);
            NSLog(@"protocol---->%@", [NSString stringWithUTF8String:protocolName]);
        }
        
    }
    return 0;
}
/*
 // insert code here...
 NSLog(@"Hello, World!");
 
 //获取类
 Class personClass = object_getClass([Person class]);
 NSLog(@"---获取类:%@",personClass);
 
 //SEL是selector在Objc中的表示：
 SEL oriSEL = @selector(main);
 //NSLog(@"---SEL是selector在Objc中的表示:%@",oriSEL);
 
 //objc_msgSend()
 
 MyGame *myGame = (MyGame*)[NSObject GG_initWithDictionaryForModel:dicTest];
 //NSLog(@"---Name:%@",myGame.Name);
 //NSLog(@"---%zu",class_getInstanceSize(myGame));
 //[myGame getAllProperty];
 objc_property_attribute_t nonatomic = {"N", ""};
 objc_property_attribute_t strong = {"&", ""};
 objc_property_attribute_t type = {"T", "@\"NSString\""};
 objc_property_attribute_t ivar = {"V", "_name"};
 objc_property_attribute_t attributes[] = {nonatomic, strong, type, ivar};
 BOOL result = class_addProperty([Person class], "name", attributes, 4);
 //NSLog(@"---%@",result);
 */




