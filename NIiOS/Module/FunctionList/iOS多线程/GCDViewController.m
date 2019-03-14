//
//  GCDViewController.m
//  NIiOS
//
//  Created by nixs on 2019/2/11.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "GCDViewController.h"
#import "SVProgressHUD.h"

@interface GCDViewController ()
@property(nonatomic,strong) UIButton* btnDownLoadImg;//线程间通讯-下载图片示例
@property(nonatomic,strong) UIImageView* imgView;//显示下载后的图片
/* 剩余火车票数 */
@property (nonatomic, assign) int ticketSurplusCount;
/*北京售票窗口 */
@property (nonatomic, strong) NSThread *ticketSaleWindow1;
/*上海售票窗口 */
@property (nonatomic, strong) NSThread *ticketSaleWindow2;
@end

@implementation GCDViewController{
    dispatch_semaphore_t semaphoreLock;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"GCDViewController";
    [self setupUI];
    /*任务+队列 相关方法*/
    
    //同步执行+并发队列
    //[self syncConncurrent];
    
    //异步执行+并发队列
    //[self asyncConncurrent];
    
    //同步执行+串行队列
    //[self syncSerial];
    
    //异步执行+串行队列
    //[self asyncSerial];
    
    //同步执行+主队列（主线程调用）
    //[self syncMain];
    
    //同步执行+主队列(其他线程调用)
    //[NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];
    
    //异步执行+主队列
    //[self asyncMain];
    
    /*GCD线程间通信-拓展:图片的异步下载,下载完毕回到主线程刷新UI*/
    //[self communication];
    
    /*GCD其他方法*/
    //栅栏方法dispatch_barrier_async
    //[self barrier];
    
    //延时执行方法 dispatch_after
    //[self after];
    
    //一次执行代码(只执行一次)dispatch_once
    //[self once];
    
    //快速迭代方法dispatch_apply
    //[self apply];
    
    /*队列组*/
    //队列组dispatch_group_notify
    //[self groupNotify];
    
    //队列组dispatch_group_wait
    //[self groupWait];
    
    //队列组dispatch_group_enter/dispatch_group_leave
    //[self groupEnterAndLeave];
    
    /*信号量 dispatch_semaphore*/
    //semaphore线程同步
    //[self semaphoreSync];
    
    //semaphore线程安全
    
    //非线程安全:不适用semaphore
    //[self initTicketStatusNotSave];
    
    //线程安全:使用semaphore加锁
    [self initTicketStatusSave];
    
}

/**
 UI初始化
 */
-(void)setupUI{
    //3.下载图片Demo
    self.btnDownLoadImg = [[UIButton alloc] init];
    self.btnDownLoadImg.layer.borderColor = [UIColor blackColor].CGColor;
    self.btnDownLoadImg.layer.borderWidth = 2;
    self.btnDownLoadImg.titleLabel.font = [UIFont systemFontOfSize:15];
    self.btnDownLoadImg.clipsToBounds = YES;
    self.btnDownLoadImg.layer.cornerRadius = 5;
    self.btnDownLoadImg.backgroundColor = [UIColor redColor];
    [self.btnDownLoadImg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnDownLoadImg setTitle:@"GCD线程间通信:下载完图片回到主线程刷新UI" forState:UIControlStateNormal];
    [self.btnDownLoadImg addTarget:self action:@selector(downloadImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnDownLoadImg];
    [self.btnDownLoadImg makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        }
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
        make.size.equalTo(CGSizeMake(kScreenWidth*0.95, kScreenWidth*0.5));
    }];
}
/**
 同步执行 + 并发队列
 特点:在当前线程中执行任务,不会开启新线程,执行完一个任务,再执行下一个任务；
 */
-(void)syncConncurrent{
    NSLog(@"currentThread---%@",[NSThread currentThread]);//打印当前线程
    NSLog(@"syncConcurrent---begin");
    dispatch_queue_t queue = dispatch_queue_create("com.nixs.NIiOS", DISPATCH_QUEUE_CONCURRENT);
    dispatch_sync(queue, ^{
       //追加任务1
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);//打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        //追加任务2
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);//打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        //追加任务3
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);//打印当前线程
        }
    });
    NSLog(@"syncConcurrent---end");
}
/**
 异步执行 + 并发队列
 特点:可以开启多个线程,任务交替(同时)执行
 */
-(void)asyncConncurrent{
    NSLog(@"currentThread---%@",[NSThread currentThread]);//打印当前线程
    NSLog(@"asyncConcurrent---begin");
    dispatch_queue_t queue = dispatch_queue_create("com.nixs.NIiOS", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        //追加任务1
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);//打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        //追加任务2
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);//打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        //追加任务3
        for(int i=0;i<2;++i){
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);//打印当前线程
        }
    });
    NSLog(@"asyncConcurrent---end");
}

/**
 同步执行+串行队列
 特点:不会开启新线程,在当前线程执行任务.任务是串行的,执行完一个任务，再执行下一个任务.
 */
