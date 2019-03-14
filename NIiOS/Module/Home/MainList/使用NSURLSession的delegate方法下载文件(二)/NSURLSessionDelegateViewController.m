

//
//  NSURLSessionDelegateViewController.m
//  NIiOS
//
//  Created by nixs on 2019/2/21.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "NSURLSessionDelegateViewController.h"

@interface NSURLSessionDelegateViewController()<NSURLSessionDownloadDelegate>
@property(nonatomic,strong) UITextField *textField;
@property(nonatomic,strong) UIButton *btnNSURLSessionBlock;

/**
 下载进度条
 */
@property(nonatomic,strong) UIProgressView *progressView;
/**
 下载进度条lab
 */
@property(nonatomic,strong) UILabel *progressLabel;
@end

@implementation NSURLSessionDelegateViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"NSURLSession/Delegate方法下载文件";
    [self setupUI];
    
}
-(void)downloadBtnClicked:(UIButton*)btn{
    //按钮状态取反
    btn.selected = !btn.isSelected;
    // 创建下载路径
    //NSURL *url = [NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"];//该地址已经被屏蔽
    NSURL* url = [NSURL URLWithString:@"http://10.37.129.2:8080/examples/QQ_V5.4.0.dmg"];
    //创建NSURLSession对象,并设计代理方法,其中NSURLSessionConfiguration为默认设置
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    //创建任务
    NSURLSessionDownloadTask* downloadTask = [session downloadTaskWithURL:url];
    if (btn.selected) {
        //开始任务
        [downloadTask resume];
    }
}
#pragma mark - <NSURLSessionDownloadDelegate>实现方法

/**
 文件下载完毕调用
 */
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    //文件将要移动到的制定目录
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //新文件路径
    NSString* newFilePath = [documentsPath stringByAppendingString:@"/QQ_V5.4.0.dmg"];
    NSLog(@"File download to:%@",newFilePath);
    //移动文件到新路径
    [[NSFileManager defaultManager] moveItemAtPath:location.path toPath:newFilePath error:nil];
}

/**
 每次写入数据到临时文件时,就会调用一次这个方法。可在这里获取下载进度
 
 @param bytesWritten 这次写入的文件大小
 @param totalBytesWritten 已经写入沙盒的文件大小
 @param totalBytesExpectedToWrite 文件总大小
 */
-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    //下载进度
    self.progressView.progress = 1.0* totalBytesWritten/totalBytesExpectedToWrite;
    self.progressLabel.text = [NSString stringWithFormat:@"当前下载进度：%.2f%%",100.0*totalBytesWritten/totalBytesExpectedToWrite];
}
/**
 *  恢复下载后调用
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes{
    
}

-(void)setupUI{
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor redColor];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:@"NSURLSession/Delegate方法下载文件" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//未选中
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];//选中
    [button addTarget:self action:@selector(downloadBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
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
    self.progressView = [UIProgressView new];
    [self.view addSubview:self.progressView];
    [self.progressView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnNSURLSessionBlock.mas_bottom).offset(10);
        make.left.right.equalTo(self.btnNSURLSessionBlock);
        make.height.equalTo(5);
    }];
    self.progressLabel = [UILabel new];
    self.progressLabel.text = @"当前下载进度:00.00%";
    [self.view addSubview:self.progressLabel];
    [self.progressLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressView.mas_bottom).offset(10);
        make.left.right.equalTo(self.progressView);
        make.height.equalTo(30);
    }];
    
    self.textField = [UITextField new];
    self.textField.placeholder = @"这里纯粹用来简单测试";
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.layer.borderWidth = 1;
    self.textField.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:self.textField];
    [self.textField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.progressLabel);
        make.height.equalTo(50);
    }];
}
@end
