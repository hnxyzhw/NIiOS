//
//  NSDataDownloadSmallFileViewController.m
//  NIiOS
//
//  Created by nixs on 2019/2/12.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "NSDataDownloadSmallFileViewController.h"

@interface NSDataDownloadSmallFileViewController ()<NSURLConnectionDataDelegate>
@property(nonatomic,strong) UIButton *btnDownLoadSmallFile;
@property(nonatomic,strong) UIButton *btnDownLoadSmallFileNSURLConnection;
//NSURLConnection下载大文件用
@property(nonatomic,strong) UIButton *btnNSURLConnectionDownloadBigFile;
@property(nonatomic,strong) UIButton *btnNSURLConnectionResumeDownloadFile;
@property(nonatomic,strong) UIProgressView *progressView;//下载进度条
@property(nonatomic,strong) UILabel *progressLabel;//下载进度条lab
//下载大文件用到属性
@property(nonatomic,assign) NSInteger fileLength;//文件总长度
@property(nonatomic,assign) NSInteger currentLength;//当前下载长度
@property(nonatomic,strong) NSFileHandle *fileHandle;//文件句柄对象

@property(nonatomic,strong) NSURLConnection *connection;//connection

@property(nonatomic,strong) UIImageView *imageView;
@end

@implementation NSDataDownloadSmallFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"使用NSData下载小文件";
    [self setupUI];
}

/**点击下载按钮 */
-(void)buttonClicked:(UIButton*)btn{
    [self.view makeToast:@"GCD异步（NSData的方式）下载小图片"];
    //在子线程中发送下载文件请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //创建下载路径
        NSURL* url = [NSURL URLWithString:@"https://upload-images.jianshu.io/upload_images/1877784-b4777f945878a0b9.jpg"];
        //NSData的dataWithContentOfURL：方法下载
        NSData* data = [NSData dataWithContentsOfURL:url];
        //下载完毕，回到主线程，刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = [UIImage imageWithData:data];
        });
    });
}

/**
 使用NSURLConnection下载小文件
 */
-(void)downloadByURLConnection:(UIButton*)btn{
    [self.view makeToast:@"NSURLConnection方式下载小图片,该方法在iOS9.0之后已经废除了，推荐NSURLSession"];
    //创建下载路径
    NSURL* url = [NSURL URLWithString:@"https://upload-images.jianshu.io/upload_images/1877784-b4777f945878a0b9.jpg"];
    //NSURLConnection发送异步Get请求,该方法在iOS9.0之后就废除了,推荐NSURLSession
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        self.imageView.image = [UIImage imageWithData:data];
        //可以在这里把下载的文件保存
    }];
}
/**
 使用NSURLConnection下载大文件
 */
-(void)downloadBigFileByURLConnection:(UIButton*)btn{
    btn.selected = !btn.isSelected;
    if (btn.selected) {
        //创建下载路径
        NSURL *url = [NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"];
        //NSURLConnection发送异步Get请求,并实现响应的代理方法,该方法在iOS9.0之后就废除了
        [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:url] delegate:self];
    }
}

/**
 点击按钮-使用NSURLConnection下载大文件(支持离线)
 */
-(void)resumeDownloadBtnClicked:(UIButton*)btn{
    //按钮状态取反
    btn.selected = !btn.isSelected;
    if (btn.selected) {//开始下载、继续下载
        [btn setTitle:@"下载中..." forState:UIControlStateNormal];
        //沙盒文件路径
        NSString* path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingString:@"QQ_V5.4.0.dmg"];
        NSInteger currentLength = [self fileLengthForPath:path];
        if (currentLength>0) {//继续下载
            self.currentLength = currentLength;
        }
        //创建下载URL
        NSURL *url = [NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"];
        //2.创建request请求
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
        //设置HTTP请求头中的Range
        NSString* range = [NSString stringWithFormat:@"bytes=%ld-",self.currentLength];
        [request setValue:range forHTTPHeaderField:@"Range"];
        //3.下载
        self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    }else{//暂停下载
        [btn setTitle:@"已暂停下载" forState:UIControlStateNormal];
        [self.connection cancel];
        self.connection = nil;
    }
}

