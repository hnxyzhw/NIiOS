
//
//  ThreadViewController.m
//  NIiOS
//
//  Created by nixs on 2018/12/10.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "ThreadViewController.h"
#import "SVProgressHUD.h"
#import <pthread.h>
/**
 参考:iOS 多线程：『pthread、NSThread』详尽总结
 地址:https://www.jianshu.com/p/cbaeea5368b1
 */
@interface ThreadViewController ()
@property(nonatomic,strong) UIButton* btnPthread;
@property(nonatomic,strong) UIButton* btnNSthread;//NSThread 是苹果官方提供的
@property(nonatomic,strong) UIButton* btnDownLoadImg;//子线程下载图片
@property(nonatomic,strong) UIImageView* imgView;//显示下载后的图片

@property(nonatomic,strong) UIButton* btnSaleTicket;//卖火车票
/* 火车票剩余数量 */
@property (nonatomic, assign) NSUInteger ticketSurplusCount;
/* 北京售票窗口 */
@property (nonatomic, strong) NSThread *ticketSaleWindow1;
/* 上海售票窗口 */
@property (nonatomic, strong) NSThread *ticketSaleWindow2;
@end

@implementation ThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPthreadButton];
}

/**
 * 初始化火车票数量、卖票窗口(线程安全)、并开始卖票
 */
- (void)initTicketStatusSave {
    // 1. 设置剩余火车票为 50
    self.ticketSurplusCount = 50;
    
    // 2. 设置北京火车票售卖窗口的线程
    self.ticketSaleWindow1 = [[NSThread alloc]initWithTarget:self selector:@selector(saleTicketSafe) object:nil];
    self.ticketSaleWindow1.name = @"北京火车票售票窗口";
    
    // 3. 设置上海火车票售卖窗口的线程
    self.ticketSaleWindow2 = [[NSThread alloc]initWithTarget:self selector:@selector(saleTicketSafe) object:nil];
    self.ticketSaleWindow2.name = @"上海火车票售票窗口";
    
    // 4. 开始售卖火车票
    [self.ticketSaleWindow1 start];
    [self.ticketSaleWindow2 start];
    
}
/**
 * 售卖火车票(线程安全)
 */
- (void)saleTicketSafe {
    while (1) {
        // 互斥锁
        @synchronized (self) {
            //如果还有票，继续售卖
            if (self.ticketSurplusCount > 0) {
                self.ticketSurplusCount --;
                NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", self.ticketSurplusCount, [NSThread currentThread].name]);
                [NSThread sleepForTimeInterval:0.2];
            }
            //如果已卖完，关闭售票窗口
            else {
                NSLog(@"所有火车票均已售完");
                break;
            }
        }
    }
}


////////////////////////////////////////////////////////////
/**
 3.创建一个线程下载图片
 */
-(void)downloadImageOnSubThread:(UIButton*)btn{
    [SVProgressHUD showWithStatus:@"下载图片中..."];
    [SVProgressHUD setBorderWidth:1.0];
    [SVProgressHUD setBorderColor:[UIColor blackColor]];
    [SVProgressHUD setBackgroundColor:RGBACOLOR(0, 0, 0, 0.3)];
    //在创建的子线程中调用downloadImage下载图片
    [NSThread detachNewThreadSelector:@selector(downloadImage) toTarget:self withObject:nil];
}

/**
 下载图片,下载完之后回到主线程进行UI刷新
 */
-(void)downloadImage{
    NSLog(@"current thread--- %@",[NSThread currentThread]);
    //1.获取图片 imageUrl
    NSURL* imgUrl = [NSURL URLWithString:@"https://ysc-demo-1254961422.file.myqcloud.com/YSC-phread-NSThread-demo-background.png"];
    //2.从imageUrl中读物数据(下载图片)---耗时操作
    NSData* imageData = [NSData dataWithContentsOfURL:imgUrl];
    //通过二进制data创建image
    UIImage* image = [UIImage imageWithData:imageData];
    //3.回到主线程进行图片赋值和界面刷新
    [self performSelectorOnMainThread:@selector(refreshOnMainThread:) withObject:image waitUntilDone:YES];
}
/**
 回到主线程进行图片赋值和界面刷新
 */
-(void)refreshOnMainThread:(UIImage*)image{
    [SVProgressHUD dismiss];
    NSLog(@"current thread--- %@",[NSThread currentThread]);
    //赋值图片到imageView
    self.imgView.image = image;
}
////////////////////////////////////////////////////////////
/**
 2.Btn NSThread点击事件
 */
-(void)NSThreadClicked:(UIButton*)btn{
    #pragma mark - 先创建线程,再启动线程
    //1.创建线程
    //NSThread* thread = [[NSThread alloc] initWithTarget:self selector:@selector(runNSThread) object:nil];
    //2.启动线程
    //[thread start];//线程一启动,就会在线程thread中执行self的run方法
    //3.获取线程名字
    //DLog(@"==获取线程名字:%@===",thread.name);//这里为什么获取线程名字为空了？？？
    
    #pragma mark - 创建线程后自动启动线程
    //1.创建线程后自动启动线程
    //[NSThread detachNewThreadSelector:@selector(runNSThread) toTarget:self withObject:nil];
    
    #pragma mark - 隐式创建并启动线程
    //1.隐式创建并启动线程
    //[self performSelectorInBackground:@selector(runNSThread) withObject:nil];
    
    #pragma mark -线程之间的通信
    
}

