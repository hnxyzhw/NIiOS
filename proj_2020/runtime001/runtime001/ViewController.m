//
//  ViewController.m
//  runtime001
//
//  Created by nixs on 2020/6/12.
//  Copyright © 2020 nixs. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+Tag.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "Person.h"

@interface ViewController ()

@end

/// 测试案例
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"首页";
    //[self func001];
    //[self func002];
    //[self func003];
    objc_msgSend(self, @selector(doSomething));
    //[self getPrivate];
    [self func004];
}
//RunTime简称运行时，就是系统在运行的时候的一些机制，其中最主要的是消息机制；
//RunTime基本是用C和汇编写的，从而有了动态系统的高效；



-(void)func004{
    NSLog(@"---func004---实现---");
    //
}

///开发中经常有些需求，凭借着苹果提供的API不好实现，或者实现起来比较麻烦，此时，我们可以
/// 运用runtime来获取类的内部成员变量，然后利用KVC进行替换，来达到目的；
///  Flowing：运用runtime来获取内部成员变量的方法，以获取UITextView类为例；
-(void)getPrivate{
    unsigned int count = 0;
    Ivar *vars = class_copyIvarList([UITextField class], &count);
    for (int i=0; i<count; i++) {
        Ivar var = vars[i];
        NSLog(@"---%s",ivar_getName(var));
    }
    free(vars);
}

-(void)doSomething{
    NSLog(@"func - doSomething.---实现---");
}

-(void)func003{
    SEL sel = @selector(viewDidLoad);
    NSLog(@"%s",sel);
}

-(void)func002{
    self.tag = @"TAG";
    NSLog(@"---tag=%@",self.tag);
}

-(void)func001{
    NSLog(@"---测试案例func001---");
    ///
//    typedef struct objc_class *class;
//    struct objc_class {
//        Class isa;                                // 实现方法调用的关键
//        Class super_class;                        // 父类
//        const char * name;                        // 类名
//        long version;                             // 类的版本信息，默认为0
//        long info;                                // 类信息，供运行期使用的一些位标识
//        long instance_size;                       // 该类的实例变量大小
//        struct objc_ivar_list * ivars;            // 该类的成员变量链表
//        struct objc_method_list ** methodLists;   // 方法定义的链表
//        struct objc_cache * cache;                // 方法缓存
//        struct objc_protocol_list * protocols;    // 协议链表
//    };
    ///
    struct objc_object{
        Class isa;
    };
    typedef struct objc_object *id;
   //一、runtime是什么
   //二、Runtime是怎么工作的
    //1.Class和Object
    //2.Meta Class元类
    //3.Method
    //4.Category
    //5.
    typedef struct objc_method *Method;
    struct objc_method{
        SEL method_name;
        char * method_types;
        IMP method_imp;
    };
    
    ///一个对象唯一保存的信息就是它的Class的地址。当我们调用一个对象的方法时，它会通过isa去找到对应的objc_class,然后再在objc_class的methodLists中找到我们调用的方法，然后执行
    ///再说说cache,调用方法的过程是个查找methodLists的过程,如果每次调用都去查询，效率会非诚低。所以对于调用过的方法，会以map的方式保存在cache中，下次再调用就会快很多。
    ///Meta Class（元类）
    
    //在Object-C中，所有的方法调用，都会转化成向对象发送消息。发送消息主要使用objc_msgSend函数；
    //id objc_msgSend(id self,SEL op,...);
    //objc_msgSend(self, @selector(doSomething));
    [self testCmd:@(5)];
}

-(void)testCmd:(NSNumber*)num{
    NSLog(@"%ld",(long)num.integerValue);
    num = [NSNumber numberWithInteger:num.integerValue-1];
    if (num.integerValue>0) {
        [self performSelector:_cmd withObject:num];
    }
}

//-(void)doSomething{
//    NSLog(@"---doSomething---");
//}



@end
