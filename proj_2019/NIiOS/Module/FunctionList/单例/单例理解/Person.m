//
//  Person.m
//  NIiOS
//
//  Created by ai-nixs on 2018/12/6.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "Person.h"

@interface Person()<NSCopying,NSMutableCopying>

@end

@implementation Person

+(instancetype)sharedInstance{
    return [[self alloc] init];
}
-(instancetype)init{
    if (self=[super init]) {
        
    }
    return self;
}

/**
 重写allocWithZone 保证创建对象分配的内存是同一个
 */
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static Person *p = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        p = [super allocWithZone:zone];
    });
    return p;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [Person sharedInstance];
}

- (nonnull id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [Person sharedInstance];
}

//static Person *_p;
//+(instancetype)sharedOneTimeClass{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _p = [[Person alloc] init];
//    });
//    return _p;
//}





@end
