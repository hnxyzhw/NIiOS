//
//  RunTimePerson.m
//  NIiOS
//
//  Created by nixs on 2019/2/26.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "RunTimePerson.h"
#import <objc/runtime.h>

@interface RunTimePerson()
@property(nonatomic,strong) NSString *nickName;
@end

@implementation RunTimePerson
//重写父类方法:处理类方法
+(BOOL)resolveClassMethod:(SEL)sel{
    if (sel==@selector(haveMeal:)) {
        class_addMethod(object_getClass(self), sel, class_getMethodImplementation(object_getClass(self), @selector(zs_haveMeal:)), "v@");
        return YES;//添加函数实现,返回YES
    }
    return [class_getSuperclass(self) resolveClassMethod:sel];
}
//重写父类方法:处理实例方法
+(BOOL)resolveInstanceMethod:(SEL)sel{
    if (sel==@selector(singSong:)) {
        class_addMethod([self class], sel, class_getMethodImplementation([self class], @selector(zs_singSong:)), "v@");
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

+ (void)zs_haveMeal:(NSString *)food{
    NSLog(@"%s",__func__);
}
- (void)zs_singSong:(NSString *)name{
    NSLog(@"%s",__func__);
}
////////////////////////////////////////////////////////////////////////////////////////
+(void)takeExam:(NSString *)exam{
    NSLog(@"2.消息接收者重定向 %s",__FUNCTION__);
}
-(void)learnKnowledge:(NSString *)course{
    NSLog(@"2.消息接收者重定向 %s",__FUNCTION__);
}



@end
