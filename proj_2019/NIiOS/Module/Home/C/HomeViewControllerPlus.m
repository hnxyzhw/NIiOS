//
//  HomeViewControllerPlus.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/27.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "HomeViewControllerPlus.h"
#import "HomeModel.h"
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


@interface HomeViewControllerPlus ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property (nonatomic,strong) NSArray* arrayAll;
@property (nonatomic,strong) SDCycleScrollView *sdCycleScrollView;//轮播图
@end

@implementation HomeViewControllerPlus
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    int m=0;
    for(int i=0;i<5;i++){
        m++;
        NSLog(@"===%d==",m);
    }
    
    self.view.backgroundColor = RGBACOLOR(195, 195, 195,0.8);//灰色
    //初始化数据源
    [self refreshDataArray];
    //初始化表格
    [self setupTable];
    //表格刷新
    [self tableRefresh];
    //头部轮播图
    [self setupCycleScrollView];
}

#pragma mark - 表格头视图
-(void)setupCycleScrollView{
    // 底部轮播图
    NSDictionary* dicSDCycleScrollView = (NSDictionary*)[NSObject NIDataFromJsonFileName:@"SDCycleScrollView.json" andDataType:jsonDictionary];
    NSArray *imagesURLStrings = dicSDCycleScrollView[@"imgUrlStrs"];
    NSArray *titles = dicSDCycleScrollView[@"titles"];
    CGFloat H_SDCycleScrollView = 200;
    if (IS_IPhoneX) {
        H_SDCycleScrollView = 250;
    }
    self.sdCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, H_SDCycleScrollView) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.sdCycleScrollView.delegate = self;
    self.sdCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;//运动方向
    self.sdCycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    self.sdCycleScrollView.titlesGroup = titles;
    self.sdCycleScrollView.imageURLStringsGroup = imagesURLStrings;
    self.tableView.tableHeaderView = self.sdCycleScrollView;
}
#pragma mark - 刷新表格数据源
-(void)refreshDataArray{
    #pragma mark - 从json文件里获取数据源
    [self.arr removeAllObjects];//清空数据集
    self.arrayAll = (NSArray*)[NSObject NIDataFromJsonFileName:@"yuyanplus.json" andDataType:jsonArray];
    for (int i=0; i<self.arrayAll.count; i++) {
        HomeModel* homeModel = [HomeModel modelWithDictionary:self.arrayAll[i]];
        [self.arr addObject:homeModel];
    }
}
/**
 初始化表格
 */
-(void)setupTable{
    [self setupTableViewWithUITableViewStyle:UITableViewStyleGrouped];
    //遵循表格代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //重写tableView布局
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(-kStatusBarHeight);
        if (@available(iOS 11.0, *)) {
            //make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(5);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-5);
        } else {
            //make.top.equalTo(self.mas_topLayoutGuide).offset(5);
            make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(-5);
        }
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
    UILabel* labViewForHeader = [UILabel labelWithFontSize:12.0 title:homeModel.title textColor:[UIColor redColor] textAlignment:NSTextAlignmentLeft];
    [viewForHeader addSubview:labViewForHeader];
    [labViewForHeader makeConstraints:^(MASConstraintMaker *make) {
        //make.edges.equalTo(viewForHeader);
        make.top.equalTo(viewForHeader.mas_top).offset(10);
        make.left.equalTo(viewForHeader.mas_left).offset(10);
        make.right.equalTo(viewForHeader.mas_right);
        make.bottom.equalTo(viewForHeader.mas_bottom).offset(-5);
    }];
    return viewForHeader;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.arr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HomeModel* homeModel = self.arr[section];
    return homeModel.body.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID = @"cellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    HomeModel* homeModel = self.arr[indexPath.section];
    NSArray* arrayBody = homeModel.body;
    cell.textLabel.text = arrayBody[indexPath.row];
    //cell.textLabel.font =[UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    //cell.textLabel.adjustsFontForContentSizeCategory = NO;
    //cell.textLabel.font = [UIFont systemFontOfSize:18];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
                            
                            break;
                        }case 4:{
                            
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
        default:{
            [self.view makeToast:arrayBody[indexPath.row]];
            break;            
        }
    }
}


@end
