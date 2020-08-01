//
//  UIViewController+Tag.m
//  runtime001
//
//  Created by nixs on 2020/6/12.
//  Copyright © 2020 nixs. All rights reserved.
//

#import "UIViewController+Tag.h"
#import <objc/runtime.h>

static void *tag = &tag;

@implementation UIViewController (Tag)

- (void)setTag:(NSString *)tag{
    objc_setAssociatedObject(self, &tag, tag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)tag{
    return objc_getAssociatedObject(self, &tag);
}

@end
