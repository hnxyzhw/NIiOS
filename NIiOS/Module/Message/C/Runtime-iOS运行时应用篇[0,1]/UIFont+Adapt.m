//
//  UIFont+Adapt.m
//  NIiOS
//
//  Created by nixs on 2019/2/28.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "UIFont+Adapt.h"

@implementation UIFont (Adapt)
+(UIFont *)zs_systemFontOfSize:(CGFloat)fontSize{
    //获取设备屏幕宽度,并计算出比例scale
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat scale = width/375.0;
    //注意：由于方法交换,系统的方法名已经变化才能了自定义的方法名,所以这里使用了自定义的方法名来获取UIFont
    return [UIFont zs_systemFontOfSize:fontSize*scale];
}

/**
 load方法不需要手动调用,iOS会在应用程序启动的时候自动调用load方法，而且执行时间较早,所以在此方法中执行交换操作比较合适
 */
+(void)load{
    //获取系统方法地址
    Method systemMethod = class_getClassMethod([UIFont class], @selector(systemFontOfSize:));
    //获取自定义方法地址
    Method customMethod = class_getClassMethod([UIFont class], @selector(zs_systemFontOfSize:));
    //交换两个方法的实现
    method_exchangeImplementations(systemMethod, customMethod);
}
@end
