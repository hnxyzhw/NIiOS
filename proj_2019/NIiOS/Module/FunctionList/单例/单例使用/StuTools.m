//
//  StuTools.m
//  NIiOS
//
//  Created by ai-nixs on 2018/12/6.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "StuTools.h"

@interface StuTools()<NSCopying,NSMutableCopying>

@end

@implementation StuTools

static StuTools *_stuTool = nil;
//第一次调用该类时调用
+(void)initialize{
    [self sharedInstance];
}
//初始化对象
+(instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _stuTool = [[self alloc] init];
    });
    return _stuTool;
}
//重写alloc，判断对象是否是否已经初始化,若已经初始化,就用原来的；若没有就初始化一个。只有第一次调用该类时候，才会创建；
+(instancetype)alloc{
    if (_stuTool) {
        return _stuTool;
    }
    return [super alloc];
}
-(id)copyWithZone:(NSZone *)zone{
    return [StuTools sharedInstance];
}
-(id)mutableCopyWithZone:(NSZone *)zone{
    return [StuTools sharedInstance];
}

+ (void)clean {
    [StuTools sharedInstance].stuModel = nil;
}

@end