-(void)syncSerial{
    NSLog(@"currentThread---%@",[NSThread currentThread]);//打印当前线程
    NSLog(@"syncSerial---begin");
    dispatch_queue_t queue = dispatch_queue_create("com.nixs.NIiOS", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
       //追加任务1
        for (int i=0; i<2;++i) {
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);//打印当前线程
        }
    });
    dispatch_sync(queue, ^{
        //追加任务2
        for (int i=0; i<2;++i) {
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);//打印当前线程
        }
    });
    dispatch_sync(queue, ^{
        //追加任务3
        for (int i=0; i<2;++i) {
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);//打印当前线程
        }
    });
    NSLog(@"syncSerial---end");
}

/**
 异步执行+串行队列
 特点:会开启新线程,但是因为任务是串行的,执行完一个任务,在执行下一个任务;
 */
-(void)asyncSerial{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncSerial---begin");
    dispatch_queue_t queue = dispatch_queue_create("net.bujige.testQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"asyncSerial---end");
}

/**
 同步执行+主队列
 特点(主线程调用):互等卡主不执行。
 特点(其他线程调用):不会开启新线程,执行完一个任务,再执行下一个任务
 */
-(void)syncMain{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_sync(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_sync(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"syncMain---end");
}

/**
 异步执行+主队列
 特点:只在主线程中执行任务,执行完一个任务,再执行下一个任务
 */
-(void)asyncMain{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncMain---begin");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        // 追加任务3
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    NSLog(@"asyncMain---end");
}

/**
 线程间通信
 */
-(void)communication{
    //获取全局并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //获取主队列
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        //异步追加任务
        for (int i=0; i<2; ++i) {
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);//打印当前线程
        }
        //回到主线程
        dispatch_async(mainQueue, ^{
            //追加在主线程中执行任务
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);//打印当前线程
        });
    });
}

/**
 GCD异步下载图片
 */
-(void)downloadImage{
    [SVProgressHUD showWithStatus:@"下载图片中..."];
    [SVProgressHUD setBorderWidth:1.0];
    [SVProgressHUD setBorderColor:[UIColor blackColor]];
    [SVProgressHUD setBackgroundColor:RGBACOLOR(0, 0, 0, 0.3)];
    
    //方案一如下：
//    //获取全局并发队列
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    //获取主队列
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
//    dispatch_async(queue, ^{
//        NSLog(@"[子线程]current thread--- %@",[NSThread currentThread]);
//        //***异步任务
//        //1.获取图片 imageUrl
//        NSURL* imgUrl = [NSURL URLWithString:@"https://ysc-demo-1254961422.file.myqcloud.com/YSC-GCD-demo-background.png"];
//        //2.从imageUrl中读物数据(下载图片)---耗时操作
//        NSData* imageData = [NSData dataWithContentsOfURL:imgUrl];
//        //通过二进制data创建image
//        UIImage* image = [UIImage imageWithData:imageData];
//        //回到主线程
//        dispatch_async(mainQueue, ^{
//            //追加在主线程中执行任务
//            //3.回到主线程进行图片赋值和界面刷新
//            [SVProgressHUD dismiss];
//            NSLog(@"[主线程]current thread--- %@",[NSThread currentThread]);
//            //赋值图片到imageView
//            self.imgView.image = image;
//        });
//    });
    
    //方案二 代码段如下：
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //***异步任务
        //1.获取图片 imageUrl
        NSURL* imgUrl = [NSURL URLWithString:@"https://ysc-demo-1254961422.file.myqcloud.com/YSC-GCD-demo-background.png"];
        //2.从imageUrl中读物数据(下载图片)---耗时操作
        NSData* imageData = [NSData dataWithContentsOfURL:imgUrl];
        //通过二进制data创建image
        UIImage* image = [UIImage imageWithData:imageData];
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            //3.回到主线程进行图片赋值和界面刷新
            [SVProgressHUD dismiss];
            //赋值图片到imageView
            self.imgView.image = image;
        });
    });
}

/**
 栅栏方法 dispatch_barrier_async
 */
-(void)barrier{
    dispatch_queue_t queue = dispatch_queue_create("com.nixs.NIiOS", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
       //追加任务1
        for (int i=0; i<2; ++i) {
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);//打印当前线程
        }
    });
    dispatch_async(queue, ^{
        //追加任务2
        for (int i=0; i<2; ++i) {
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);//打印当前线程
        }
    });
    
    dispatch_barrier_sync(queue, ^{
        //追加barrier任务
        for (int i=0; i<2; ++i) {
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"barrier---%@",[NSThread currentThread]);//打印当前线程
        }
    });
    
    dispatch_async(queue, ^{
        //追加任务3
        for (int i=0; i<2; ++i) {
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);//打印当前线程
        }
    });
    dispatch_async(queue, ^{
        //追加任务4
        for (int i=0; i<2; ++i) {
            [NSThread sleepForTimeInterval:2];//模拟耗时操作
            NSLog(@"4---%@",[NSThread currentThread]);//打印当前线程
        }
    });
}

/**
 延时执行方法 dispatch_after
 */
