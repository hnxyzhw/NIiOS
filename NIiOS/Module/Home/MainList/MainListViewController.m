

//
//  MainListViewController.m
//  CBDemo
//
//  Created by nixs on 2019/1/15.
//  Copyright © 2019年 Lin Youwei. All rights reserved.
//

#import "MainListViewController.h"
#import "HomeModel.h"
#import "MainListTableViewCell.h"
#import "HomeDataSupport.h"

#import "SDCycleScrollView.h"
#import "NIWKWebViewController.h"
#import "SonViewController.h"//多继承问题探究
#import "QRCodeViewController.h"
#import "DemoTableViewController.h"
#import "DemoTableViewController2.h"//左滑删除
#import "DemoTableViewController3.h"//多选删除
#import "DemoTableViewController4.h"
#import "WXViewController.h"//朋友圈
#import "RegularViewController.h"//正则表达式
#import "asyncViewController.h"//异步加载图片
#import "dispatch_after_ViewController.h"//GCD中使用dispatch_after函数延迟处理任务
#import "GCDViewController.h"//iOS多线程GCD详尽总结
#import "NSOperationViewController.h"//GCD升级
#import "RunLoopViewController.h"//RunLoop
//文件下载
#import "NSDataDownloadSmallFileViewController.h"//使用NSData/NSURLConnection(已过时方法)
#import "使用NSURLSession的Block方法下载文件(一)/NSURLSessionBlockViewController.h"
#import "使用NSURLSession的delegate方法下载文件(二)/NSURLSessionDelegateViewController.h"
#import "使用NSURLSession断点下载(不支持离线)文件(三)/NSURLSessionVC3.h"
#import "使用NSURLSession断点下载(支持离线)文件(四)/NSURLSessionVC4.h"

#import "使用AF下载文件(一)/AFViewController1.h"
#import "使用AF下载断点下载(支持离线)(二)/AFViewController2.h"

#import "NILViewController.h"//iOS开发中nil、Nil、NULL和[NSNull null]的区别
#import "NIWebViewController.h"//集成自cocoapods引入第三方创建自定义NIWebViewController.h/m
#import "H5EnterModel.h"
#import "InstanceViewController.h"//单例
#import "StuModel.h"
#import "StuTools.h"
#import "Rabbit.h"
#import "PooCodeViewController.h"//图片验证码
#import "PlistViewController.h"//plist配置文件读写
#import "SnippetsViewController.h"//Xcode 10.1代码段使用
#import "ThreadViewController.h"
//手势解锁
#import "GestureViewController.h"
#import "GestureVerifyViewController.h"
#import "PCCircleViewConst.h"
#import "AESViewController.h"
#import "ModelViewController.h"
//cell高度自适应
#import "AutoCell1ViewController.h"
#import "AutoCell2ViewController.h"
//iOS中几种监听
#import "JTViewController.h"
//Masnory布局进一步理解
#import "MasnoryViewController.h"
//UICollectionView学习：详细博文：https://github.com/pro648/tips/wiki/UICollectionView及其新功能drag-and-drop
#import "NIUICollectionViewController.h"
#import "UICollectionViewController1.h"//UICollectionViewController系列文章一：https://www.cnblogs.com/ludashi/p/4791826.html
#import "UICollectionViewController(二)/UICollectionViewController2.h"//弹出自定义View里嵌套UICollectionView
#import "UICollectionViewController(三)/UICollectionViewController3.h"//截屏展示
#import "UICollectionViewController(四)瀑布流/UICollectionViewController4.h"//瀑布流

@interface MainListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray* arrayAll;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *arr;
@end

