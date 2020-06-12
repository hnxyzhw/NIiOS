//
//  NIWKWebViewController.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/19.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "NIWKWebViewController.h"
#import <WebKit/WebKit.h>
#import "NIEmptyView.h"//自定义网络加载失败视图

//#define kScreenWidth [UIScreen mainScreen].bounds.size.width
//#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface NIWKWebViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) WKWebViewConfiguration *wkConfig;
@property (nonatomic, strong) UIProgressView *progressView;//添加UIProgressView属性
@property (nonatomic, strong) NIEmptyView *emptyView;
@end

@implementation NIWKWebViewController

#pragma mark - 懒加载-初始化wkWebView
- (WKWebViewConfiguration *)wkConfig {
    if (!_wkConfig) {
        //初始化一个WKWebViewConfiguration对象
        _wkConfig = [[WKWebViewConfiguration alloc] init];
        //初始化偏好设置属性：preferences
        _wkConfig.preferences = [WKPreferences new];
        //The minimum font size in points default is 0;
        _wkConfig.preferences.minimumFontSize = 0;
        //是否支持JavaScript
        _wkConfig.preferences.javaScriptEnabled = YES;
        //不通过用户交互，是否可以打开窗口
        _wkConfig.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        // 检测各种特殊的字符串：比如电话、网站
        if (@available(iOS 10.0, *)) {//API_AVAILABLE(ios(10.0))
            //_wkConfig.dataDetectorTypes = UIDataDetectorTypeAll;
        }
        // 播放视频
        _wkConfig.allowsInlineMediaPlayback = YES;
        //
        _wkConfig.allowsPictureInPictureMediaPlayback = YES;
        // 交互对象设置
        _wkConfig.userContentController = [[WKUserContentController alloc] init];
    }
    return _wkConfig;
}
- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.wkConfig];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
        
        _wkWebView.opaque = NO;
        _wkWebView.backgroundColor = [UIColor clearColor];
        //滑动返回看这里
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        _wkWebView.allowsLinkPreview = YES;
        
        [self.view addSubview:_wkWebView];
        [_wkWebView makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuide);
            } else {
                make.top.equalTo(self.mas_topLayoutGuide);
                make.bottom.equalTo(self.mas_bottomLayoutGuide);
            }
        }];
    }
    return _wkWebView;
}
#pragma mark - 在dealloc中取消监听(移除观察者)
- (void)dealloc {
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.wkWebView removeObserver:self forKeyPath:@"title"];
}

