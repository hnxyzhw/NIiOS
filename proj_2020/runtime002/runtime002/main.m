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

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSDictionary *dicTest = @{@"Name":@"飞翔",
                          @"Type":@"励志",
                          @"Des":@"我要飞翔追逐梦想！",
                          @"Motto":@"脚踏实地一步一个脚印！"
                          };
        NSLog(@"--%@",dicTest);
        
        MyGame *myGame = (MyGame*)[NSObject GG_initWithDictionaryForModel:dicTest];
        //NSLog(@"---Name:%@",myGame.Name);
        NSLog(@"---%zu",class_getInstanceSize(myGame));
        

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
 */




