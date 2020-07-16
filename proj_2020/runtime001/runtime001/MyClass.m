//
//  MyClass.m
//  runtime001
//
//  Created by nixs on 2020/7/15.
//  Copyright © 2020 nixs. All rights reserved.
//

#import "MyClass.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation MyClass
+(BOOL)resolveInstanceMethod:(SEL)aSEL{
    if (aSEL == @selector(resolveThisMethodDynamically)) {
        //class_addMethod([self class], aSEL, (IMP)dynamicMethodIMP, @"v@:")
        return YES;
    }
    return [super resolveInstanceMethod:aSEL];
}
@end