#pragma mark - 隐藏tabBar-在本页面隐藏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"最新资讯";
    //2019年01月31日17:21:29 by:nixs
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存截图" style:UIBarButtonItemStyleDone target:self action:@selector(saveClick)];
    
    [self setupToolView];
    //2.初始化progressView
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.progressTintColor=[UIColor redColor];//进度颜色
    self.progressView.trackTintColor= [UIColor whiteColor];//设置未过进度部分的颜色
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view addSubview:self.progressView];
    [self.progressView makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(2);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(2);
        }
        make.height.equalTo(2);
    }];
    //添加KVO，WKWebView有一个属性estimatedProgress，就是当前网页加载的进度，所以监听这个属性。
    //TODO:kvo监听，获得页面title和加载进度值
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    //加载链接地址
    [self wkWebViewLoadRequestWithURLStr:self.urlString];
    
    
    self.emptyView = [[NIEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.emptyView.labDesc.text = @"网页加载失败";
    [self.view addSubview:self.emptyView];
    self.emptyView.hidden = YES;
    WEAKSELF;
    [self.emptyView setRefreshBlock:^{
        [weakSelf wkWebViewLoadRequestWithURLStr:weakSelf.urlString];
    }];
}
- (UIImage *)screenShotWithFrame:(CGRect )imageRect {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(kScreenWidth, kScreenHeight), NO, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenShotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenShotImage;
}
- (UIImage *)imageForWebView
{
    // 1.获取WebView的宽高
    //CGSize boundsSize = self.bounds.size;
    CGSize boundsSize = self.wkWebView.bounds.size;
    CGFloat boundsWidth = boundsSize.width;
    CGFloat boundsHeight = boundsSize.height;
    // 2.获取contentSize
    //CGSize contentSize = self.scrollView.contentSize;
    CGSize contentSize = self.wkWebView.scrollView.contentSize;
    CGFloat contentHeight = contentSize.height;
    // 3.保存原始偏移量，便于截图后复位
    CGPoint offset = self.wkWebView.scrollView.contentOffset;
    // 4.设置最初的偏移量为(0,0);
    [self.wkWebView.scrollView setContentOffset:CGPointMake(0, 0)];
    
    NSMutableArray *images = [NSMutableArray array];
    while (contentHeight > 0) {
        // 5.获取CGContext 5.获取CGContext
        UIGraphicsBeginImageContextWithOptions(boundsSize, NO, 0.0);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        // 6.渲染要截取的区域
        [self.wkWebView.layer renderInContext:ctx];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 7.截取的图片保存起来
        [images addObject:image];
        
        CGFloat offsetY = self.wkWebView.scrollView.contentOffset.y;
        [self.wkWebView.scrollView setContentOffset:CGPointMake(0, offsetY + boundsHeight)];
        contentHeight -= boundsHeight;
    }
    // 8 webView 恢复到之前的显示区域
    [self.wkWebView.scrollView setContentOffset:offset];
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize imageSize = CGSizeMake(contentSize.width * scale,
                                  contentSize.height * scale);
    // 9.根据设备的分辨率重新绘制、拼接成完整清晰图片
    UIGraphicsBeginImageContext(imageSize);
    [images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        [image drawInRect:CGRectMake(0,scale * boundsHeight * idx,scale * boundsWidth,scale * boundsHeight)];
    }];
    UIImage *fullImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return fullImage;
}
#pragma mark - 按钮监听 参考链接：https://www.jianshu.com/p/ba98b0ad1811
// 保存图片/屏幕截图到相册
- (void)saveClick {
    NSLog(@"保存到相册");
    //self.containerView
    //保存现有屏幕内容作为截图 到相册
    //UIImageWriteToSavedPhotosAlbum([self screenShotWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)], self,  @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    //webview截长图的有异常！！！
    UIImageWriteToSavedPhotosAlbum([self imageForWebView], self,  @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
// 保存相册回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    [self.view makeToast:msg duration:1.0 position:CSToastPositionCenter];
}

#pragma mark - 头部导航返回按钮更新
- (void)setupToolView {
    // 根据渲染颜色改变图片样式
    UIImage *leftBarImg = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:leftBarImg style:UIBarButtonItemStylePlain target:self action:@selector(goBackAction)];
}
#pragma mark - 监听 - 4.在监听方法中获取网页加载的进度，并将进度赋给progressView.progress
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.wkWebView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    }else if ([keyPath isEqualToString:@"title"]){//网页title
        if (object == self.wkWebView){
            self.navigationItem.title = self.wkWebView.title;
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
#pragma mark - WKWKNavigationDelegate Methods 开始加载-在WKWebViewd的代理中展示进度条，加载完成后隐藏进度条
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}
//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"加载完成");
    //加载完成后隐藏progressView
    self.progressView.hidden = YES;
    self.emptyView.hidden = YES;
}
//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
    self.emptyView.hidden = NO;
}
//页面跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //允许页面跳转
    NSLog(@"%@",navigationAction.request.URL);
    decisionHandler(WKNavigationActionPolicyAllow);
}
#pragma mark - Tool bar item action
- (void)goBackAction {
    if ([self.wkWebView canGoBack]) {
        [self.wkWebView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)goForwardAction {
    if ([self.wkWebView canGoForward]) {
        [self.wkWebView goForward];
    }
}
- (void)refreshAction {
    [self.wkWebView reload];
}
#pragma mark - start load web 加载网页
-(void)wkWebViewLoadRequestWithURLStr:(NSString*)urlStr{
    if (urlStr) {
        NSString *urlString;
        if ([urlStr containsString:@"http://"] || [urlStr containsString:@"https://"]) {
            urlString = [NSString stringWithFormat:@"%@",urlStr];
        }else {
            urlString = [NSString stringWithFormat:@"http://%@",urlStr];
        }
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        request.timeoutInterval = 15.0f;
        [self.wkWebView loadRequest:request];
    }
}

@end
