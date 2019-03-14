
//
//  NSURLSessionBlockViewController.m
//  NIiOS
//
//  Created by nixs on 2019/2/20.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "NSURLSessionBlockViewController.h"

@interface NSURLSessionBlockViewController ()
@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UIButton *btnNSURLSessionBlock;
@end

@implementation NSURLSessionBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"NSURLSession/Block方法下载文件";
    [self setupUI];
    
}
-(void)buttonClicked:(UIButton*)btn{
    //按钮状态取反
    btn.selected = !btn.isSelected;
    if (btn.selected) {
        // 创建下载路径
        NSURL *url = [NSURL URLWithString:@"https://upload-images.jianshu.io/upload_images/1877784-b4777f945878a0b9.jpg"];
        //创建NSURLSession对象
        NSURLSession* session = [NSURLSession sharedSession];
        //创建下载任务,其中location未下载的临时文件路径
        NSURLSessionDownloadTask* downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            //文件将要移动到的制定目录
            NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
            //新文件路径
            NSString* newFilePath = [documentsPath stringByAppendingString:@"/1877784-b4777f945878a0b9.jpg"];
            NSLog(@"File download to:%@",newFilePath);
            //移动文件到新路径
            [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:newFilePath error:nil];
            //回到主线程刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = [UIImage imageWithContentsOfFile:newFilePath];
            });
        }];
        //开始下载任务
        [downloadTask resume];
    }
}
-(void)setupUI{
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor redColor];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:@"NSURLSession/Block方法下载文件" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//未选中
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];//选中
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    NIViewSetRadius(button, 5)
    UIColor *borderColor = [UIColor blackColor];
    NIViewBorderRadius(button, 2, borderColor.CGColor)
    self.btnNSURLSessionBlock = button;
    [self.view addSubview:self.btnNSURLSessionBlock];
    [self.btnNSURLSessionBlock makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        }
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(50);
    }];
    self.imageView = [UIImageView new];
    NIViewBorderRadius(self.imageView, 2, borderColor.CGColor)
    [self.view addSubview:self.imageView];
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnNSURLSessionBlock.mas_bottom).offset(10);
        make.left.right.equalTo(self.btnNSURLSessionBlock);
        make.height.equalTo(kScreenWidth*0.7);
    }];
}
@end
