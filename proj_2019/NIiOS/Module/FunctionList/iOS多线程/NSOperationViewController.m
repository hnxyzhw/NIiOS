//
//  NSOperationViewController.m
//  NIiOS
//
//  Created by nixs on 2019/2/11.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//
// 资料链接地址：https://bujige.net/blog/iOS-Complete-learning-NSOperation.html

#import "NSOperationViewController.h"
#import "YSCOperation.h"

@interface NSOperationViewController ()
/* 剩余火车票数 */
@property (nonatomic, assign) int ticketSurplusCount;
@property (readwrite, nonatomic, strong) NSLock *lock;

/*北京售票窗口 */
@property (nonatomic, strong) NSThread *ticketSaleWindow1;
/*上海售票窗口 */
@property (nonatomic, strong) NSThread *ticketSaleWindow2;

@end

@implementation NSOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"NSOperationViewController";
    
    //在当前线程使用子类 NSInvocationOperation
    //[self useInvocationOperation];
    
    //在其他线程使用子类NSInvocationOperation
    //[NSThread detachNewThreadSelector:@selector(useInvocationOperation) toTarget:self withObject:nil];
    
    //在当前线程使用NSBlockOperation
    //[self useBlockOperation];
    
    //使用NSBlockOperation的AddExecutionBlock:方法
    //[self useBlockOperationAddExecutionBlock];
    
    //使用自定义继承自NSOperation的子类
    //[self useCustomOperation];
    
    //使用addOperation:添加操作到队列中
    //[self addOperationToQueue];
    
    //使用addOperationWithBlock:添加操作到队列中
    //[self addOperationWithBlockToQueue];
    
    //设置最大并发操作数(MaxConcurrentOperationCount)
    //[self setMaxConcurrentOperationCount];
    
    //设置优先级
    //[self setQueuePriority];
    //添加依赖
    //[self addDependency];
    
    //线程间通信
    //[self communication];
    
    //完成操作
    //[self completionBlock];
    
    //不考虑线程安全
    //[self initTicketStatusNotSave];
    
    //考虑线程安全
    [self initTicketStatusSave];
}

/**
 使用子类 NSInvocationOperation
 */
-(void)useInvocationOperation{
    //1.创建NSInvocationOperation对象
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    //2.调用start方法开始执行操作
    [op start];
}

/**
 使用子类NSBlockOperation
 */
-(void)useBlockOperation{
    //1.创建NSBlockOperation对象
    WEAKSELF;
    NSBlockOperation* op = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf task1];
    }];
    //2.调用start方法开始执行操作
    [op start];
}

/**
 使用子类:NSBlockOperation
 调用方法:AddExecutionBlock:
 */
-(void)useBlockOperationAddExecutionBlock{
    //1.创建NSBlockOperation对象
    WEAKSELF;
    NSBlockOperation* op = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf task1];
    }];
    //2.添加额外的操作
    [op addExecutionBlock:^{
        [weakSelf task2];
    }];
    [op addExecutionBlock:^{
        [weakSelf taskWithIndex:3];
    }];
    [op addExecutionBlock:^{
        [weakSelf taskWithIndex:4];
    }];
    [op addExecutionBlock:^{
        [weakSelf taskWithIndex:5];
    }];
    [op addExecutionBlock:^{
        [weakSelf taskWithIndex:6];
    }];
    [op addExecutionBlock:^{
        [weakSelf taskWithIndex:7];
    }];
    [op addExecutionBlock:^{
        [weakSelf taskWithIndex:8];
    }];
    //3.调用start方法开始执行操作
    [op start];
}

/**
 使用自定义继承自NSOperation的子类
 */
-(void)useCustomOperation{
    //1.创建YSCOperation对象
    YSCOperation* op = [[YSCOperation alloc] init];
    //2.调用start方法开始执行操作
    [op start];
}

/**
 使用addOperation:将操作加入到操作队列中
 */
