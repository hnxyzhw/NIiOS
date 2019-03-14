//
//  RunTimeViewController01.m
//  NIiOS
//
//  Created by nixs on 2019/2/28.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "RunTimeViewController01.h"
#import "UIFont+Adapt.h"
#import "UIImage+Tools.h"
#import "RuntimePerson.h"
#import "StudentModel.h"
#import "CourseModel.h"

@interface RunTimeViewController01 ()<UITextFieldDelegate>
@property(nonatomic,strong) UILabel *labTitle;
@property(nonatomic,strong) UITextField *textFieldName;
@end

@implementation RunTimeViewController01

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Runtime-iOS运行时应用篇[0,1]";
    /**
     RunTime 应用
     1.动态方法交换: {"交换两个方法的实现","拦截替换系统方法"}
     2.类目添加新属性
     3.获取类详细属性 {"属性列表","成员变量列表","方法列表","协议列表"}
     4.解决同一方法高频率调用的效率问题
     5.动态方法解析宇消息转发 {"动态添加方法","解决方法无响应崩溃问题"}
     6.动态操作属性 {"修改私有属性","改进iOS归档和解档","实现字典与模型的转换"}
     */
    
    //[self FUNC1];
    //[self FUNC2];
    //[self FUNC3];
    //[self FUNC4];
    //[self FUNC5];
    //[self FUNC6];
    //[self FUNC7];
    [self FUNC7_1];
}

/**
 3.实现字典与模型的转换
    字典数据转模型的操作在项目开发中很常见，通常我们会选择第三方如YYModel；其实我们也可以自己来实现这一功能，
 主要思路有两种：KVC/Runtime,总结字典转化模型过程中需要解决的问题如下：
 */
-(void)FUNC7_1{
    //读取JSON数据
    NSDictionary *jsonData = [NSObject NIDictionaryFromJSONFileName:@"Student.json"];
    NSLog(@"===jsonData:%@===",jsonData);
    
    //字典转模型
    StudentModel* student=[StudentModel zs_modelWithDictionary:jsonData];
    CourseModel* courseModel =  student.course[0];
    NSLog(@"------ %@",courseModel);
 
    StudentModel* stuModel = [StudentModel modelWithDictionary:jsonData];
    CourseModel* courModel = stuModel.course[0];
    NSLog(@"------ %@",courModel);
}

/**
 六、动态操作属性
 1.动态修改属性变量；
 2.实现NSCoding的自动归档和解档；
 3.实现字典与模型的转换；
 */
-(void)FUNC7{
    //1.动态修改属性变量
    /**
        现在假设这样一个情况：我们使用第三方框架里的Person类，在特殊需求下想要更改其私有属性nickName，这样的操作我们就可以使用Runtime可以动态修改对象属性；
     基本思路：首先使用runtime获取Person对象的所有私有属性，找到nickeName，然后使用ivar是方法修改其值，具体代码如下
     */
    RunTimePerson* person = [RunTimePerson new];
    [person setValue:@"蜡笔小新" forKey:@"nickName"];
    NSLog(@"person-nickName:%@",[person valueForKey:@"nickName"]);
    
    //第一步：遍历对象的所有属性
    unsigned int count;
    Ivar* ivarList = class_copyIvarList([person class], &count);
    for (int i=0; i<count; i++) {
        //第二步:获取每个属性名
        Ivar ivar = ivarList[i];
        const char *ivarName = ivar_getName(ivar);
        NSString* propertyNmae = [NSString stringWithUTF8String:ivarName];
        if ([propertyNmae isEqualToString:@"_nickName"]) {
            //第三步:匹配到对应的属性，然后修改:注意属性带有下划线
            object_setIvar(person, ivar, @"倪新生");
        }
    }
    NSLog(@"ps-nickName:%@",[person valueForKey:@"nickName"]);
    //总结:此过程 类似 KVC（key value coding）的 取值 和 赋值；
}
/**
 五、方法动态解析 与 消息转发
 */
/**
 1.动态方法解析：动态添加方法
    Runtime足够强大,能够让我们在运行时动态添加一个未实现的方法,这个功能主要有两个应用场景
 场景1：动态添加未实现方法,解决代码中因为方法未找到而报错的问题；
 场景2：利用懒加载思路，若一个类有很多个方法，同时加载到内存中会耗费资源，可以使用动态解析添加方法
 
 2.解决方法无形应崩溃问题
    执行OC方法其实就是一个发送消息的过程,若方法未实现,我们可以利用方法动态解析与消息转发来避免程序崩溃，
 */
-(void)FUNC6{
    
}
//类方法未找到是调用，可于此添加类方法实现
+(BOOL)resolveClassMethod:(SEL)sel{
    return YES;
}
//实例方法未找到时调起，可于此添加实例方法
+(BOOL)resolveInstanceMethod:(SEL)sel{
    
    /**
     运行时方法：向指定类中添加特定方法实现的操作

     @param cls 被添加方法的类
     @param name selector方法名
     @param imp 指向实现方法的函数指针
     @param types imp函数实现的返回值与参数类型
     @return 添加方法是否成功
     */
    BOOL class_addMethod(Class  _Nullable __unsafe_unretained cls, SEL  _Nonnull name, IMP  _Nonnull imp, const char * _Nullable types);
    return YES;
}
//消息接收者重定向
//重定向类方法的消息接收者，返回一个类
-(id)forwardingTargetForSelector:(SEL)aSelector{
    return self;
}
//重定向实例方法的消息接受者，返回一个实例对象
//-(id)forwardingTargetForSelector:(SEL)aSelector{
//    return self;
//}

