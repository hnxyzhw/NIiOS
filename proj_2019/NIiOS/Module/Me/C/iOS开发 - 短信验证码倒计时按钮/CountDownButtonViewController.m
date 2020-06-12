

//
//  CountDownButtonViewController.m
//  NIiOS
//
//  Created by nixs on 2019/3/20.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "CountDownButtonViewController.h"
#import "NICoutDownButton.h"

@interface CountDownButtonViewController ()
@property(nonatomic,strong) NICoutDownButton* countDownButton;
@end

@implementation CountDownButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"iOS开发 - 短信验证码倒计时按钮";
    
    #pragma mark - * * * * * 纯代码展示 * * * * *
    // 按钮添加到界面
    self.countDownButton = [NICoutDownButton buttonWithType:UIButtonTypeCustom];
    [self.countDownButton setTitle:@"纯代码：获取验证码" forState:UIControlStateNormal];
    [self.countDownButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.countDownButton.layer.borderWidth = 1;
    self.countDownButton.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:self.countDownButton];
    [self.countDownButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_centerY).offset(-100);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(200, 50));
    }];
    WEAKSELF;
    // 先给按钮添加回调，然后再开始调用倒计时方法
    [self.countDownButton countDownButtonHandler:^(NICoutDownButton *countDownButton, NSInteger tag) {
        
        // 点击按钮后开始倒计时
        [countDownButton startCountDownWithSecond:10 countDownChanging:^NSString *(NICoutDownButton *countDownButton, NSUInteger second) {
            weakSelf.countDownButton.enabled = NO;
            weakSelf.countDownButton.backgroundColor = [UIColor grayColor];
            NSString *title = [NSString stringWithFormat:@"%zd 秒再获取",second];
            return title;
        } countDownFinished:^NSString *(NICoutDownButton *countDownButton, NSUInteger second) {
            weakSelf.countDownButton.enabled = YES;
            weakSelf.countDownButton.backgroundColor = [UIColor clearColor];
            return @"重新发送验证码";
        }];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
