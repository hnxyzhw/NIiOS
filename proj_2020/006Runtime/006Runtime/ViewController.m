//
//  ViewController.m
//  006Runtime
//
//  Created by nixs on 2020/8/5.
//  Copyright © 2020 nixs. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "Person.h"

//不用手动引入分类即可
#import "UIImage+Category.h"
#import "NSObject+Category.h"

@interface ViewController ()
@property(nonatomic,strong) UIImageView *imgV_Header;
@end

/// <#Description#>
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"---ViewController---");
    //PCH文件引入
    NSLog(@"---W:%lf",kScreenWidth);
    NSLog(@"---H:%lf",kScreenHeight);
    /**
     id obj = objc_msgSend(objc_getClass("NSObject"),sel_registerName("alloc"));
     objc_msgSend(obj,sel_registerName("init"));
     */
    [self func_003];
    
}

/// 利用runtime获取所有属性来进行字典转模型 eg：MJExtension
-(void)func_004{
    
    
    
}
/// 三、获得一个类的所有成员变量
-(void)func_003{
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList([Person class], &outCount);
    //遍历所有成员变量
    for (int i=0; i<outCount; i++) {
        //取出i位置对应的成员变量
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        const char *type = ivar_getTypeEncoding(ivar);
        NSLog(@"---成员变量名：%s,成员变量类型:%s",name,type);
    }
    //注意释放内存
    free(ivars);
}

/// 懒加载
-(UIImageView *)imgV_Header{
    if (!_imgV_Header) {
        _imgV_Header = [[UIImageView alloc] initWithFrame:CGRectMake(5, 100, kScreenWidth-10, kScreenWidth-10)];
        /**
         就是用我们的名字能调用系统的方法，用系统的名字能调用我们的方法
                    分类里替换过系统原始imageNamed方法-实现了系统方法的拦截
         */
        //[_imgV_Header setImage:[UIImage imageNamed:@"nixs"]];
        //[_imgV_Header setImage:[UIImage NI_imageNamed:@"nixs"]];
    }
    return _imgV_Header;
}
/// 拦截系统方法
-(void)func_002{
    [self.view addSubview:self.imgV_Header];
}

/// 案例1：方法简单的交换
-(void)func_001{
    [Person run];
    [Person study];
    
    //获取两个类的类方法
    Method m1 = class_getClassMethod([Person class], @selector(run));
    Method m2 = class_getClassMethod([Person class], @selector(study));
    //开始交换方法实现
    method_exchangeImplementations(m1, m2);
    //交换后，先打印学习，再打印跑
    [Person run];
    [Person study];
    
    Person *p = [Person new];
    //在NSObject+Category.h/m分类里添加属性
    p.name = @"蜡笔🖍小新";
    NSLog(@"---Person.name:%@",p.name);
}
//+(BOOL)resolveInstanceMethod:(SEL)sel{
//
//}
//+(BOOL)resolveClassMethod:(SEL)sel{
//
//}
//备用接受者
//- (id)forwardingTargetForSelector:(SEL)aSelector{
//
//}
/**
 注：如果想替换类方法的接受者，需要覆写 - (id)forwardingTargetForSelector:(SEL)aSelector方法，并返回对象
 */

/**
 👇完整的消息转发
 */
//- (void)forwardInvocation:(NSInvocation *)anInvocation{
//
//}
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
//
//}





@end
