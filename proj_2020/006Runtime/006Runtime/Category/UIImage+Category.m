//
//  UIImage+Category.m
//  006Runtime
//
//  Created by nixs on 2020/8/5.
//  Copyright © 2020 nixs. All rights reserved.
//

#import "UIImage+Category.h"
#import <objc/runtime.h>

@implementation UIImage (Category)
+(UIImage*)NI_imageNamed:(NSString*)name{
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (version>=7.0) {
        //如果系统版本是7.0以上，使用另外一套文件名结尾是‘_os7’的扁平化图片
        name = [name stringByAppendingString:@"_os7"];
        NSLog(@"---使用扁平化图片---");
    }
    return [UIImage NI_imageNamed:name];
}

+(void)load{
    //获取两个类的类方法
    Method m1 = class_getClassMethod([UIImage class], @selector(imageNamed:));
    Method m2 = class_getClassMethod([UIImage class], @selector(NI_imageNamed:));
    //开始交换方法实现
    method_exchangeImplementations(m1, m2);
}


@end