@implementation MainListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"UMP其他功能列表集合";
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化数据源
    [self refreshDataArray];
    //初始化表格
    [self setupTable];
    //表格刷新
    [self tableRefresh];
}
#pragma mark - 刷新表格数据源
-(void)refreshDataArray{
    #pragma mark - 从json文件里获取数据源
    [self.arr removeAllObjects];//清空数据集
//    self.arrayAll = (NSArray*)[NSObject NIDataFromJsonFileName:@"yuyanplus.json" andDataType:jsonArray];
//    for (int i=0; i<self.arrayAll.count; i++) {
//        HomeModel* homeModel = [HomeModel modelWithDictionary:self.arrayAll[i]];
//        [self.arr addObject:homeModel];
//    }
    HomeDataSupport *ds = [HomeDataSupport new];
    self.arr = [ds getDataSourceWithFileName:@"yuyanplus.json"];
    [self.tableView reloadData];
}
/**
 初始化表格
 */
-(void)setupTable{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.height = UITableViewAutomaticDimension;       //自动调整约束，性能非常低，灰常的卡
    self.tableView.estimatedRowHeight = 100.0;  //设置预估值
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerClass:NSClassFromString(@"MainListTableViewCell") forCellReuseIdentifier:@"MainListTableViewCell"];
    //重写tableView布局
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(0);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(0);
            make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(0);
        }
        make.leading.trailing.equalTo(self.view);
    }];
    self.tableView.sectionFooterHeight = 0;
}
-(void)tableRefresh{
    WEAKSELF;
    MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf refreshDataArray];
        //数据请求完成调用
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
    self.tableView.mj_header = header;
    MJRefreshBackNormalFooter* footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf refreshDataArray];
        //数据请求完成调用
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData]; // 无数据刷新样式
        //[weakSelf.tableView.mj_footer endRefreshing]; // 普通
        [weakSelf.tableView reloadData];
    }];
    self.tableView.mj_footer = footer;
}

