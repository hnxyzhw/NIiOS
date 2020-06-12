//
//  asyncViewController.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/29.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "asyncViewController.h"

@interface asyncViewController ()
@property(nonatomic,strong)UIImageView* imageView;

@end

@implementation asyncViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.navigationItem.title = @"异步加载图片到UI上";
    
    self.imageView = [UIImageView new];
    [self.view addSubview:self.imageView];
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(5);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(5);
        }
        make.leading.equalTo(self.view).offset(5);
        make.trailing.equalTo(self.view).offset(-5);
    }];
    
    [self asyncFunc];
}

/**
 异步处理
 dispatch_async(dispatch_get_global_queue(0, 0), ^{
    // 处理耗时操作的代码块...
 
    //通知主线程刷新
    dispatch_async(dispatch_get_main_queue(), ^{
        //回调或者说是通知主线程刷新，
 
    });
 };
 */
-(void)asyncFunc{    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSURL * url = [NSURL URLWithString:@"http://avatar.csdn.net/2/C/D/1_totogo2010.jpg"];
    NSData * data = [[NSData alloc]initWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc]initWithData:data];
    if (data != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
    }
    });
}
                   
@end
