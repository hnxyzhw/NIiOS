//
//  ViewController.m
//  004Basic
//
//  Created by ai-nixs on 2020/8/2.
//  Copyright © 2020 nixs. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Frame.h"
#import "UIView+MBPHUD.h"
#import "Masonry.h"
//#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ReactiveCocoa.h"
@import M13Checkbox;

// 屏幕
#define kScreenWidth [UIScreen mainScreen].bounds.size.width     //屏幕宽度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height   //屏幕高度

#define LRWeakSelf(type)  __weak typeof(type) weak##type = type;
#define LRStrongSelf(type)  __strong typeof(type) type = weak##type;

@interface ViewController ()<UITextFieldDelegate>
@property(nonatomic,strong) UIView *viewTop;
@property(nonatomic,strong) UIButton *btnNext;
@property(nonatomic,strong) UIButton *btnNext2;
@property(nonatomic,strong) UITextField *textField;

@property(nonatomic,strong) M13Checkbox *checkbox;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labTitle.text = @"首页";
    [self.view addSubview:self.viewTop];
    [self.view addSubview:self.btnNext];
    
    [self.view addSubview:self.btnNext2];
    [self.btnNext2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.btnNext.mas_bottom).offset(5);
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
        make.height.equalTo(@50);
    }];
    
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.btnNext2.mas_bottom).offset(2);
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
        make.height.equalTo(@50);
    }];
    //[self.view rac_signalForSelector:@selector(textFieldShouldReturn:)];
    [self.view addSubview:self.checkbox];
    [self.checkbox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textField.mas_bottom).offset(2);
        make.left.mas_equalTo(self.view).offset(10);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
}


-(M13Checkbox *)checkbox{
    if (!_checkbox) {
        _checkbox = [[M13Checkbox alloc] init];
        [_checkbox set_IBBoxType:@"Square"];
        [_checkbox setTintColor:[UIColor redColor]];
        [_checkbox setSecondaryTintColor:[UIColor blueColor]];
        [_checkbox addTarget:self action:@selector(checkChangeVlaue:) forControlEvents:UIControlEventValueChanged];
    }
    return _checkbox;
}
-(void)checkChangeVlaue:(id)sender{
    NSLog(@"---self.checkbox.state:%@",self.checkbox._IBCheckState);
}
/// 页面跳转 没有用UINavigationController
-(void)nextPage{
    [self.view showHUDMessage:@"加载中..."];    
    //[self presentViewController:[TYPagerController new] animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view hideHUD];
        //[self presentViewController:[TYPagerController new] animated:YES completion:nil];
    });
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
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
            NSLog(@"---changed---text=%@",[x text]);
        }];
    }
    return _textField;
}

-(UIButton *)btnNext2{
    if (!_btnNext2) {
        _btnNext2 = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnNext2 setTitle:@"RAC学习" forState:UIControlStateNormal];
        [_btnNext2 setBackgroundColor:[UIColor redColor]];
        [_btnNext2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //[_btnNext2 addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
        
        LRWeakSelf(self)
        [[_btnNext2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            LRStrongSelf(self)
            [self.view showHUDMessage:@"---_btnNext2点击事件响应---"];
        }];
    }
    return _btnNext2;
}
-(UIButton *)btnNext{
    if (!_btnNext) {
        _btnNext = [[UIButton alloc] initWithFrame:CGRectMake(20, self.viewTop.y+self.viewTop.height+5, kScreenWidth-40, 50)];
        [_btnNext setTitle:@"下一页" forState:UIControlStateNormal];
        [_btnNext setBackgroundColor:[UIColor redColor]];
        [_btnNext setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnNext addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
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


@end
