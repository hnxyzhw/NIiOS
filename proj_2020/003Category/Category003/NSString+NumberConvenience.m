//
//  NSString+NumberConvenience.m
//  Category003
//
//  Created by ai-nixs on 2020/7/31.
//  Copyright © 2020 nixs. All rights reserved.
//

#import "NSString+NumberConvenience.h"

@implementation NSString (NumberConvenience)
-(NSNumber *)lengthAsNumber{
    NSUInteger length =[self length];
    return ([NSNumber numberWithUnsignedInt:length]);
}

@end