/**
 区头布局
 */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* viewForHeader = [UIView new];
    HomeModel* homeModel = self.arr[section];
    UILabel* labViewForHeader = [UILabel new];
    labViewForHeader.font = [UIFont systemFontOfSize:12.0];
    labViewForHeader.text = homeModel.title;
    labViewForHeader.textColor = [UIColor redColor];
    labViewForHeader.textAlignment = NSTextAlignmentLeft;
    [viewForHeader addSubview:labViewForHeader];
    [labViewForHeader makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewForHeader.mas_top).offset(10);
        make.left.equalTo(viewForHeader.mas_left).offset(10);
        make.right.equalTo(viewForHeader.mas_right);
        make.bottom.equalTo(viewForHeader.mas_bottom).offset(-5);
    }];
    return viewForHeader;
}
//cell高度计算
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeModel* homeModel = self.arr[indexPath.section];
    ItemModel* itemModel = homeModel.item[indexPath.row];
    return itemModel.cellHeight;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HomeModel* homeModel = self.arr[section];
    return homeModel.body.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainListTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MainListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainListTableViewCell"];
    }
    HomeModel* homeModel = self.arr[indexPath.section];
    ItemModel* itemModel = homeModel.item[indexPath.row];
    [cell configCellData:itemModel];
    if (indexPath.section==6) {
        cell.contentTextView.textColor = [UIColor redColor];//多线程
        if (indexPath.row==7) {
            cell.contentTextView.textColor = [UIColor grayColor];
        }else if (indexPath.row>7) {
            cell.contentTextView.textColor = [UIColor blueColor];
        }
    }else if(indexPath.section==11){
        cell.contentTextView.textColor = [UIColor purpleColor];//UICollectionView
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HomeModel* homeModel = self.arr[indexPath.section];
    NSArray* arrayBody = homeModel.body;
    ///////////////////0.BaseViewController-基类封装相关//////////////////////////
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    
                    break;
                }
                case 1:{
                    SonViewController* vc2 = [[SonViewController alloc] init];
                    [self.navigationController pushViewController:vc2 animated:YES];
                    break;
                }
                case 2:{
                    //NILViewController* nilVC = [[NILViewController alloc] init];
                    H5EnterModel *model02 = [[H5EnterModel alloc] init];
                    model02.title = @"iOS开发中nil、Nil、NULL和[NSNull null]的区别";
                    model02.detailTitle = @"iOS中nil、Nil、NULL和[NSNull null]区别";
                    model02.url = [NSString stringWithFormat:@"file://%@",[[NSBundle mainBundle] pathForResource:@"nilNilNULL" ofType:@"html"]];
                    //新增了 X 关闭按钮的资源文件（图片资源）
                    //修改了源码里文件 JXBWebViewController.m line:265
                    //JXBWebViewController *niWebVC = [[JXBWebViewController alloc] initWithURLString:model1.url];
                    NIWebViewController *niWebVC02 = [[NIWebViewController alloc] initWithURLString:model02.url];
                    [self.navigationController pushViewController:niWebVC02 animated:YES];
                    break;
                }
                case 3:{
                    SnippetsViewController* snippetsVC = [SnippetsViewController new];
                    [self.navigationController pushViewController:snippetsVC animated:YES];
                    break;
                }
                default:{
                    [self.view makeToast:arrayBody[indexPath.row]];
                    break;
                }
            }
            break;
        }
            ///////////////////1.工具 & UI//////////////////////////
        case 1:{
            switch (indexPath.row) {
                case 0:{
                    NIWKWebViewController* webView = [[NIWKWebViewController alloc] init];
                    webView.urlString = @"https://nixinsheng.github.io/";
                    [self.navigationController pushViewController:webView animated:YES];
                    break;
                }
                case 1:{//#import "NIWebViewController.h"//集成自cocoapods引入第三方创建自定义NIWebViewController.h/m
                    
                    H5EnterModel *model1 = [[H5EnterModel alloc] init];
                    model1.title = @"百度";
                    model1.detailTitle = @"https://www.baidu.com";
                    model1.url = @"https://www.baidu.com";
                    //新增了 X 关闭按钮的资源文件（图片资源）
                    //修改了源码里文件 JXBWebViewController.m line:265
                    //JXBWebViewController *niWebVC = [[JXBWebViewController alloc] initWithURLString:model1.url];
                    NIWebViewController *niWebVC = [[NIWebViewController alloc] initWithURLString:model1.url];
                    [self.navigationController pushViewController:niWebVC animated:YES];
                    break;
                }
                case 2:{//#import "NIWebViewController.h"//集成自cocoapods引入第三方创建自定义NIWebViewController.h/m
                    
                    H5EnterModel *model2 = [[H5EnterModel alloc] init];
                    model2.title = @"交互测试";
                    model2.detailTitle = @"使用的本地h5.html文件";
                    model2.url = [NSString stringWithFormat:@"file://%@",[[NSBundle mainBundle] pathForResource:@"h5" ofType:@"html"]];
                    //新增了 X 关闭按钮的资源文件（图片资源）
                    //修改了源码里文件 JXBWebViewController.m line:265
                    //JXBWebViewController *niWebVC = [[JXBWebViewController alloc] initWithURLString:model1.url];
                    NIWebViewController *niWebVC2 = [[NIWebViewController alloc] initWithURLString:model2.url];
                    [self.navigationController pushViewController:niWebVC2 animated:YES];
                    break;
                }
                case 3:{
                    QRCodeViewController* vc3 = [[QRCodeViewController alloc] init];
                    [self.navigationController pushViewController:vc3 animated:YES];
                    break;
                }
                case 4:{// [1,4] iOS生成图片验证码
                    PooCodeViewController* pooCodeVC = [[PooCodeViewController alloc] init];
                    [self.navigationController pushViewController:pooCodeVC animated:YES];
                    break;
                }
                case 5:{// [1,5] //iOS plist文件操作,写入/删除/修改
                    PlistViewController* plistVC = [[PlistViewController alloc] init];
                    [self.navigationController pushViewController:plistVC animated:YES];
                    break;
                }
                case 6:{// [1,6] //MJExtension数据模型赋值注意问题
                    ModelViewController* modelVC = [[ModelViewController alloc] init];
                    [self.navigationController pushViewController:modelVC animated:YES];
                    break;
                }
                default:{
                    [self.view makeToast:arrayBody[indexPath.row]];
                    break;
                }
            }
            break;
        }
            ////////////////////2.iOS tableView表格操作相关/////////////////////////
        case 2:{
            switch (indexPath.row) {
                case 0:{
                    
                    break;
                }
                case 1:{
                    DemoTableViewController* demoTable = [[DemoTableViewController alloc] init];
                    [self.navigationController pushViewController:demoTable animated:YES];
                    break;
                }
                case 2:{
                    DemoTableViewController2* demoTable2 = [[DemoTableViewController2 alloc] init];
                    [self.navigationController pushViewController:demoTable2 animated:YES];
                    break;
                }
                case 3:{
                    DemoTableViewController3* demoTable3 = [[DemoTableViewController3 alloc] init];
                    [self.navigationController pushViewController:demoTable3 animated:YES];
                    break;
                }case 4:{
                    DemoTableViewController4* demoTable4 = [[DemoTableViewController4 alloc] init];
                    [self.navigationController pushViewController:demoTable4 animated:YES];
                    break;
                }
                    //AutoCell1ViewController
                case 5:{
                    AutoCell1ViewController* autoCell1VC = [[AutoCell1ViewController alloc] init];
                    [self.navigationController pushViewController:autoCell1VC animated:YES];
                    break;
                }
                    //iOS开发之多种Cell高度自适应实现方案的UI流畅度分析 https://www.cnblogs.com/ludashi/p/5895725.html
                case 6:{
                    AutoCell2ViewController* autoCell2VC = [[AutoCell2ViewController alloc] init];
                    [self.navigationController pushViewController:autoCell2VC animated:YES];
                    break;
                }
                default:{
                    [self.view makeToast:arrayBody[indexPath.row]];
                    break;
                }
            }
            break;
        }
            ////////////////////3.iOS微信朋友圈布局/////////////////////////
        case 3:{
            switch (indexPath.row) {
                case 0:{
                    WXViewController* wxVC = [WXViewController new];
                    [self.navigationController pushViewController:wxVC animated:YES];
                    break;
                }
                default:{
                    [self.view makeToast:arrayBody[indexPath.row]];
                    break;
                }
            }
            break;
        }
            /////////////////////4.生命周期&Block////////////////////////
        case 4:{
            switch (indexPath.row) {
                case 0:{
                    [self.view makeToast:@"详细请看:控制台打印信息."];
                    break;
                }
                case 1:{
                    
                    break;
                }
                case 2:{
                    //全局记录信息
                    StuModel* stuModel = [[StuModel alloc] initWithName:@"倪新生" andSex:@"男" andAge:28 andNo:@"15001291877"];
                    [StuTools sharedInstance].stuModel = stuModel;
                    
                    Rabbit* rabbit = [Rabbit sharedInstance];
                    rabbit.nameOfRabbit = @"小黑🐰，小白兔";
                    
                    InstanceViewController* instanceVC = [InstanceViewController new];
                    [self.navigationController pushViewController:instanceVC animated:YES];
                    break;
                }
                default:{
                    [self.view makeToast:arrayBody[indexPath.row]];
                    break;
                }
            }
            break;
        }
            /////////////////////5.正则表达式////////////////////////
        case 5:{
            switch (indexPath.row) {
                case 0:{
                    //还有一个第三方 正则判断用-这个抽时间搜寻一下研究复习下；
                    RegularViewController* regularVC= [RegularViewController new];
                    [self.navigationController pushViewController:regularVC animated:YES];
                    break;
                }
                case 1:{
                    
                    break;
                }
                default:{
                    [self.view makeToast:arrayBody[indexPath.row]];
                    break;
                }
            }
            break;
        }
        /////////////////////6.iOS多线程////////////////////////
        case 6:{
            switch (indexPath.row) {
                case 0:{
                    //非主线程，异步执行操作
                    asyncViewController* asyncVC = [[asyncViewController alloc] init];
                    [self.navigationController pushViewController:asyncVC animated:YES];
                    break;
                }case 1:{
                    // [1,5] GCD中使用dispatch_after函数延迟处理任务
                    dispatch_after_ViewController* dispatchVC = [[dispatch_after_ViewController alloc] init];
                    [self.navigationController pushViewController:dispatchVC animated:YES];
                    break;
                }case 2:{
                    ThreadViewController* threadVC = [ThreadViewController new];
                    [self.navigationController pushViewController:threadVC animated:YES];
                    break;
                }case 3:{
                    GCDViewController* gcdVC = [GCDViewController new];
                    [self.navigationController pushViewController:gcdVC animated:YES];
                    break;
                }case 4:{
                    NSOperationViewController* operVC = [NSOperationViewController new];
                    [self.navigationController pushViewController:operVC animated:YES];
                    break;
                }case 5:{
                    RunLoopViewController* runloopVC = [RunLoopViewController new];
                    [self.navigationController pushViewController:runloopVC animated:YES];
                    break;
                }case 6:{
                    //iOS应用之间的跳转 和 传值
                    [self.view makeToast:arrayBody[indexPath.row]];
                    break;
                }
                ////////////////////////////////iOS多线程实践如下////////////////////////////////////////
                case 7:{//"1.iOS 网络：『文件下载、断点下载』的实现（一）：NSURLConnection",
                    NSDataDownloadSmallFileViewController* nsDataDownloadSmallFileVC = [NSDataDownloadSmallFileViewController new];
                    [self.navigationController pushViewController:nsDataDownloadSmallFileVC animated:YES];
                    break;
                }
                case 8:{//"2.iOS 网络：『文件下载、断点下载』的实现（二）：NSURLSession/Block方法下载文件",
                    //[self.view makeToast:@"8"];
                    NSURLSessionBlockViewController* nsURLSessionBlockVC = [NSURLSessionBlockViewController new];
                    [self.navigationController pushViewController:nsURLSessionBlockVC animated:YES];
                    break;
                }
                case 9:{//"2.iOS 网络：『文件下载、断点下载』的实现（二）：NSURLSession/Delegate方法下载文件",
                    NSURLSessionDelegateViewController* nsURLSessionDelegateVC = [NSURLSessionDelegateViewController new];
                    [self.navigationController pushViewController:nsURLSessionDelegateVC animated:YES];
                    break;
                }
                case 10:{//"10.iOS 网络：『文件下载、断点下载』的实现（二）：NSURLSession/断点下载（不支持离线）文件",
                    NSURLSessionVC3* nsURLSessionVC3 = [NSURLSessionVC3 new];
                    [self.navigationController pushViewController:nsURLSessionVC3 animated:YES];
                    break;
                }
                case 11:{//"10.iOS 网络：『文件下载、断点下载』的实现（二）：NSURLSession/断点下载（不支持离线）文件",
                    NSURLSessionVC4* nsURLSessionVC4 = [NSURLSessionVC4 new];
                    [self.navigationController pushViewController:nsURLSessionVC4 animated:YES];
                    break;
                }
                case 12:{//"使用AFNetworking下载文件"
                    AFViewController1* afVC1=[AFViewController1 new];
                    [self.navigationController pushViewController:afVC1 animated:YES];
                    break;
                }case 13:{//"使用AFNetworking断点下载（支持离线）"
                    AFViewController2* afVC2=[AFViewController2 new];
                    [self.navigationController pushViewController:afVC2 animated:YES];
                    break;
                }
                default:{
                    [self.view makeToast:arrayBody[indexPath.row]];
                    break;
                }
            }
            break;
        }
            /////////////////////7.iOS手势解锁////////////////////////
        case 7:{
            switch (indexPath.row) {
                case 0:{
                    GestureViewController *gestureVc = [[GestureViewController alloc] init];
                    gestureVc.type = GestureViewControllerTypeSetting;
                    [self.navigationController pushViewController:gestureVc animated:YES];
                    break;
                }case 1:{
                    if ([[PCCircleViewConst getGestureWithKey:gestureFinalSaveKey] length]) {
                        GestureViewController *gestureVc = [[GestureViewController alloc] init];
                        [gestureVc setType:GestureViewControllerTypeLogin];
                        [self.navigationController pushViewController:gestureVc animated:YES];
                    } else {
                        
                        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:@"暂未设置手势密码，是否前往设置？" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                        UIAlertAction *set = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            GestureViewController *gestureVc = [[GestureViewController alloc] init];
                            gestureVc.type = GestureViewControllerTypeSetting;
                            [self.navigationController pushViewController:gestureVc animated:YES];
                        }];
                        [alertVc addAction:cancel];
                        [alertVc addAction:set];
                        [self presentViewController:alertVc animated:YES
                                         completion:nil];
                    }
                    break;
                }case 2:{
                    GestureVerifyViewController *gestureVerifyVc = [[GestureVerifyViewController alloc] init];
                    [self.navigationController pushViewController:gestureVerifyVc animated:YES];
                    break;
                }case 3:{
                    GestureVerifyViewController *gestureVerifyVc = [[GestureVerifyViewController alloc] init];
                    gestureVerifyVc.isToSetNewGesture = YES;
                    [self.navigationController pushViewController:gestureVerifyVc animated:YES];
                    break;
                }
                default:{
                    [self.view makeToast:arrayBody[indexPath.row]];
                    break;
                }
            }
            break;
        }
            /////////////////////8.iOS加密、解密////////////////////////
        case 8:{
            switch (indexPath.row) {
                case 0:{
                    AESViewController *aesVc = [[AESViewController alloc] init];
                    aesVc.labDes = arrayBody[indexPath.row];
                    [self.navigationController pushViewController:aesVc animated:YES];
                    break;
                }case 1:{
                    break;
                }
                default:{
                    [self.view makeToast:arrayBody[indexPath.row]];
                    break;
                }
            }
            break;
        }
        /////////////////////9.监听////////////////////////
        case 9:{
            switch (indexPath.row) {
                case 0:{
                    JTViewController* jtVC = [JTViewController new];
                    [self.navigationController pushViewController:jtVC animated:YES];
                    break;
                }
                case 1:{
                    
                    break;
                }
                default:{
                    [self.view makeToast:arrayBody[indexPath.row]];
                    break;
                }
            }
            break;
        }
        /////////////////////10.布局////////////////////////
        case 10:{
            switch (indexPath.row) {
                case 0:{
                    MasnoryViewController* masnoryVC = [MasnoryViewController new];
                    [self.navigationController pushViewController:masnoryVC animated:YES];
                    break;
                }
                case 1:{
                    
                    break;
                }
                default:{
                    [self.view makeToast:arrayBody[indexPath.row]];
                    break;
                }
            }
            break;
        }
        /////////////////////11.UICollectionView////////////////////////
        case 11:{
            switch (indexPath.row) {
                case 0:{
                    NIUICollectionViewController* niUICollectionVC = [NIUICollectionViewController new];
                    [self.navigationController pushViewController:niUICollectionVC animated:YES];
                    break;
                }
                case 1:{
                    UICollectionViewController1* collectionVC1 = [UICollectionViewController1 new];
                    [self.navigationController pushViewController:collectionVC1 animated:YES];
                    break;
                }
                case 2:{
                    UICollectionViewController2* collectionVC2 = [UICollectionViewController2 new];
                    [self.navigationController pushViewController:collectionVC2 animated:YES];
                    break;
                }
                case 3:{
                    UICollectionViewController3* collectionVC3 = [UICollectionViewController3 new];
                    [self.navigationController pushViewController:collectionVC3 animated:YES];
                    break;
                }
                case 4:{
                    UICollectionViewController4* collectionVC4 = [UICollectionViewController4 new];
                    [self.navigationController pushViewController:collectionVC4 animated:YES];
                    break;
                }
                default:{
                    [self.view makeToast:arrayBody[indexPath.row]];
                    break;
                }
            }
            break;
        }
        default:{
            [self.view makeToast:arrayBody[indexPath.row]];
            break;
        }
    }
}

/**
 push VC
 */
-(void)pushVC:(UIViewController*)vc{
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 可变数组懒加载
 */
-(NSMutableArray *)arr{
    if (!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}
@end
