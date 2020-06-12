//
//  HomeViewController.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/19.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "HomeViewController.h"
#import "SDCycleScrollView.h"
#import "NIWKWebViewController.h"
#import "SonViewController.h"//多继承问题探究
#import "QRCodeViewController.h"
#import "DemoTableViewController.h"
#import "DemoTableViewController2.h"//左滑删除
#import "DemoTableViewController3.h"//多选删除

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property(nonatomic,strong)NSString* titleTable;
@property(nonatomic,strong)NSString* tailTable;
@property (nonatomic,strong) SDCycleScrollView *sdCycleScrollView;//轮播图
@end

@implementation HomeViewController
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
    self.view.backgroundColor = RGBACOLOR(195, 195, 195,0.8);//灰色
    //初始化数据源
    [self refreshDataArray];
    //初始化addTableView
    [self setupTableView];
    //遵循代理
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
    
    [self setupCycleScrollView];
    
    //初始化emptyView
    [self setupEmptyViewWithDesc:nil];
    self.emptyView.hidden = YES;
    
    //自定义空白页里的-点击刷新按钮
    [self.emptyView setRefreshBlock:^{
        [weakSelf refreshDataArray];
        [weakSelf.tableView reloadData];
        [weakSelf.view makeToast:@"重新加载完成"];
    }];
    
}

#pragma mark - 表格头视图
-(void)setupCycleScrollView{
    // 底部轮播图
    NSDictionary* dicSDCycleScrollView = (NSDictionary*)[NSObject NIDataFromJsonFileName:@"SDCycleScrollView.json" andDataType:jsonDictionary];
    NSArray *imagesURLStrings = dicSDCycleScrollView[@"imgUrlStrs"];
    NSArray *titles = dicSDCycleScrollView[@"titles"];
    self.sdCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 250) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.sdCycleScrollView.delegate = self;
    self.sdCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;//运动方向
    self.sdCycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    self.sdCycleScrollView.titlesGroup = titles;
    self.sdCycleScrollView.imageURLStringsGroup = imagesURLStrings;    
    self.tableView.tableHeaderView = self.sdCycleScrollView;
}
#pragma mark - 表格尾部视图
-(void)setupTableTailView{
    UIView* tailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    tailView.backgroundColor = RGBACOLOR(195, 195, 195,0.8);//灰色
    UILabel* labDescTail = [UILabel new];
    labDescTail.text = @"我是表格的尾部视图";
    labDescTail.textColor = [UIColor redColor];
    [tailView addSubview:labDescTail];
    [labDescTail makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(30);
        make.leading.equalTo(tailView).offset(20);
        make.centerY.equalTo(tailView);
    }];
    self.tableView.tableFooterView = tailView;
}
#pragma mark - 刷新表格数据源
-(void)refreshDataArray{
    #pragma mark - 从json文件里获取数据源
    NSDictionary* dicYUYAN = (NSDictionary*)[NSObject NIDataFromJsonFileName:@"yuyan.json" andDataType:jsonDictionary];
    self.titleTable = dicYUYAN[@"title"];
    [self.arr removeAllObjects];
    [self.arr addObjectsFromArray:(NSArray*)dicYUYAN[@"body"]];
    self.tailTable = dicYUYAN[@"tail"];
}
#pragma mark - tableView代理数据源
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //FIXME: 模型赋值
    if (self.arr.count==0) {
        self.emptyView.hidden = NO;
    }
    return self.arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //定义个静态字符串为了防止与其他类的tableivew重复
    static NSString *CellIdentifier = @"Cell";
    //定义cell的复用性当处理大量数据时减少内存开销
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell ==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (self.arr.count>0) {
        cell.textLabel.text = self.arr[indexPath.row];
        switch (indexPath.row) {
            case 4:{
                cell.textLabel.textColor = [UIColor purpleColor];
                break;
            }case 5:{
                cell.textLabel.textColor = [UIColor purpleColor];
                break;
            }case 6:{
                cell.textLabel.textColor = [UIColor purpleColor];
                break;
            }
            case 7:{
                cell.textLabel.textColor = [UIColor purpleColor];
                break;
            }
            default:{
                cell.textLabel.textColor = [UIColor blackColor];
                break;
            }
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.arr.count>0) {
        //[self.view makeToast:self.arr[indexPath.row]];
    }
    switch (indexPath.row) {
        case 1:{
            NIWKWebViewController* webView = [[NIWKWebViewController alloc] init];
            webView.urlString = @"https://nixinsheng.github.io/";
            [self.navigationController pushViewController:webView animated:YES];
            break;
        }
        case 2:{
            SonViewController* vc2 = [[SonViewController alloc] init];
            [self.navigationController pushViewController:vc2 animated:YES];
            break;
        }
        case 3:{
            QRCodeViewController* vc3 = [[QRCodeViewController alloc] init];
            [self.navigationController pushViewController:vc3 animated:YES];
            break;
        }
        case 5:{
            DemoTableViewController* vc5 = [[DemoTableViewController alloc] init];
            [self.navigationController pushViewController:vc5 animated:YES];
            break;
        }
        case 6:{
            DemoTableViewController2* vc6 = [[DemoTableViewController2 alloc] init];
            [self.navigationController pushViewController:vc6 animated:YES];
            break;
        }
        case 7:{
            DemoTableViewController3* vc7 = [[DemoTableViewController3 alloc] init];
            [self.navigationController pushViewController:vc7 animated:YES];
            break;
        }
        default:{
            [self.view makeToast:self.arr[indexPath.row]];
            break;
        }
            
    }
}

@end
