//
//  NSObject+Category.m
//  006Runtime
//
//  Created by nixs on 2020/8/5.
//  Copyright © 2020 nixs. All rights reserved.
//

#import "NSObject+Category.h"
#import <objc/runtime.h>

@implementation NSObject (Category)

char nameKey;

-(void)setName:(NSString *)name{
    //将某个值跟某个对象关联起来，将某个值存储到某个对象中
    objc_setAssociatedObject(self, &nameKey, name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)name{
    return objc_getAssociatedObject(self, &nameKey);
}

// 设置不需要归解档的属性
- (NSArray *)ignoredNames {
    return @[@"_aaa",@"_bbb",@"_ccc"];
}

@end
