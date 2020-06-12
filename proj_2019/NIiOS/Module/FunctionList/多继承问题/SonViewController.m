//
//  SonViewController.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/20.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "SonViewController.h"
#import "Programmer2.h"
#import "Programmer2+Program.h"
#import "Programmer3.h"
//@class Artist;
#import "Artist.h"
#import "NIWKWebViewController.h"

@interface SonViewController ()
@property(nonatomic,strong)UIButton* btn;
@end

@implementation SonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"多继承问题探究";
    
    //[self fun0];
    //[self fun1];
    //[self fun2];
    [self fun3];
}

/**
 详情请看这里
 */
-(void)fun3{
    self.btn = [UIButton new];
    [self.btn setTitle:@"详情请看这里(本类里也有测试案例)" forState:UIControlStateNormal];
    [self.btn setBackgroundColor:[UIColor redColor]];
    [self.btn addTarget:self action:@selector(pushNIWKWebViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btn];
    [self.btn makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(5);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(5);
        }
        make.height.equalTo(50);
        make.leading.equalTo(self.view).offset(5);
        make.trailing.equalTo(self.view).offset(-5);
    }];
    NIViewSetRadius(self.btn, 5);
}

-(void)pushNIWKWebViewController{
    NIWKWebViewController* niWKWebVC = [[NIWKWebViewController alloc] init];
    niWKWebVC.urlString = @"https://www.jianshu.com/p/9601e84177a3";
    [self.navigationController pushViewController:niWKWebVC animated:YES];
}
/**
 Programmer3.h/m 直接消息转发
 */
-(void)fun2{
    Programmer3 *p3 = [[Programmer3 alloc] init];
    //在performSelector中使用NSSelectorFromString 会造成警告
    //可以使用设置不检测performSelector内存泄露关闭警告
    [p3 performSelector:NSSelectorFromString(@"sing") withObject:nil];
    //或者通过类型强转来是实现，无警告
    [(Artist*)p3 draw];
}

/**
 Program2+Program.h/m使用
 */
-(void)fun1{
    Programmer2* programmer2 = [Programmer2 new];
    programmer2.motto = @"programmer2的座右铭:好好学习天天向上!";
    NILog(@"===%@===",programmer2.motto);
    [programmer2 sing];
    [programmer2 draw];
    //Programmer2+Program.m里的私有方法是不能调用的；
}

-(void)fun0{
    //[self.view makeToast:@"2.继承自NIBaseViewController后 NIBaseTableViewController里自定义方法." duration:3.0 position:@"CSToastPositionCenter"];
    [self sayHello];//这里能调用二级 基类“NIBaseTableViewController”里的方法
    [self isConnectionAvailable];//这里能调用原始 基类“NIBaseViewController”里的方法
}

@end
