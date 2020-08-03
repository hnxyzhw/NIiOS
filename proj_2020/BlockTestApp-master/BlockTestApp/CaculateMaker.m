
//
//  CaculateMaker.m
//  BlockTestApp
//
//  Created by ai-nixs on 2020/8/3.
//  Copyright © 2020 cimain. All rights reserved.
//

#import "CaculateMaker.h"

@implementation CaculateMaker
-(CaculateMaker*(^)(CGFloat num))add{
    return ^CaculateMaker*(CGFloat num){
        _result+=num;
        return self;
    };
}
@end
