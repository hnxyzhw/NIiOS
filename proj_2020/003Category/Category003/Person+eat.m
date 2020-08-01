//
//  Person+eat.m
//  Category003
//
//  Created by ai-nixs on 2020/7/31.
//  Copyright © 2020 nixs. All rights reserved.
//

#import "Person+eat.h"
#import <objc/runtime.h>

@implementation Person (eat)

/// 方法实现
-(void)NI_eat{
    NSLog(@"分类里的方法-我想吃饭了，好饿啊");
}

/// 属性的get方法
-(NSString *)name{
    return objc_getAssociatedObject(self, _cmd);
}

/// 属性的set方法
/// @param name name
-(void)setName:(NSString *)name{
    objc_setAssociatedObject(self, @selector(name), name, OBJC_ASSOCIATION_RETAIN);
}
@end
