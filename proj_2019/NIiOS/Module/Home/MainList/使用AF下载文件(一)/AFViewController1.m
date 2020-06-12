//
//  AFViewController1.m
//  NIiOS
//
//  Created by nixs on 2019/2/21.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "AFViewController1.h"
#import "AFNetworking.h"

@interface AFViewController1 ()
@property(nonatomic,strong) UIButton *btnNSURLSessionBlock;
/**下载进度条*/
@property(nonatomic,strong) UIProgressView *progressView;
/**下载进度条lab*/
@property(nonatomic,strong) UILabel *progressLabel;

@end

@implementation AFViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"AFNetworking下载文件";
    [self setupUI];
}
/**
 * 点击按钮 -- 使用AFNetworking下载文件
 */
- (void)downloadBtnClicked:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //1.创建会话管理者
    AFURLSessionManager* manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //2.创建下载路径和请求对象
    //NSURL *url = [NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"];
    NSURL* url = [NSURL URLWithString:@"http://10.37.129.2:8080/examples/QQ_V5.4.0.dmg"];//这里的地址是本地Tomcat启动后下载地址
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    //3.创建下载任务
    /**
     * 第一个参数 - request：请求对象
     * 第二个参数 - progress：下载进度block
     *      其中： downloadProgress.completedUnitCount：已经完成的大小
     *            downloadProgress.totalUnitCount：文件的总大小
     * 第三个参数 - destination：自动完成文件剪切操作
     *      其中： 返回值:该文件应该被剪切到哪里
     *            targetPath：临时路径 tmp NSURL
     *            response：响应头
     * 第四个参数 - completionHandler：下载完成回调
     *      其中： filePath：真实路径 == 第三个参数的返回值
     *            error:错误信息
     */
    NSURLSessionDownloadTask* downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //获取主线程，不然无法正确显示进度
        WEAKSELF;
        NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            //下载进度
            weakSelf.progressView.progress = 1.0*downloadProgress.completedUnitCount/downloadProgress.totalUnitCount;
            weakSelf.progressLabel.text = [NSString stringWithFormat:@"当前下载进度：%.2f%%",100.0*downloadProgress.completedUnitCount/downloadProgress.totalUnitCount];
        }];
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *path = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [path URLByAppendingPathComponent:@"QQ_V5.4.0.dmg"];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    //4.开启下载任务
    [downloadTask resume];
}



-(void)setupUI{
    UIButton *button = [[UIButton alloc] init];
    button.backgroundColor = [UIColor redColor];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitle:@"AFNetworking下载文件" forState:UIControlStateNormal];
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
}
@end
