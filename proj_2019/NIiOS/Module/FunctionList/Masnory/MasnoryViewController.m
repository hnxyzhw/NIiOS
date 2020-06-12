
//
//  MasnoryViewController.m
//  NIiOS
//
//  Created by nixs on 2019/1/31.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "MasnoryViewController.h"

@interface MasnoryViewController ()

@end

@implementation MasnoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}
-(void)setupUI{
    //示例1
    UIView* contentView = [UIView new];
    [contentView setBackgroundColor:[UIColor grayColor]];
    [self.view addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(20, 20, 20, 20));
    }];
    
    //示例2
    UIView* contentView2 = [UIView new];
    [contentView2 setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:contentView2];
    [contentView2 makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(10);
            make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(0);
        }
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
    }];
    
    //关于multipliedBy的使用，子视图是父视图的一半
    UIView* sonView = [UIView new];
    [sonView setBackgroundColor:[UIColor blueColor]];
    [contentView2 addSubview:sonView];
    [sonView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(contentView2);
        //make.width.height.equalTo(contentView2).multipliedBy(0.5);
        //同理如下
        make.size.equalTo(contentView2).multipliedBy(0.95);
    }];
    
    //动画
    UIView* sonView2 = [UIView new];
    [sonView2 setBackgroundColor:[UIColor purpleColor]];
    [sonView addSubview:sonView2];
    [UIView animateWithDuration:3 animations:^{
        [sonView2 makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(sonView);
            make.size.equalTo(sonView).multipliedBy(0.95);
        }];
        [sonView2.superview layoutIfNeeded];//强制绘制
    }];
    
    
    
}

@end
