//
//  AFViewController2.m
//  NIiOS
//
//  Created by nixs on 2019/2/21.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "AFViewController2.h"
#import "AFNetworking.h"

@interface AFViewController2 ()
@property(nonatomic,strong) UIButton *btnNSURLSessionBlock;
/**下载进度条*/
@property(nonatomic,strong) UIProgressView *progressView;
/**下载进度条lab*/
@property(nonatomic,strong) UILabel *progressLabel;

/** AFNetworking断点下载（支持离线）需用到的属性 **********/
/** 文件的总长度 */
@property (nonatomic, assign) NSInteger fileLength;
/** 当前下载长度 */
@property (nonatomic, assign) NSInteger currentLength;
/** 文件句柄对象 */
@property (nonatomic, strong) NSFileHandle *fileHandle;

/** 下载任务 */
@property (nonatomic, strong) NSURLSessionDataTask *downloadTask;
/* AFURLSessionManager */
@property (nonatomic, strong) AFURLSessionManager *manager;
@end

@implementation AFViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"使用AF下载断点下载(支持离线)(二)";
    [self setupUI];
}
/**
 * manager的懒加载
 */
- (AFURLSessionManager *)manager {
    if (!_manager) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        // 1. 创建会话管理者
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    }
    return _manager;
}
/**
 * downloadTask的懒加载
 */
- (NSURLSessionDataTask *)downloadTask {
    if (!_downloadTask) {
        // 创建下载URL
        //NSURL *url = [NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"];
        NSURL* url = [NSURL URLWithString:@"http://10.37.129.2:8080/examples/QQ_V5.4.0.dmg"];//这里的地址是本地Tomcat启动后下载地址
        
        // 2.创建request请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        // 设置HTTP请求头中的Range
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-", self.currentLength];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        __weak typeof(self) weakSelf = self;
        _downloadTask = [self.manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            NSLog(@"dataTaskWithRequest");
            
            // 清空长度
            weakSelf.currentLength = 0;
            weakSelf.fileLength = 0;
            
            // 关闭fileHandle
            [weakSelf.fileHandle closeFile];
            weakSelf.fileHandle = nil;
            
        }];
        
        [self.manager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
            NSLog(@"NSURLSessionResponseDisposition");
            
            // 获得下载文件的总长度：请求下载的文件长度 + 当前已经下载的文件长度
            weakSelf.fileLength = response.expectedContentLength + self.currentLength;
            
            // 沙盒文件路径
            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"QQ_V5.4.0.dmg"];
            
            NSLog(@"File downloaded to: %@",path);
            
            // 创建一个空的文件到沙盒中
            NSFileManager *manager = [NSFileManager defaultManager];
            
            if (![manager fileExistsAtPath:path]) {
                // 如果没有下载文件的话，就创建一个文件。如果有下载文件的话，则不用重新创建(不然会覆盖掉之前的文件)
                [manager createFileAtPath:path contents:nil attributes:nil];
            }
            
            // 创建文件句柄
            weakSelf.fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
            
            // 允许处理服务器的响应，才会继续接收服务器返回的数据
            return NSURLSessionResponseAllow;
        }];
        
        [self.manager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
            NSLog(@"setDataTaskDidReceiveDataBlock");
            
            // 指定数据的写入位置 -- 文件内容的最后面
            [weakSelf.fileHandle seekToEndOfFile];
            
            // 向沙盒写入数据
            [weakSelf.fileHandle writeData:data];
            
            // 拼接文件总长度
            weakSelf.currentLength += data.length;
            
            // 获取主线程，不然无法正确显示进度。
            NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
            [mainQueue addOperationWithBlock:^{
                // 下载进度
                if (weakSelf.fileLength == 0) {
                    weakSelf.progressView.progress = 0.0;
                    weakSelf.progressLabel.text = [NSString stringWithFormat:@"当前下载进度:00.00%%"];
                } else {
                    weakSelf.progressView.progress =  1.0 * weakSelf.currentLength / weakSelf.fileLength;
                    weakSelf.progressLabel.text = [NSString stringWithFormat:@"当前下载进度:%.2f%%",100.0 * weakSelf.currentLength / weakSelf.fileLength];
                }
                
            }];
        }];
    }
    return _downloadTask;
}

/**
 * 点击按钮 -- 使用AFNetworking断点下载（支持离线）
 */
- (void)OfflinResumeDownloadBtnClicked:(UIButton *)sender {
    // 按钮状态取反
    sender.selected = !sender.isSelected;
    
    if (sender.selected) { // [开始下载/继续下载]
        // 沙盒文件路径
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"QQ_V5.4.0.dmg"];
        
        NSInteger currentLength = [self fileLengthForPath:path];
        if (currentLength > 0) {  // [继续下载]
            self.currentLength = currentLength;
        }
        
        [self.downloadTask resume];
        
    } else {
        [self.downloadTask suspend];
        self.downloadTask = nil;
    }
}

/**
 * 获取已下载的文件大小
 */
- (NSInteger)fileLengthForPath:(NSString *)path {
    NSInteger fileLength = 0;
    NSFileManager *fileManager = [[NSFileManager alloc] init]; // default is not thread safe
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileLength = [fileDict fileSize];
        }
    }
    return fileLength;
}
-(void)setupUI{
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor redColor];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:@"使用AF下载断点下载(支持离线)(二)" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//未选中
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];//选中
    [button addTarget:self action:@selector(OfflinResumeDownloadBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
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
}
@end
