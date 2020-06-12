//
//  NILViewController.m
//  NIiOS
//
//  Created by ai-nixs on 2018/12/3.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "NILViewController.h"

@interface NILViewController ()
@property(nonatomic,strong)UILabel* lab;
@property(nonatomic,strong)UIScrollView* scrollView;
@end

@implementation NILViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"iOS开发中nil、Nil、NULL和[NSNull null]的区别";
    [self setupView];
}
/**
 iOS开发中nil、Nil、NULL和[NSNull null]的区别
 */
-(void)setupView{
    self.scrollView = [UIScrollView new];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight*2);
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(5);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-5);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(5);
            make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(-5);
        }
        make.leading.equalTo(self.view).offset(5);
        make.trailing.equalTo(self.view).offset(-5);
    }];
    self.lab = [UILabel new];
    self.lab.backgroundColor = [UIColor grayColor];
    self.lab.text = [self getStr];
    self.lab.font=NIUIFontSize(12);
    self.lab.textColor = [UIColor blackColor];
    [self.scrollView addSubview:self.lab];
    [self.lab makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
    }];
    
}
-(NSString*)getStr{
    return [NSObject NIDataFromFileName:@"nil"];
}
@end
