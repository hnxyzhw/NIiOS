//
//  TestCycleRetain.m
//  BlockTestApp
//
//  Created by ChenMan on 2018/4/24.
//  Copyright © 2018年 cimain. All rights reserved.
//

#define TestCycleRetainCase1 1
//----------------------强弱引用----------------------------
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef strongify
#if DEBUG
#if __has_feature(objc_arc)
#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif

#import "TestCycleRetain.h"

@implementation TestCycleRetain

- (void) dealloc {
    NSLog(@"no cycle retain");
} 

- (id) init {
    self = [super init];
    if (self) {
        
#if TestCycleRetainCase1
        //会循环引用
        self.myblock = ^{
            [self doSomething];
        };
        
#elif TestCycleRetainCase2
        //会循环引用
        __block TestCycleRetain * weakSelf = self;
        self.myblock = ^{
            [weakSelf doSomething];
        };
        
#elif TestCycleRetainCase3
        //不会循环引用
        __weak TestCycleRetain * weakSelf = self;
        self.myblock = ^{
            [weakSelf doSomething];
        };
        
#elif TestCycleRetainCase4
        //不会循环引用
        __unsafe_unretained TestCycleRetain * weakSelf = self;
        self.myblock = ^{
            [weakSelf doSomething];
        };
        
#endif NSLog(@"myblock is %@", self.myblock);
    }
    return self;
} 

- (void) doSomething {
    NSLog(@"do Something");
    /**
     @weakify(self);
     [footerView setClickFooterBlock:^{
             @strongify(self);
             [self handleClickFooterActionWithSectionTag:section];
     }];
     */
}

@end
