//
//  ViewController.m
//  004Basic
//
//  Created by ai-nixs on 2020/8/2.
//  Copyright © 2020 nixs. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Frame.h"

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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labTitle.text = @"首页";
    [self.view addSubview:self.viewTop];
    [self.view addSubview:self.btnNext];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textField resignFirstResponder];
    return YES;
}
/// 懒加载

-(UIButton *)btnNext2{
    if (!_btnNext2) {
        _btnNext2 = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btnNext2 setTitle:@"RAC学习" forState:UIControlStateNormal];
        [_btnNext2 setBackgroundColor:[UIColor redColor]];
        [_btnNext2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnNext2 addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
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
