//
//  NIBaseViewController.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/19.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "NIBaseViewController.h"
#import "NINetworkDetectionView.h"
#import "NIVersionManagerView.h"
#import "Reachability.h"

@interface NIBaseViewController ()
@property(nonatomic,strong)NINetWorkDetectionView* networkDetectionView;
@property(nonatomic,strong)NIVersionManagerView *versionManagerView;//自定义View版本比较
@property(nonatomic,strong)UIWindow* mainWindow;
@end

@implementation NIBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    #pragma mark - 所有Base视图背景色都是白色的
    //self.view.backgroundColor = RGBACOLOR(195, 195, 195,0.8);//灰色
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpMainUI];
    //初始化-版本控制自定义View
    [self setUpNIVersionManagerView];
    #pragma mark - 网络监测通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doSomeThingsOnNetStatus:) name:@"Reachable" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doSomeThingsOnNetStatus:) name:@"NotReachable" object:nil];
}
#pragma mark - 监测到网络变更要做操作
-(void)doSomeThingsOnNetStatus:(NSNotification *)notification{
    NSString *str = @"0";
    if([str isEqualToString:notification.userInfo[@"status"]]) {
        //网络异常或者断开连接
        //self.networkDetectionView.hidden = NO;
        //2019年02月21日13:56:38 这里把网络监测的 自定义View给隐藏了
        self.networkDetectionView.hidden = YES;
    }else{
        self.networkDetectionView.hidden = YES;
        [self versionCheck];
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Reachable" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NotReachable" object:nil];
}

- (void)setUpMainUI {
    //初始化-网络异常视图
    self.networkDetectionView = [[NINetWorkDetectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    //*自定义网络异常视图放到每个控制器视图-最上层
    UIWindow* mainWindow = [self lastWindow];
    [mainWindow addSubview:self.networkDetectionView];
    self.networkDetectionView.hidden = YES;
}
/**
 初始化-版本控制视图(自定义view版本比较)
 */
-(void)setUpNIVersionManagerView{
    self.versionManagerView = [[NIVersionManagerView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    //[self.view addSubview:self.versionManagerView];
    //*自定义网络异常视图放到每个控制器视图-最上层
    UIWindow* mainWindow = [self lastWindow];
    [mainWindow addSubview:self.versionManagerView];
    self.versionManagerView.hidden = YES;
}

/**
 iOS 应用获取最上层全屏 Window 的正确方法
 */
- (UIWindow *)lastWindow{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        if ([window isKindOfClass:[UIWindow class]] && CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            return window;
    }
    return [UIApplication sharedApplication].keyWindow;
}
/**
 版本判断
 */
-(void)versionCheck{
    if ([self isConnectionAvailable]) {
        //版本更新提示内容
        [self.versionManagerView setTitle:[NSString stringWithFormat:@"%@",kSafeString(versionTitle)]];//标题
        [self.versionManagerView setDesc:[NSString stringWithFormat:@"%@",kSafeString(versionDesc)]];//更新内容
        [self.versionManagerView.btnExit setTitle:@"暂不更新" forState:UIControlStateNormal];
        [self.versionManagerView.btnOK setTitle:@"立即更新" forState:UIControlStateNormal];
        
        self.versionManagerView.hidden = NO;
        WEAKSELF;
        [self.versionManagerView setBtnExitBlock:^{
            weakSelf.versionManagerView.hidden = YES;
            //退出程序
            //exit(0);
        }];
        [self.versionManagerView setBtnOKBlock:^{
            weakSelf.versionManagerView.hidden = NO;
            /* 选择强制更新，则跳转到APPstore进行更新 **/
            [weakSelf jumpToAppStoreWithURL:appStoreURL];
        }];
    }else{
        [self.view makeToast:@"无网络连接!"];
    }
}
/**
 跳转到AppStore
 @param urlStr 目标App在AppStore里地址
 */
-(void)jumpToAppStoreWithURL:(NSString*)urlStr{
    NSString *verUrl = [kSafeString(urlStr) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:verUrl]];
}

/**
 是否有网络(外网 可以连接上百度的外网)
 @return YES有外网；NO没有外网
 */
-(BOOL)isConnectionAvailable{
    BOOL isConnectTheInternet = YES;
    Reachability *reachConnect = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reachConnect currentReachabilityStatus]) {
        case NotReachable:
            //没有网络
            isConnectTheInternet = NO;
            NSLog(@"没有网络 (viewWillAppear) by:nixs");
            [self.view makeToast:@"没有网络"];
            break;
        case ReachableViaWiFi:
            //使用WiFi网络
            isConnectTheInternet = YES;
            NSLog(@"使用WiFi网络 (viewWillAppear) by:nixs");
            [self.view makeToast:@"WIFI网络"];
        case ReachableViaWWAN:
            //使用3g网络
            isConnectTheInternet = YES;
            NSLog(@"使用手机网络 (viewWillAppear) by:nixs");
            [self.view makeToast:@"手机网络"];
        default:
            break;
    }
    return isConnectTheInternet;
}

-(void)setupTableView{
    // 注册tableView
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    //self.tableView.delegate = self;
    //self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuide);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(10);
            make.bottom.equalTo(self.mas_bottomLayoutGuide);
        }
    }];
}
-(void)setupTableViewWithUITableViewStyle:(UITableViewStyle)tableViewStyle{
    // 注册tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:tableViewStyle];
    self.tableView.backgroundColor = [UIColor whiteColor];
    //self.tableView.delegate = self;
    //self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuide);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(10);
            make.bottom.equalTo(self.mas_bottomLayoutGuide);
        }
    }];
}

-(void)setupEmptyViewWithDesc:(NSString*)desc{
    //自定义空数据页面(View)
    self.emptyView = [[NIEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (NIIsEmpty(desc)) {
        self.emptyView.labDesc.text = @"暂无数据";
    }else{
        self.emptyView.labDesc.text = desc;
    }
    [self.view addSubview:self.emptyView];
    [self.emptyView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.tableView);
    }];
    //self.emptyView.hidden = YES;
}
#pragma mark - 数据源懒加载
-(NSMutableArray *)arr{
    if (!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}
@end
