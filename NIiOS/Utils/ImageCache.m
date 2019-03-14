
//
//  ImageCache.m
//  NIiOS
//
//  Created by nixs on 2019/1/14.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "ImageCache.h"

@interface ImageCache()
@property (nonatomic, strong) NSMutableDictionary *imageCashDic;
@end

@implementation ImageCache

+ (instancetype)shareInstance {
    static ImageCache * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ImageCache alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.imageCashDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return self;
}

- (id)getCacheImage: (NSString *)key {
    id object = [self.imageCashDic objectForKey:key];
    if (object == nil) {
        object = [UIImage imageNamed:key];
        if (object != nil) {
            [self.imageCashDic setObject:object forKey:key];
        }
    }
    return object;
}

- (id)getCacheYYImage: (NSString *)key {
    NSString *yyKey = [key stringByAppendingString:@"YY"];
    id object = [self.imageCashDic objectForKey:yyKey];
    if (object == nil) {
        object = [YYImage imageNamed:key];
        if (object != nil) {
            [self.imageCashDic setObject:object forKey:yyKey];
        }
    }
    return object;
}

@end
