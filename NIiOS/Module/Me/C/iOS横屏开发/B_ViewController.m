
//
//  B_ViewController.m
//  NIiOS
//
//  Created by nixs on 2019/3/20.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "B_ViewController.h"

@interface B_ViewController ()
@property(nonatomic,strong) UIView *navView;
@property(nonatomic,strong) UIButton *btnBack;
@property(nonatomic,strong) UILabel *labTitle;
@property(nonatomic,assign) BOOL isScreenRight;

@property(nonatomic,strong) UIButton *btnChangeOrientation;
@end

@implementation B_ViewController
-(BOOL)shouldAutorotate{
    return YES;
}
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskLandscapeLeft;
//}
////一开始的方向
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationLandscapeLeft;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //self.navigationItem.title = @"iOS横屏开发-B";
    [self setNavView];
    //方案二：利用KVC调用私有方法-横屏
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation)]) {
//        SEL selector = NSSelectorFromString(@"setOrientation:");
//        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
//        [invocation setSelector:selector];
//        [invocation setTarget:[UIDevice currentDevice]];
//        int val = UIInterfaceOrientationLandscapeRight;
//        [invocation setArgument:&val atIndex:2];
//        [invocation invoke];
//    }
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}
// 方法1：
//- (void)setInterfaceOrientation:(UIDeviceOrientation)orientation {
//    if ([[UIDevice currentDevice]   respondsToSelector:@selector(setOrientation:)]) {
//        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:orientation]
//                                    forKey:@"orientation"];
//    }
//}
//方法2：
- (void)setInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice
                                                                                instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
-(void)backWithBtn:(UIButton*)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)change:(NSNotification*)notification{
    CGFloat width=[UIScreen mainScreen].bounds.size.width;
    CGFloat height=[UIScreen mainScreen].bounds.size.height;
    if (width/height<1.0) {
        NSLog(@"竖屏");
        self.isScreenRight = NO;
    }else{
        NSLog(@"横屏");
        self.isScreenRight = YES;
    }
    [self.navView removeFromSuperview];
    [self setNavView];
}

-(void)setNavView{
    self.navView = [UIView new];
    self.navView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.navView];
    CGFloat nav_H = kStatusBarAndNavigationBarHeight;
    CGFloat bottom_Space = -5;
    if (self.isScreenRight) {
        nav_H = kNavigationBarHeight;
        bottom_Space = 0;
    }
    [self.navView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.equalTo(nav_H);
    }];
    self.btnBack = [UIButton new];
    [self.btnBack setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.btnBack addTarget:self action:@selector(backWithBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:self.btnBack];
    [self.btnBack makeConstraints:^(MASConstraintMaker *make) {
        make.height.with.equalTo(44);
        make.left.equalTo(self.navView).offset(24.5);
        make.bottom.equalTo(self.navView).offset(0);
    }];
    self.labTitle=[UILabel new];
    self.labTitle.text = @"iOS横屏开发-B";
    self.labTitle.textAlignment = NSTextAlignmentCenter;
    self.labTitle.textColor = [UIColor whiteColor];
    self.labTitle.font = [UIFont systemFontOfSize:15.f];
    [self.navView addSubview:self.labTitle];
    [self.labTitle makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.navView.mas_bottom).offset(bottom_Space);
        make.size.equalTo(CGSizeMake(kScreenWidth/2, 30));
        make.centerX.equalTo(self.navView);
    }];
    
    self.btnChangeOrientation=[UIButton new];
    self.btnChangeOrientation.backgroundColor = [UIColor redColor];
    [self.btnChangeOrientation setTitle:@"手动改变方向" forState:UIControlStateNormal];
    [self.btnChangeOrientation setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnChangeOrientation addTarget:self action:@selector(changeOrientation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnChangeOrientation];
    [self.btnChangeOrientation makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(40);
    }];
}
-(void)changeOrientation{
    [self setInterfaceOrientation:UIInterfaceOrientationLandscapeRight];
}
@end
