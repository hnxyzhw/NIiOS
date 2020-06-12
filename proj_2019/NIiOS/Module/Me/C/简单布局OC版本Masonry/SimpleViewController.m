
//
//  SimpleViewController.m
//  NIiOS
//
//  Created by nixs on 2019/3/27.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "SimpleViewController.h"

@interface SimpleViewController ()
@property(nonatomic,strong) UIView* viewHori_1;
@property(nonatomic,strong) UIView* viewHori_2;
@property(nonatomic,strong) UIView* viewHori_3;

@property(nonatomic,strong) UIView* viewVerti_1;
@property(nonatomic,strong) UIView* viewVerti_2;
@property(nonatomic,strong) UIView* viewVerti_3;
@end

@implementation SimpleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"简单布局-和Android的线性布局对比";
    self.view.backgroundColor=[UIColor whiteColor];
    [self initUI];
}
-(void)initUI{
    CGFloat SC_H = kScreenHeight-kTabbarSafeBottomMargin;
    self.viewHori_1 = [UIView new];
    self.viewHori_1.backgroundColor = NIRandomColor;
    self.viewHori_2 = [UIView new];
    self.viewHori_2.backgroundColor = NIRandomColor;
    self.viewHori_3 = [UIView new];
    self.viewHori_3.backgroundColor = NIRandomColor;
    
    self.viewVerti_1 = [UIView new];
    self.viewVerti_1.backgroundColor = NIRandomColor;
    self.viewVerti_2 = [UIView new];
    self.viewVerti_2.backgroundColor = NIRandomColor;
    self.viewVerti_3 = [UIView new];
    self.viewVerti_3.backgroundColor = NIRandomColor;
    [self.view addSubview:self.viewHori_1];
    [self.view addSubview:self.viewHori_2];
    [self.view addSubview:self.viewHori_3];
    [self.view addSubview:self.viewVerti_1];
    [self.view addSubview:self.viewVerti_2];
    [self.view addSubview:self.viewVerti_3];
    [self.viewHori_1 makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(0);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(0);
        }
        make.height.equalTo(SC_H/2);
        make.width.equalTo(kScreenWidth/3-0.1);
        make.top.left.equalTo(self.view);
    }];
    [self.viewHori_2 makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self.viewHori_1);
        make.left.equalTo(self.viewHori_1.mas_right);
    }];
    [self.viewHori_3 makeConstraints:^(MASConstraintMaker *make) {
        make.top.width.height.equalTo(self.viewHori_1);
        make.left.equalTo(self.viewHori_2.mas_right);
    }];
    
    [self.viewVerti_1 makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewHori_1.mas_bottom);
        make.width.equalTo(kScreenWidth);
        make.height.equalTo(SC_H/(2*3));
        make.left.equalTo(self.view);
    }];
    [self.viewVerti_2 makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(self.viewVerti_1);
        make.top.equalTo(self.viewVerti_1.mas_bottom);
    }];
    [self.viewVerti_3 makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(self.viewVerti_1);
        make.top.equalTo(self.viewVerti_2.mas_bottom);
    }];
}

@end
