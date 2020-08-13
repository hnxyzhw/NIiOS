//
//  CaculateMaker.h
//  BlockTestApp
//
//  Created by ai-nixs on 2020/8/3.
//  Copyright © 2020 cimain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CaculateMaker : NSObject
@property(nonatomic,assign) CGFloat result;
//简单使用链式编程思想实现一个简单计算器的功能
-(CaculateMaker*(^)(CGFloat num))add;

@end

NS_ASSUME_NONNULL_END