/**
 获取已下载文件大小
 */
-(NSInteger)fileLengthForPath:(NSString*)path{
    NSInteger fileLength = 0;
    NSFileManager* fileManager = [[NSFileManager alloc] init];// default is not thread safe
    if ([fileManager fileExistsAtPath:path]) {
        NSError* error = nil;
        NSDictionary* fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileLength = [fileDict fileSize];
        }
    }
    return fileLength;
}

#pragma mark - <NSURLConnectionDelegate>实现方法
/**接收到响应的时候,创建一个空的沙盒文件*/
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(nonnull NSURLResponse *)response{
//    //获取下载文件的总长度
//    self.fileLength = response.expectedContentLength;
//    //沙盒文件
//    NSString* path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject]stringByAppendingPathComponent:@"QQ_V5.4.0.dmg"];
//    NSLog(@"file download to:%@",path);
//    //创建一个空的文件到沙盒中
//    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
//    //创建文件句柄
//    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
    
    //获得下载文件的总长度:请求下载的文件长度+当前已经下载的文件长度
    self.fileLength = response.expectedContentLength + self.currentLength;
    // 沙盒文件路径
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"QQ_V5.4.0.dmg"];
    NSLog(@"File downloaded to: %@",path);
    //创建一个空的文件到沙盒中
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        //如果没有下载文件的话,就创建一个文件,如果有下载文件的话，则不用重新创建（不然会覆盖掉之前的文件）
        [manager createFileAtPath:path contents:nil attributes:nil];
    }
    //创建文件句柄
    self.fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
}
/**接收到具体数据:把数据写入到沙盒文件中*/
-(void)connection:(NSURLConnection *)connection didReceiveData:(nonnull NSData *)data{
    //制定数据的写入位置-文件内容的最后面
    [self.fileHandle seekToEndOfFile];
    //向沙盒写入数据
    [self.fileHandle writeData:data];
    //拼接目前下载的-文件总长度
    self.currentLength+=data.length;
    //下载进度
    self.progressView.progress = 1.0*self.currentLength/self.fileLength;//当前下载长度/总长度
    self.progressLabel.text = [NSString stringWithFormat:@"当前下载进度:%.2f%%",100.0*self.currentLength/self.fileLength];
}

/*下载完文件之后调用：关闭文件、清空长度*/
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    //关闭fileHandle
    [self.fileHandle closeFile];
    self.fileHandle = nil;
    //清空长度
    self.currentLength = 0;
    self.fileLength = 0;
}

/**
 初始化UI
 */
