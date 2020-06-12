
//
//  RunTimeViewController00.m
//  NIiOS
//
//  Created by nixs on 2019/2/22.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "RunTimeViewController00.h"
#import <objc/runtime.h>
#import <objc/message.h>

#import "RunTimePerson.h"
#import "NIWebViewController.h"

#define RunTimeImageURL @"https://upload-images.jianshu.io/upload_images/1244124-f494339a6ae5d6c6.png"
#define RunTimeObjc @"https://upload-images.jianshu.io/upload_images/1244124-7d013e9e252dba2a.png"

@interface RunTimeViewController00 ()
@property(nonatomic,strong) UIImageView *imageViewHeader;
@property(nonatomic,strong) UIImageView *imageViewRunTime;
@property(nonatomic,strong) RunTimePerson *runTimePerson;

@property(nonatomic,strong) UIButton *btnWeb;
@property(nonatomic,strong) UIButton *btnWeb2;
@end

@implementation RunTimeViewController00

//重定向类方法：返回一个类对象
+ (id)forwardingTargetForSelector:(SEL)aSelector{
    if (aSelector==@selector(takeExam:)) {
        return [RunTimePerson class];
    }
    return [super forwardingTargetForSelector:aSelector];
}
//重定向实例方法：返回的实例
- (id)forwardingTargetForSelector:(SEL)aSelector{
    if (aSelector==@selector(learnKnowledge:)) {
        return self.runTimePerson;
    }
    return [super forwardingTargetForSelector:aSelector];
}
///////////////////////3.消息重定向/////////////////////////////////
-(void)forwardInvocation:(NSInvocation *)anInvocation{
    //1.从anInvocation中获取消息
    SEL sel = anInvocation.selector;
    //2.判断RunTimePerson方法是否可以相应sel
    if ([self.runTimePerson respondsToSelector:sel]) {
        //2.1 若可以相应,则将消息转发给其他对象处理
        [anInvocation invokeWithTarget:self.runTimePerson];
    }else{
        //2.2 若仍然无法相应,则报错:找不到相应方法
        //[self doesNotRecognizeSelector:sel];
        
        //针对上面 - 如下直接toast提示了
        [self.view makeToast:@"-[RunTimeViewController00 learnKnowledge:]: unrecognized selector sent to instance 0x11f30a530"];
    }
}
//需要从这个方法中获取的信息来创建NSInvocation对象,因此我们必须重写这个方法,为给定的selector提供一个合适的方法签名.
-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSMethodSignature* methodSignature = [super methodSignatureForSelector:aSelector];
    if (!methodSignature) {
        methodSignature = [NSMethodSignature signatureWithObjCTypes:"v@:*"];
    }
    return methodSignature;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Runtime-iOS运行时基础篇[0,0]";
    [self setupUI];
    [self testRuntime];
}

-(void)testRuntime{
    //测试:Person 调用并未实现的类方法、实例方法，并没有崩溃
    /** 测试一：动态方法解析
     RunTimePerson *ps = [[RunTimePerson alloc] init];
     [RunTimePerson haveMeal:@"Apple"];
     [ps singSong:@"纸短情长"];
     */
    
    /** 测试二：消息接收者重定向
    //调用未声明和实现的类方法
    [RunTimeViewController00 performSelector:@selector(takeExam:) withObject:@"语文"];
    //调用未声明和实现的类方法
    self.runTimePerson = [[RunTimePerson alloc] init];
    [self performSelector:@selector(learnKnowledge:) withObject:@"天文学知识"];
    */
    
    //测试三:消息重定向
    [self performSelector:@selector(learnKnowledge:) withObject:@"天文学"];
}

-(void)setupUI{
    self.imageViewHeader = [[UIImageView alloc] init];
    NIViewSetRadius(self.imageViewHeader, 5)
    UIColor* borderColor = [UIColor redColor];
    NIViewBorderRadius(self.imageViewHeader, 1, borderColor.CGColor)
    [self.view addSubview:self.imageViewHeader];
    [self.imageViewHeader makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        }
        make.centerX.equalTo(self.view);
        make.size.equalTo(CGSizeMake(kScreenWidth*0.95, kScreenWidth*0.6));
    }];
    self.imageViewRunTime = [[UIImageView alloc] init];
    NIViewSetRadius(self.imageViewRunTime, 5)
    NIViewBorderRadius(self.imageViewRunTime, 1, borderColor.CGColor)
    [self.view addSubview:self.imageViewRunTime];
    [self.imageViewRunTime makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageViewHeader.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.size.equalTo(CGSizeMake(kScreenWidth*0.95, kScreenWidth*0.6));
    }];
    
    UIButton *button = [[UIButton alloc] init];
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 2;
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 5;
    button.backgroundColor = [UIColor redColor];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setTitle:@"1.Runtime-iOS运行时基础篇" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.btnWeb = button;
    [self.view addSubview:self.btnWeb];
    [self.btnWeb makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageViewRunTime.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.size.equalTo(CGSizeMake(kScreenWidth*0.95, 50));
    }];
    UIButton *button2 = [[UIButton alloc] init];
    button2.layer.borderColor = [UIColor blackColor].CGColor;
    button2.layer.borderWidth = 2;
    button2.clipsToBounds = YES;
    button2.layer.cornerRadius = 5;
    button2.backgroundColor = [UIColor redColor];
    button2.titleLabel.font = [UIFont systemFontOfSize:18];
    [button2 setTitle:@"2.Runtime-iOS运行时应用篇" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
    [button2 addTarget:self action:@selector(buttonClicked2:) forControlEvents:UIControlEventTouchUpInside];
    self.btnWeb2 = button2;
    [self.view addSubview:self.btnWeb2];
    [self.btnWeb2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnWeb.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.size.equalTo(CGSizeMake(kScreenWidth*0.95, 50));
    }];
    //方案一：
    //NSString* url = RunTimeImageURL;
    //[self.imageViewHeader setImageWithURL:[NSURL URLWithString:url] placeholder:[UIImage imageNamed:@"F"]];//该方法在控制器跳转立马就调用会有卡顿现象
    //方案二：
    WEAKSELF;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:RunTimeImageURL]];
        NSData* dataRunTime = [NSData dataWithContentsOfURL:[NSURL URLWithString:RunTimeObjc]];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.imageViewHeader.image = [UIImage imageWithData:data];
            weakSelf.imageViewRunTime.image = [UIImage imageWithData:dataRunTime];
        });
    });
    
    
    int count=0;
    Ivar *ivarList = class_copyIvarList([self class], &count);
    for (int i=0; i<count; i++) {
        Ivar ivar = ivarList[i];
        const char *ivarName = ivar_getName(ivar);
        NSLog(@"Ivar(%d): %@", i, [NSString stringWithUTF8String:ivarName]);
    }
    free(ivarList);
    
    //id _Nullable objc_msgSend(id _Nullable self,SEL _Nonnull op,...);
    
}

/**
 按钮点击事件
 */
-(void)buttonClicked:(UIButton*)btn{
    btn.selected = !btn.isSelected;
    if (btn.selected) {
        NIWebViewController* webView = [[NIWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.jianshu.com/p/d4b55dae9a0d"]];
        [self.navigationController pushViewController:webView animated:YES];
    }
}
-(void)buttonClicked2:(UIButton*)btn{
    btn.selected = !btn.isSelected;
    if (btn.selected) {
        NIWebViewController* webView = [[NIWebViewController alloc] initWithURL:[NSURL URLWithString:@"https://www.jianshu.com/p/fe131f8757ba"]];
        [self.navigationController pushViewController:webView animated:YES];
    }
}
@end
