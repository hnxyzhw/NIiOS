//
//  Person.m
//  006Runtime
//
//  Created by nixs on 2020/8/5.
//  Copyright © 2020 nixs. All rights reserved.
//

#import "Person.h"
#import "NSObject+Extension.h"
@implementation Person
+(void)run{
    NSLog(@"跑");
}
+(void)study{
    NSLog(@"学习");
}
// 设置需要忽略的属性
- (NSArray *)ignoredNames {
    return @[@"bone"];
}

// 在系统方法内来调用我们的方法
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        [self decode:aDecoder];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self encode:aCoder];
}

@end