-(void)setupUI{
    //1.使用NSData下载小文件
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor redColor];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setTitle:@"1.使用NSData下载小文件" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    NIViewSetRadius(button, 3)
    NIViewBorderRadius(button, 3, RGBCOLOR(0, 0, 0).CGColor)
    self.btnDownLoadSmallFile = button;

    [self.view addSubview:self.btnDownLoadSmallFile];
    [self.btnDownLoadSmallFile makeConstraints:^(MASConstraintMaker *make) {
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
    self.imageView.layer.borderColor = [UIColor purpleColor].CGColor;
    self.imageView.layer.borderWidth = 1;
    [self.view addSubview:self.imageView];
    [self.imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnDownLoadSmallFile.mas_bottom).offset(10);
        make.centerX.equalTo(self.view);
        make.width.equalTo(kScreenWidth/2);
        make.height.equalTo(kScreenWidth/2);
    }];
    //////////////////////////////////////////////////////////////////////
    //2.使用NSURLConnection下载小文件
    UIButton *buttonNSURLConnection = [[UIButton alloc] init];
    buttonNSURLConnection.backgroundColor = [UIColor redColor];
    buttonNSURLConnection.titleLabel.font = [UIFont systemFontOfSize:18];
    [buttonNSURLConnection setTitle:@"2.使用NSURLConnection下载'小'文件" forState:UIControlStateNormal];
    [buttonNSURLConnection setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonNSURLConnection addTarget:self action:@selector(downloadByURLConnection:) forControlEvents:UIControlEventTouchUpInside];
    NIViewSetRadius(buttonNSURLConnection, 3)
    NIViewBorderRadius(buttonNSURLConnection, 3, RGBCOLOR(0, 0, 0).CGColor)
    self.btnDownLoadSmallFileNSURLConnection = buttonNSURLConnection;
    [self.view addSubview:self.btnDownLoadSmallFileNSURLConnection];
    [self.btnDownLoadSmallFileNSURLConnection makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(50);
    }];
    //3.使用NSURLConnection下载大文件
    UIButton *buttonNSURLConnectionBigFile = [[UIButton alloc] init];
    buttonNSURLConnectionBigFile.backgroundColor = [UIColor redColor];
    buttonNSURLConnectionBigFile.titleLabel.font = [UIFont systemFontOfSize:18];
    [buttonNSURLConnectionBigFile setTitle:@"3.使用NSURLConnection下载'大'文件" forState:UIControlStateNormal];
    [buttonNSURLConnectionBigFile setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
    [buttonNSURLConnectionBigFile setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonNSURLConnectionBigFile addTarget:self action:@selector(downloadBigFileByURLConnection:) forControlEvents:UIControlEventTouchUpInside];
    NIViewSetRadius(buttonNSURLConnectionBigFile, 3)
    NIViewBorderRadius(buttonNSURLConnectionBigFile, 3, RGBCOLOR(0, 0, 0).CGColor)
    self.btnNSURLConnectionDownloadBigFile = buttonNSURLConnectionBigFile;
    [self.view addSubview:self.btnNSURLConnectionDownloadBigFile];
    [self.btnNSURLConnectionDownloadBigFile makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnDownLoadSmallFileNSURLConnection.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(50);
    }];
    //4.使用NSURLConnection断点下载（支持离线）
    UIButton *buttonNSURLConnectionResumeDownloadFile = [[UIButton alloc] init];
    buttonNSURLConnectionResumeDownloadFile.backgroundColor = [UIColor redColor];
    buttonNSURLConnectionResumeDownloadFile.titleLabel.font = [UIFont systemFontOfSize:12];
    [buttonNSURLConnectionResumeDownloadFile setTitle:@"4.使用NSURLConnection断点下载（支持离线）- 开始下载" forState:UIControlStateNormal];
    [buttonNSURLConnectionResumeDownloadFile setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonNSURLConnectionResumeDownloadFile setTitleColor:[UIColor greenColor] forState:UIControlStateSelected];
    [buttonNSURLConnectionResumeDownloadFile addTarget:self action:@selector(resumeDownloadBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    NIViewSetRadius(buttonNSURLConnectionResumeDownloadFile, 3)
    NIViewBorderRadius(buttonNSURLConnectionResumeDownloadFile, 3, RGBCOLOR(0, 0, 0).CGColor)
    self.btnNSURLConnectionResumeDownloadFile = buttonNSURLConnectionResumeDownloadFile;
    [self.view addSubview:self.btnNSURLConnectionResumeDownloadFile];
    [self.btnNSURLConnectionResumeDownloadFile makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnNSURLConnectionDownloadBigFile.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(50);
    }];
    
    //进度条
    self.progressView = [UIProgressView new];
    [self.view addSubview:self.progressView];
    [self.progressView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btnNSURLConnectionResumeDownloadFile.mas_bottom).offset(10);
        make.left.right.equalTo(self.btnNSURLConnectionDownloadBigFile);
        make.height.equalTo(20);
    }];
    //进度条下的提示文字
    self.progressLabel = [UILabel new];
    [self.view addSubview:self.progressLabel];
    [self.progressLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressView.mas_bottom).offset(5);
        make.left.right.height.equalTo(self.progressView);
    }];
}
@end
