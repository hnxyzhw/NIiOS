//
//  RunTimeViewController02.m
//  NIiOS
//
//  Created by nixs on 2019/3/1.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "RunTimeViewController02.h"
#define imageURL @"https://upload-images.jianshu.io/upload_images/301129-0effb1540c867185.jpg"

/**
 参考哦地址：https://www.jianshu.com/p/6ebda3cd8052
 */
@interface RunTimeViewController02 ()
@property(nonatomic,strong) UIImageView *imageViewHeader;
@end

@implementation RunTimeViewController02

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
}


-(void)setupUI{
    self.imageViewHeader = [UIImageView new];
    NIViewSetRadius(self.imageViewHeader, 5.0)
    UIColor *borderColor = [UIColor redColor];
    NIViewBorderRadius(self.imageViewHeader, 1, borderColor.CGColor)
    [self.view addSubview:self.imageViewHeader];
    [self.imageViewHeader makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        }
        make.centerX.equalTo(self.view);
        make.size.equalTo(CGSizeMake(kScreenWidth*0.6, kScreenWidth*0.6));
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data =[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageViewHeader.image = [UIImage imageWithData:data];
        });
    });
}
@end
