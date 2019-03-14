
//
//  dispatch_after_ViewController.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/30.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "dispatch_after_ViewController.h"

@interface dispatch_after_ViewController ()
@property (nonatomic,strong) NSTimer *timer; //定时器
@end

@implementation dispatch_after_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"GCD中使用dispatch_after函数延迟处理任务";
    //[self func1];
    //[self func2];
    [self func3];
}

/**
 1 GCD中使用dispatch_after函数延迟处理任务
 */
-(void)func1{
    for (int i=0; i<10; i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"===延时操作[%d]===",i);
        });
    }
}
/**
 2 补充,NSObject中提供的线程延迟方法
 */
-(void)func2{
    [self performSelector:@selector(performSelectorAction) withObject:nil afterDelay:3.0];
}

int i=0;
-(void)performSelectorAction{
    NSLog(@"===performSelectorAction [%d]===",i);
    //打印了10次-关闭定时器
    if (i==9) {
        [self stopTimer];
    }
    
    i++;
}

/**
 3 <三>通过NSTimer来延迟线程执行
 */
-(void)func3{
    //init 初始化时候先关闭一下定时器
    [self stopTimer];
    
    //启动定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(performSelectorAction) userInfo:nil repeats:YES];//一直执行下去
}

/**
 页面销毁时候 勿忘关闭定时器
 */
-(void)dealloc{
    [self stopTimer];
}

/**
 关闭定时器
 */
-(void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
}

@end