-(void)addOperationToQueue{
    //1.创建队列
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    //2.创建操作
    //使用NSInvocationOperation创建操作1
    NSInvocationOperation* op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    //使用NSInvocationOperation创建操作2
    NSInvocationOperation* op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task2) object:nil];
    //使用NSBlockOperation创建操作3
    WEAKSELF;
    NSBlockOperation* op3 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf taskWithIndex:3];
    }];
    [op3 addExecutionBlock:^{
        [weakSelf taskWithIndex:4];
    }];
    //3.使用addOperation：添加所有操作到队列中
    [queue addOperation:op1]; // [op1 start]
    [queue addOperation:op2]; // [op2 start]
    [queue addOperation:op3]; // [op3 start]
}

/**
 使用addOperationWithBlockToQueue
 */
-(void)addOperationWithBlockToQueue{
    //1.创建队列
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    //2.使用addOperationWithBlock：添加操作到队列中
    WEAKSELF;
    [queue addOperationWithBlock:^{
        [weakSelf taskWithIndex:1];
    }];
    [queue addOperationWithBlock:^{
        [weakSelf taskWithIndex:2];
    }];
    [queue addOperationWithBlock:^{
        [weakSelf taskWithIndex:3];
    }];
}

/**
 设置 MaxConcurrentOperationCount（最大并发操作数）
 */
-(void)setMaxConcurrentOperationCount{
    //1.创建队列
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    //2.设置最大并发操作数
    queue.maxConcurrentOperationCount = 1;//串行队列
    //queue.maxConcurrentOperationCount = 2;//并发队列
    //queue.maxConcurrentOperationCount = 8;//并发队列
    WEAKSELF;
    [queue addOperationWithBlock:^{
        [weakSelf taskWithIndex:1];
    }];
    [queue addOperationWithBlock:^{
        [weakSelf taskWithIndex:2];
    }];
    [queue addOperationWithBlock:^{
        [weakSelf taskWithIndex:3];
    }];
    [queue addOperationWithBlock:^{
        [weakSelf taskWithIndex:4];
    }];
}

/**
 设置优先级
 就绪状态下，优先级搞的会优先执行,但是执行时间长短并不是一定的,所以优先级搞的并不一定会先执行完毕
 */
-(void)setQueuePriority{
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    WEAKSELF;
    NSBlockOperation* op1 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf taskWithIndex:1];
    }];
    [op1 setQueuePriority:NSOperationQueuePriorityLow];
    NSBlockOperation* op2 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf taskWithIndex:2];
    }];
    [op2 setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [queue addOperation:op1];
    [queue addOperation:op2];
}

/**
 操作依赖
 使用方法：addDependency
 */
-(void)addDependency{
    //1.创建队列
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    //2.创建操作
    WEAKSELF;
    NSBlockOperation* op1 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf taskWithIndex:1];
    }];
    NSBlockOperation* op2 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf taskWithIndex:2];
    }];
    //3.添加依赖
    [op2 addDependency:op1];//让op2依赖op1,则先执行op1，再执行op2
    //4.添加操作到队列中
    [queue addOperation:op1];
    [queue addOperation:op2];
}

/**
 线程间通信
 */
-(void)communication{
    //1.创建队列
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    //2.添加操作
    WEAKSELF;
    [queue addOperationWithBlock:^{
        //异步进行耗时操作
        [weakSelf taskWithIndex:1];
        //回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //进行一些UI刷新等操作
            [weakSelf taskWithIndex:2];
        }];
    }];
    
}

/**
 完成操作completionBlock
 */
-(void)completionBlock{
    //1.创建队列
    NSOperationQueue* queue = [[NSOperationQueue alloc] init];
    //2.创建操作
    WEAKSELF;
    NSBlockOperation* op1 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf taskWithIndex:1];
    }];
    //3.添加完成操作
    op1.completionBlock = ^{
        [weakSelf taskWithIndex:2];
    };
    //4.添加操作到队列中
    [queue addOperation:op1];
}

