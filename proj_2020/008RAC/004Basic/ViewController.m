//
//  ViewController.m
//  004Basic
//
//  Created by ai-nixs on 2020/8/2.
//  Copyright © 2020 nixs. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Frame.h"
#import "TYPagerController.h"
#import "UIView+MBPHUD.h"
#import "DDCity.h"
#import <NITools-umbrella.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "Masonry.h"
#import "MyDemoPrintTest/PrintHello.h"

@interface ViewController ()<UITextFieldDelegate>
@property(nonatomic,strong) UIView *viewTop;
@property(nonatomic,strong) UIButton *btnNext;

//@property (nonatomic,copy) NSString *str;
@property (nonatomic,strong) NSString *str;
//结论：被strong修饰以后只是强指针引用，并未改变地址，所以str的值会随着strM进行变化，二者的地址也是相同的。
@property(nonatomic,strong) UITextField *textField;
@property(nonatomic,strong) NINetworkDetectionView *networkDetectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labTitle.text = @"首页";
    [self.view addSubview:self.viewTop];
    [self.view addSubview:self.btnNext];
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.btnNext.mas_bottom).offset(10);
        make.width.mas_equalTo(kScreenWidth-40);
        make.centerX.mas_equalTo(self.view);
    }];
    [self.view addSubview:self.networkDetectionView];
    //远程私有库引入调用
    PrintHello *ph = [PrintHello new];
    [ph NISay_Hello];
}


/// 页面跳转 没有用UINavigationController
-(void)nextPage{
    [self.view showHUDMessage:@"加载中..."];
    //UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"RAC" message:@"RAC-TEST" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"other", nil];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认" message:@"确认删除吗？" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //取消处理
        NSLog(@"---取消处理---");
    }];

    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //确认处理
        NSLog(@"---确定处理---");
    }];

    [alert addAction:action1];
    [alert addAction:action2];
    //[self.navigationController presentViewController:alert animated:YES completion:nil];
    [self presentViewController:alert animated:YES completion:nil];
}




/// UITextFieldDelegate
/// @param textField 代理实现-点击软键盘return键盘隐藏
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textField resignFirstResponder];
    return YES;
}
/// 懒加载
-(UITextField *)textField{
    if (!_textField) {
        _textField = [UITextField new];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.placeholder = @"请输入";
        _textField.delegate = self;
        [[_textField rac_signalForControlEvents:UIControlEventEditingChanged]subscribeNext:^(id x) {            
            NSLog(@"---UIControlEventEditingChanged---value:%@",[x text]);
        }];
        [[_textField rac_textSignal]subscribeNext:^(id x) {
            NSLog(@"---rac_textSignal---value:%@",x);
        }];
    }
    return _textField;
}

-(UIButton *)btnNext{
    if (!_btnNext) {
        _btnNext = [[UIButton alloc] initWithFrame:CGRectMake(20, self.viewTop.y+self.viewTop.height+5, kScreenWidth-40, 50)];
        [_btnNext setTitle:@"下一页" forState:UIControlStateNormal];
        [_btnNext setBackgroundColor:[UIColor redColor]];
        [_btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnNext addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
        [[_btnNext rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
                //btn点击事件
            [self.view showHUDMessage:@"btn RAC 点击事件"];
            //[self nextPage];
        }];
    }
    return _btnNext;
}

-(UIView *)viewTop{
    if (!_viewTop) {
        // w:100,h:100 居中
        _viewTop = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/2-50, self.labTitle.y+self.labTitle.height+1, 100, 100)];
        _viewTop.backgroundColor = [UIColor purpleColor];
    }
    return _viewTop;
}
-(NINetworkDetectionView *)networkDetectionView{
    if (!_networkDetectionView) {
        _networkDetectionView = [[NINetworkDetectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _networkDetectionView;
}

@end