//消息重定向
-(void)forwardInvocation:(NSInvocation *)anInvocation{}
//-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
//    return self;
//}

/**
 结局同一方法高频调用的效率问题
    Runtime源码中的IMP作为函数指针，指向方法的实现.通过它,我们可以绕开发送消息的过程来提高函数调用的效率。
 当我们需要持续大量重复调用某个方法的时候,会十分有用,具体如下:
 */
-(void)FUNC5{
    void(*setter)(id,SEL,BOOL);
    int i;
//    setter = (void(*)(id,SEL,BOOL))[target methodForSelector:@selector(setFilled:)];
//    for (int i=0; i<1000; i++) {
//        setter(targetList[i],@selector(setFilled:),YES);
//    }
}
///Users/nixs/Downloads/xiaoqi-master/高仿花田小溪/Assets.xcassets:-1: Name 'AppIcon' used for other type (duplicate names)
/**
 获取类的详细信息
 */
-(void)FUNC4{
    //1.获取属性列表
    unsigned int count;
    objc_property_t* propertyList = class_copyPropertyList([self class], &count);
    for (unsigned int i=0; i<count; i++) {
        const char *propertyName = property_getName(propertyList[i]);
        NSLog(@"ProperTyName(%d):%@",i,[NSString stringWithUTF8String:propertyName]);
    }
    free(propertyList);
    
    //2.获取所有成员变量
    Ivar* ivarList = class_copyIvarList([self class], &count);
    for (unsigned int i=0; i<count; i++) {
        Ivar ivar = ivarList[i];
        const char* ivarName = ivar_getName(ivar);
        NSLog(@"Ivar(%d):%@",i,[NSString stringWithUTF8String:ivarName]);
    }
    free(ivarList);
    
    //3.获取所有方法
    Method* methodList = class_copyMethodList([self class], &count);
    for (unsigned int i=0; i<count; i++) {
        Method method = methodList[i];
        SEL methodName = method_getName(method);
        NSLog(@"MethodName(%d):%@",i,NSStringFromSelector(methodName));
    }
    free(methodList);
    
    //4.获取当前遵循的所有协议
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([self class], &count);
    for (int i=0; i<count; i++) {
        Protocol *protocol = protocolList[i];
        const char *protocolName = protocol_getName(protocol);
        NSLog(@"protocol(%d):%@",i,[NSString stringWithUTF8String:protocolName]);
    }
    free(protocolList);
    
    #warning mark - C语言中使用Copy操作的方法,要注意释放指针,防止内存泄漏
    //注意:C语言中使用Copy操作的方法,要注意释放指针,防止内存泄漏
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
/**
 二、实现分类添加新属性
 我们在开发中常常使用类目Category为一些已有的类拓展功能。虽然继承也能够为已有类增加新的方法,而且相比类目更是具有增加属性的优势，
 但是继承毕竟是一个重量级的操作,添加不必要的继承关系无疑增加了代码的复杂度；
 
 遗憾的是，OC的类目并不支持直接添加属性，如果我们直接在分类的声明中写入Property属性，那么只能为其生成set和get方法声明，却不能生成成员变量，
 直接调用这些属性还会造成崩溃；
    所以为了实现给分类添加属性,我们还需借助Runtime的关联对象（Associated Objects）特性,它能够帮助我们在运行阶段将任意的属性关联到一个对象上，
 */
-(void)FUNC3{
    /**
     1.给对象设置关联属性
     2.通过key获取关联属性
     3.移除对象所关联的属性
     */
    UIImage* image = [UIImage new];
    image.urlString = @"http://www.image.png";
    NSLog(@"获取关联属性:%@",image.urlString);
    
    [image clearAssociatedObject];
    NSLog(@"获取关联属性:%@",image.urlString);
}


/**
 2.拦截并替换系统方法
 Runtime动态方法交换更多的是应用于系统类库和第三方框架的方法替换。
 在不可见源码的情况下，我们可以借助Runtime交换方法实现，为原有方法添加额外功能，
 这在实际开发中具有十分重要意义。
 */
-(void)FUNC2{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:20];
    label.text = @"测试Runtime拦截方法";
    label.textColor = [UIColor redColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor grayColor];
    self.labTitle = label;
    [self.view addSubview:self.labTitle];
    [self.labTitle makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        }
        make.centerX.equalTo(self.view);
        make.size.equalTo(CGSizeMake(kScreenWidth*0.9, 50));
    }];
}



/**
 1.动态方法交换：Method Swizzling
 */
-(void)FUNC1{
    //交换方法的实现,并测试打印
    Method methodA = class_getInstanceMethod([self class], @selector(printA));
    Method methodB = class_getInstanceMethod([self class], @selector(printB));
    method_exchangeImplementations(methodA, methodB);
    [self printA];
    [self printB];
}
-(void)printA{
    NSLog(@"打印A...");
}
-(void)printB{
    NSLog(@"打印B...");
}

@end
