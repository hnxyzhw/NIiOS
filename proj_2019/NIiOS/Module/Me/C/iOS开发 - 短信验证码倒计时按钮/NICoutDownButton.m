//
//  NICoutDownButton.m
//  NIiOS
//
//  Created by nixs on 2019/3/20.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "NICoutDownButton.h"
@interface NICoutDownButton(){
    NSTimer         *_timer;        //计时器
    NSDate          *_startDate;    //开始时间
    NSInteger       _second;        //剩余秒数
    NSUInteger      _totalSecond;   //总秒数
    
    CountDownChanging               _countDownChanging;
    CountDownFinished               _countDownFinished;
    TouchedCountDownButtonHandler   _touchedCountDownButtonHandler;
}
@end

@implementation NICoutDownButton
#pragma mark - * * * * * 给按钮添加点击事件 * * * * *

- (void)countDownButtonHandler:(TouchedCountDownButtonHandler)touchedCountDownButtonHandler{
    _touchedCountDownButtonHandler = [touchedCountDownButtonHandler copy];
    [self addTarget:self action:@selector(touched:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touched:(NICoutDownButton *)sender{
    UIButton* btn = sender;
    if (_touchedCountDownButtonHandler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_touchedCountDownButtonHandler(sender,btn.tag);
        });
    }
}

#pragma mark - * * * * * 开始倒计时 * * * * *

- (void)startCountDownWithSecond:(NSUInteger)totalSecond countDownChanging:(CountDownChanging)countDownChanging countDownFinished:(CountDownFinished)countDownFinished{
    self.enabled = NO;
    _totalSecond = totalSecond;
    _second = totalSecond;
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart:) userInfo:nil repeats:YES];
    _startDate = [NSDate date];
    _timer.fireDate = [NSDate distantPast];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    if (countDownChanging) {
        _countDownChanging = [countDownChanging copy];
    }
    if (countDownFinished) {
        _countDownFinished = [countDownFinished copy];
    }
}

#pragma mark - * * * * * private * * * * *

// 停止倒计时
- (void)stopCountDown{
    if (!_timer || ![_timer respondsToSelector:@selector(isValid)] || ![_timer isValid]) {
        return;
    }
    [_timer invalidate];
    _second = _totalSecond;
    if (_countDownFinished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *title = self->_countDownFinished(self,self->_totalSecond);
            [self setTitle:title forState:UIControlStateNormal];
            [self setTitle:title forState:UIControlStateDisabled];
        });
    }else {
        [self setTitle:@"重新发送验证码" forState:UIControlStateNormal];
        [self setTitle:@"重新发送验证码" forState:UIControlStateDisabled];
    }
    self.enabled = YES;
}

// 计时器开始
- (void)timerStart:(NSTimer *)theTimer{
    double deltaTime = [[NSDate date] timeIntervalSinceDate:_startDate];
    
    _second = _totalSecond - (NSInteger)(deltaTime+0.5) ;
    
    if (_second < 1) {
        [self stopCountDown];
    }else {
        if (_countDownChanging) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *title = self->_countDownChanging(self,self->_second);
                [self setTitle:title forState:UIControlStateNormal];
                [self setTitle:title forState:UIControlStateDisabled];
            });
        }else {
            NSString *title = [NSString stringWithFormat:@"%zd秒再获取",_second];
            [self setTitle:title forState:UIControlStateNormal];
            [self setTitle:title forState:UIControlStateDisabled];
            
        }
    }
}

@end
