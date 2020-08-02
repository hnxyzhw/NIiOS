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
// 屏幕
#define kScreenWidth [UIScreen mainScreen].bounds.size.width     //屏幕宽度
#define kScreenHeight [UIScreen mainScreen].bounds.size.height   //屏幕高度

@interface ViewController ()
@property(nonatomic,strong) UIView *viewTop;
@property(nonatomic,strong) UIButton *btnNext;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labTitle.text = @"首页";
    [self.view addSubview:self.viewTop];
    [self.view addSubview:self.btnNext];
}

/// 页面跳转 没有用UINavigationController
-(void)nextPage{
    [self presentViewController:[TYPagerController new] animated:YES completion:nil];
}
/// 懒加载
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