/**
 非线程安全：不适用NSLock
 初始化火车票数量、卖票窗口(非线程安全)、并开始卖票
 */
-(void)initTicketStatusNotSave{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    self.ticketSurplusCount = 50;
    //1.创建queue1,queue1代表北京或者票售卖窗口
    NSOperationQueue* queue1 = [[NSOperationQueue alloc] init];
    queue1.maxConcurrentOperationCount = 1;
    //2.创建queue,queue2代表上海或者票售卖窗口
    NSOperationQueue* queue2 = [[NSOperationQueue alloc] init];
    queue1.maxConcurrentOperationCount = 1;
    //3.创建卖票操作op1
    WEAKSELF;
    NSBlockOperation* op1 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf saleTicketNotSafe];
    }];
    //4.创建卖票操作op2
    NSBlockOperation* op2 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf saleTicketNotSafe];
    }];
    //5.添加操作,开始卖票
    [queue1 addOperation:op1];
    [queue2 addOperation:op2];
}

/**
 售卖火车票(非线程安全)
 */
-(void)saleTicketNotSafe{
    while (1) {
        if (self.ticketSurplusCount>0) {
            //如果还有票,继续售票
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数:%d 窗口:%@", self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        }else{
            NSLog(@"所有火车票均已售完.");
            break;
        }
    }
}

/**
 线程安全:使用NSLock加锁
 初始化或者票数量、卖票窗口(线程安全)、并开始卖票
 */
-(void)initTicketStatusSave{
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    self.ticketSurplusCount = 50;
    
    self.lock = [[NSLock alloc] init];//初始化NSLock对象
    
    //1.创建queue1,queue1代表北京或者票售卖窗口
    NSOperationQueue* queue1 = [[NSOperationQueue alloc] init];
    queue1.maxConcurrentOperationCount = 1;
    //2.创建queue2,queue2代表上海或者票售卖窗口
    NSOperationQueue* queue2 = [[NSOperationQueue alloc] init];
    queue2.maxConcurrentOperationCount = 1;
    //3.创建卖票操作op1
    WEAKSELF;
    NSBlockOperation* op1 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf saleTicketSafe];
    }];
    //4.创建卖票操作op2
    NSBlockOperation* op2 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf saleTicketSafe];
    }];
    //5.添加操作,开始卖票
    [queue1 addOperation:op1];
    [queue2 addOperation:op2];
}

/**
 售卖火车票(线程安全)
 */
-(void)saleTicketSafe{
    while (1) {
        //加锁
        [self.lock lock];
        
        if (self.ticketSurplusCount>0) {
            //如果还有票,继续售票
            NSLog(@"---目前库存票数:%d",self.ticketSurplusCount);
            self.ticketSurplusCount--;
            NSLog(@"%@",[NSString stringWithFormat:@"[%@]卖出一张后剩余票数:%d",[NSThread currentThread],self.ticketSurplusCount]);
            [NSThread sleepForTimeInterval:0.2];
        }
        
        //解锁
        [self.lock unlock];
        
        if (self.ticketSurplusCount<=0) {
            NSLog(@"所有火车票均已售完...");
            break;
        }
    }
}


/**
 * 任务1
 */
- (void)task1 {
    for (int i = 0; i < 2; i++) {
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@", [NSThread currentThread]);     // 打印当前线程
    }
}

/**
 * 任务2
 */
- (void)task2 {
    for (int i = 0; i < 2; i++) {
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"2---%@", [NSThread currentThread]);     // 打印当前线程
    }
}

/**
 * 任务n
 */
- (void)taskWithIndex:(int)index {
    for (int i = 0; i < 2; i++) {
        [NSThread sleepForTimeInterval:2];             // 模拟耗时操作
        NSLog(@"%d---%@", index,[NSThread currentThread]);     // 打印当前线程
    }
}
@end
