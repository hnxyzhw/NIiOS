//
//  UIImage+Tools.m
//  NIiOS
//
//  Created by nixs on 2019/2/28.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "UIImage+Tools.h"
#import <objc/runtime.h>

@implementation UIImage (Tools)

/**
 set方法
 */
-(void)setUrlString:(NSString *)urlString{
    objc_setAssociatedObject(self, @selector(urlString), urlString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/**
 get方法
 */
-(NSString*)urlString{
    return objc_getAssociatedObject(self, @selector(urlString));
}

/**
 添加一个自定义方法,用于清除所有关联属性
 */
-(void)clearAssociatedObject{
    objc_removeAssociatedObjects(self);
}

@end