-(void)after{
    WEAKSELF;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //3.0秒后一步追加任务代码到主队列,并开始执行
        NSLog(@"after---%@",[NSThread currentThread]);//打印当前线程
        [weakSelf downloadImage];
    });
}
//一次性代码(只执行一次)dispatch_once
-(void)once{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //只执行一次的代码(这里默认是线程安全的)
    });
}

/**
 快速迭代方法dispatch_apply
 */
-(void)apply{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLog(@"apply---begin");
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"%zd---%@",index,[NSThread currentThread]);
    });
    NSLog(@"apply---end");
}

#pragma mark - dispatch_group 队列组

/**
 * 队列组 dispatch_group_notify
 */
- (void)groupNotify {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步任务1、任务2都执行完毕后，回到主线程执行下边任务
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"group---end");
    });
}

/**
 * 队列组 dispatch_group_wait
 */
- (void)groupWait {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
    });
    
    // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"group---end");
    
}

/**
 * 队列组 dispatch_group_enter、dispatch_group_leave
 */
- (void)groupEnterAndLeave
{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        // 追加任务1
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        // 追加任务2
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]);      // 打印当前线程
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步操作都执行完毕后，回到主线程.
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"3---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"group---end");
    });
    
    //    // 等待上面的任务全部完成后，会往下继续执行（会阻塞当前线程）
    //    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    //
    //    NSLog(@"group---end");
}

/**
 semaphore线程同步
 */
-(void)semaphoreSync{
    NSLog(@"currentThread---%@",[NSThread currentThread]);//打印当前线程
    NSLog(@"semaphore---begin");
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block int number = 0;
    dispatch_async(queue, ^{
       //追加任务1
        [NSThread sleepForTimeInterval:2];//模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);//打印当前线程
        number = 100;
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"semphore---end,number=%d",number);
}

#pragma mark - semaphore线程安全

/**
 非线程安全:不适用semaphore
 初始化火车票数量、卖票窗口(非线程安全)、并开始卖票
 */
-(void)initTicketStatusNotSave{
    NSLog(@"currentThread---%@",[NSThread currentThread]);//打印当前线程
    NSLog(@"semaphore---begin");
    self.ticketSurplusCount=50;
    //queue1代表北京火车票售卖窗口
    dispatch_queue_t queue1 = dispatch_queue_create("com.nixs.NIiOS", DISPATCH_QUEUE_SERIAL);
    //queue2代表上海火车票售卖窗口
    dispatch_queue_t queue2 = dispatch_queue_create("com.nixs.NIiOS", DISPATCH_QUEUE_SERIAL);
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
        [weakSelf saleTicketNotSafe];
    });
    dispatch_async(queue2, ^{
        [weakSelf saleTicketNotSafe];
    });
}

/**
 售卖火车票(非线程安全)
 */
-(void)saleTicketNotSafe{
    while (1) {
        if (self.ticketSurplusCount>0) {//如果还有票,就继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@",[NSString stringWithFormat:@"剩余票数:%d 窗口:%@",self.ticketSurplusCount,[NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        }else{//如果票已售完,关闭售票窗口
            NSLog(@"所有火车票均已售完.");
            break;
        }
    }
}

/**
 线程安全:使用semaphore加锁
 初始化火车票数量、卖票窗口(线程安全)、并开始卖票
 */
-(void)initTicketStatusSave{
    NSLog(@"currentThread---%@",[NSThread currentThread]);//打印当前线程
    NSLog(@"semaphore---begin");
    semaphoreLock = dispatch_semaphore_create(1);
    self.ticketSurplusCount=50;
    //queue1代表北京火车票售卖窗口
    dispatch_queue_t queue1 = dispatch_queue_create("com.nixs.NIiOS", DISPATCH_QUEUE_SERIAL);
    //queue2代表上海火车票售卖窗口
    dispatch_queue_t queue2 = dispatch_queue_create("com.nixs.NIiOS", DISPATCH_QUEUE_SERIAL);
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
        self.ticketSaleWindow1 = [NSThread currentThread];//北京
        [weakSelf saleTicketSafe];
    });
    dispatch_async(queue2, ^{
        self.ticketSaleWindow2 = [NSThread currentThread];//上海
        [weakSelf saleTicketSafe];
    });
}

/**
 售卖火车票(线程安全)
 */
-(void)saleTicketSafe{
    while (1) {
        //相当于加锁
        dispatch_semaphore_wait(semaphoreLock, DISPATCH_TIME_FOREVER);
        if (self.ticketSurplusCount>0) {//如果还有票，继续售卖
            NSLog(@"---目前库存票数:%d",self.ticketSurplusCount);
            self.ticketSurplusCount--;
            NSLog(@"%@",[NSString stringWithFormat:@"[%@]卖出一张后剩余票数:%d",self.ticketSaleWindow1==[NSThread currentThread]?@"北京":@"上海",self.ticketSurplusCount]);
            [NSThread sleepForTimeInterval:0.2];
        }else{//如果已卖完,关闭售票窗口
            NSLog(@"所有火车票y均已售完.");
            //相当于解锁
            dispatch_semaphore_signal(semaphoreLock);
            break;
        }
        //相当于解锁
        dispatch_semaphore_signal(semaphoreLock);
    }
}
@end