/**
 新线程调用方法,里边为需要执行的任务
 */
-(void)runNSThread{
    NSLog(@"===runNSThread:%@===",[NSThread currentThread]);
}
////////////////////////////////////////////////////////////
/**
按钮点击事件
 */
-(void)pthreadButtonClick:(UIButton*)btn{
    NSLog(@"===pthread使用方法===");
    //1. 创建线程:定义一个pthread_t类型变量
    pthread_t thread;
    //2. 开启线程:执行任务
    pthread_create(&thread, NULL, run, NULL);
    //3. 设置子线程的状态设置为 detached，该线程运行结束后会自动释放所有资源
    pthread_detach(thread);
}
/**
 新线程调用方法,里边为需要执行的任务
 */
void * run(void *param){
    NSLog(@"===run===%@",[NSThread currentThread]);
    return NULL;
}
/**
 pthread的基本使用
 */
-(void)setupPthreadButton{
    //1.Thread
    self.btnPthread = [[UIButton alloc] init];
    self.btnPthread.layer.borderColor = [UIColor blackColor].CGColor;
    self.btnPthread.layer.borderWidth = 2;
    self.btnPthread.titleLabel.font = [UIFont systemFontOfSize:15];
    self.btnPthread.clipsToBounds = YES;
    self.btnPthread.layer.cornerRadius = 5;
    self.btnPthread.backgroundColor = [UIColor redColor];
    [self.btnPthread setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnPthread setTitle:@"1.Pthread基本使用" forState:UIControlStateNormal];
    [self.btnPthread addTarget:self action:@selector(pthreadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnPthread];
    [self.btnPthread makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        }
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(50);
    }];
    //2.NSThread
    self.btnNSthread = [[UIButton alloc] init];
    self.btnNSthread.layer.borderColor = [UIColor blackColor].CGColor;
    self.btnNSthread.layer.borderWidth = 2;
    self.btnNSthread.titleLabel.font = [UIFont systemFontOfSize:15];
    self.btnNSthread.clipsToBounds = YES;
    self.btnNSthread.layer.cornerRadius = 5;
    self.btnNSthread.backgroundColor = [UIColor redColor];
    [self.btnNSthread setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnNSthread setTitle:@"2.NSThread 是苹果官方提供的" forState:UIControlStateNormal];
    [self.btnNSthread addTarget:self action:@selector(NSThreadClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnNSthread];
    [self.btnNSthread makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnPthread.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(50);
    }];
    //3.下载图片Demo
    self.btnDownLoadImg = [[UIButton alloc] init];
    self.btnDownLoadImg.layer.borderColor = [UIColor blackColor].CGColor;
    self.btnDownLoadImg.layer.borderWidth = 2;
    self.btnDownLoadImg.titleLabel.font = [UIFont systemFontOfSize:15];
    self.btnDownLoadImg.clipsToBounds = YES;
    self.btnDownLoadImg.layer.cornerRadius = 5;
    self.btnDownLoadImg.backgroundColor = [UIColor redColor];
    [self.btnDownLoadImg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnDownLoadImg setTitle:@"3.下载图片 DEMO 来展示线程之间的通信" forState:UIControlStateNormal];
    [self.btnDownLoadImg addTarget:self action:@selector(downloadImageOnSubThread:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnDownLoadImg];
    [self.btnDownLoadImg makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnNSthread.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(50);
    }];
    //显示下载后的图片
    self.imgView = [UIImageView new];
    [self.imgView.layer setBorderWidth:2];
    [self.imgView.layer setBorderColor:[UIColor redColor].CGColor];
    
    [self.view addSubview:self.imgView];
    [self.imgView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnDownLoadImg.mas_bottom).offset(5);
        make.centerX.equalTo(self.view);
        make.size.equalTo(CGSizeMake(kScreenWidth*0.9, kScreenWidth*0.5));
    }];
    //4.卖火车票
    self.btnSaleTicket = [[UIButton alloc] init];
    self.btnSaleTicket.layer.borderColor = [UIColor blackColor].CGColor;
    self.btnSaleTicket.layer.borderWidth = 2;
    self.btnSaleTicket.titleLabel.font = [UIFont systemFontOfSize:15];
    self.btnSaleTicket.clipsToBounds = YES;
    self.btnSaleTicket.layer.cornerRadius = 5;
    self.btnSaleTicket.backgroundColor = [UIColor redColor];
    [self.btnSaleTicket setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSaleTicket setTitle:@"4.卖火车票问题" forState:UIControlStateNormal];
    [self.btnSaleTicket addTarget:self action:@selector(initTicketStatusSave) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnSaleTicket];
    [self.btnSaleTicket makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(50);
    }];
}

@end
