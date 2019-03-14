//
//  Programmer2+Program.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/21.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "Programmer2+Program.h"
//分类实现文件
#import <objc/runtime.h>

@implementation Programmer2 (Program)
//为Catagory添加属性
static const char kMottoKey;
-(void)setMotto:(NSString *)motto{
    objc_setAssociatedObject(self, &kMottoKey, motto, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSString *)motto{
    return objc_getAssociatedObject(self, &kMottoKey);
}

//私有方法
-(void)program{
    NILog(@"===Programmer+Program 分类里的program私有方法实现.===");
}

//实现公有方法
-(void)draw{
    NILog(@"===Programmer+Program 分类里的draw公有方法实现.===");
}
-(void)sing{
    NILog(@"===Programmer+Program 分类里的sing公有方法实现.===");
}

@end
