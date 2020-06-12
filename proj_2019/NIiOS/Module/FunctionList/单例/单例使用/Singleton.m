//
//  Singleton.m
//  NIiOS
//
//  Created by ai-nixs on 2018/12/7.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "Singleton.h"

@interface Singleton()<NSCopying,NSMutableCopying>

@end

static Singleton *_instance = nil;
@implementation Singleton

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+(instancetype)sharedInstance{
    if (_instance==nil) {
        _instance = [[super alloc] init];
    }
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

@end


