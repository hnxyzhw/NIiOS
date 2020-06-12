
//
//  A_ViewController.m
//  NIiOS
//
//  Created by nixs on 2019/3/20.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "A_ViewController.h"
#import "B_ViewController.h"

@interface A_ViewController ()
@property(nonatomic,strong) UIButton *btnJumpToB_VC;
@end

@implementation A_ViewController
#pragma mark - 在界面A中，重写旋转方法和支持方向
-(BOOL)shouldAutorotate{
    return YES;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"iOS横屏开发-A";
    [self setupUI];
}
-(void)setupUI{
    self.btnJumpToB_VC = [UIButton new];
    self.btnJumpToB_VC.backgroundColor = [UIColor redColor];
    [self.btnJumpToB_VC setTitle:@"B_VC" forState:UIControlStateNormal];
    [self.btnJumpToB_VC addTarget:self action:@selector(btnJumpToB_VCClickedWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnJumpToB_VC];
    [self.btnJumpToB_VC makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        }
        make.centerX.equalTo(self.view);
        make.size.equalTo(CGSizeMake(kScreenWidth*0.9, 40));
    }];
}
-(void)btnJumpToB_VCClickedWithBtn:(UIButton*)btn{
    B_ViewController* bVC = [B_ViewController new];
    [self presentViewController:bVC animated:YES completion:nil];
}
@end
