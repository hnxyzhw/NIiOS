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


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
        
        //获取类
        Class personClass = object_getClass([Person class]);
        NSLog(@"---获取类:%@",personClass);
        
        //SEL是selector在Objc中的表示：
        SEL oriSEL = @selector(main);
        //NSLog(@"---SEL是selector在Objc中的表示:%@",oriSEL);
        
        //
        
        
    }
    return 0;
}





