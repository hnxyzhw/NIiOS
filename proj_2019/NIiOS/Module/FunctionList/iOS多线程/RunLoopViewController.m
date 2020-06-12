//
//  RunLoopViewController.m
//  NIiOS
//
//  Created by nixs on 2019/2/12.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "RunLoopViewController.h"

@interface RunLoopViewController ()<UITextViewDelegate>
@property(nonatomic,strong) UIButton *btn;//CFRunLoopSourceRef
@property(nonatomic,strong) UITextView *textView;
@property(nonatomic,strong) UIImageView *imageView;

@property(nonatomic,strong) NSThread *thread;
@end

@implementation RunLoopViewController

/**
 系统默认定义了多种运行模式(CFRunLoopModeRef),如下:
 1.KCFRunLoopDefaultMode：App的默认运行模式,通常主线程是在这个运行模式下运行
 2.UITrackingRunLoopMode:跟踪用户交互事件(用于ScrollView追踪触摸滑动,保证界面滑动时不受其他Mode影响)
 3.UIInitializationRunLoopMode:在刚启动App时第进入的第一个Mode，启动完成就不在使用
 4.GSEventReceiveRunLoopMode:接受系统内部事件,通常用不到
 5.KCFRunLoopCommonModes:伪模式，不是一种真正的运行模式(后边会用到)
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"RunLoop理解";
    
    //[self showDemo1];//用来展示CFRunLoopModeRef和CFRunLoopTimerRef的结合使用
    
    [self setupUI];//UI初始化
    
    //[self showDemo2];//用来展示CFRunLoopObserverRef使用
    
    [self showDemo4];//用来展示常驻内存的方式
}

/**
 第四个例子:用来展示常驻内存的方式
 */
-(void)showDemo4{
    //创建线程,并调用run1方法执行任务
    self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(run1) object:nil];
}
-(void)run1{
    //这里写任务
    NSLog(@"---run1---%@",[NSThread currentThread]);
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
    //测试是否开启了RunLoop，如果开启RunLoop，则来不了这里,因为RunLoop开启了循环
    NSLog(@"--- ---");
}

/**
 第二个例子：用来展示CFRunLoopObserverRef使用
 */
-(void)showDemo2{
    //创建观察者
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        NSLog(@"监听到RunLoop发生改变---%zd",activity);
    });
    //添加观察者到当前RunLoop中
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
    //释放observer
    CFRelease(observer);
}
/**
 UI初始化
 */
-(void)setupUI{
    UIButton *button = [[UIButton alloc] init];
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 2;
    button.clipsToBounds = YES;
    button.layer.cornerRadius = 5;
    button.backgroundColor = [UIColor redColor];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setTitle:@"函数调用栈和Source" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.btn = button;
    [self.view addSubview:self.btn];
    [self.btn makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        }
        //make.centerX.equalTo(self.view);
        //make.size.equalTo(CGSizeMake(kScreenWidth*0.95, 50));//这里需要计算kScreenWidth*0.95 耗费计算性能
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(50);
    }];
    
    self.textView = [UITextView new];
    self.textView.delegate = self;
    self.textView.text = @"1. 监听UIScrollView的滚动/因为UITableView继承自UIScrollView，所以我们可以通过监听UIScrollView的滚动，实现UIScrollView相关delegate即可。/2. 利用PerformSelector设置当前线程的RunLoop的运行模式/利用performSelector方法为UIImageView调用setImage:方法，并利用inModes将其设置为RunLoop下NSDefaultRunLoopMode运行模式。代码如下：";
    self.textView.textColor = [UIColor blackColor];
    [self.view addSubview:self.textView];
    [self.textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btn.mas_bottom).offset(20);
        make.left.right.height.equalTo(self.btn);
    }];
    
    self.imageView = [UIImageView new];
    [self.view addSubview:self.imageView];
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(10);
        make.size.equalTo(CGSizeMake(kScreenWidth*0.9, kScreenWidth*0.6));
        make.centerX.equalTo(self.view);
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.imageView performSelector:@selector(setImage:) withObject:[UIImage imageNamed:@"1.jpg"] afterDelay:4.0 inModes:@[NSDefaultRunLoopMode]];
}
-(void)buttonClicked:(UIButton*)btn{
    NSLog(@"---函数调用栈和Source---");
}
/**
 用来展示CFRunLoopModeRef 和 CFRunLoopTimerRef的结合使用
 */
-(void)showDemo1{
    //定义一个定时器,约定2s之后调用self和run方法
    NSTimer* timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    //将定时器添加到当前RunLoop的NSDefaultRunLoopMode下,一旦RunLoop进入其他模式，定时器timer就不工作了
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    //将定时器添加到当前RunLoop的UITrackingRunLoopMode下,只在拖动情况下工作
    //[[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    
    //将定时器添加到当前RunLoop的NSRunLoopCommonModes下,定时器就会跑在被标记为Common Modes的模式下
    //[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    //调用了scheduledTimer返回的定时器,已经自动被加入到了RunLoopd NSDefaultRunLoopMode模式下
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(run) userInfo:nil repeats:YES];
    
}
-(void)run{
    NSLog(@"---RUN---");
}


@end
