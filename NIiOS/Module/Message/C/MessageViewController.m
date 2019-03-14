//
//  MessageViewController.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/19.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "MessageViewController.h"
#import "HomeModel.h"
#import "MainListTableViewCell.h"
#import "HomeDataSupport.h"

#pragma mark - RunTime
#import "Runtime-iOS运行时基础篇[0,0]/RunTimeViewController00.h"
#import "Runtime-iOS运行时应用篇[0,1]/RunTimeViewController01.h"
#import "Runtime-详解[0,2]/RunTimeViewController02.h"

@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSArray* arrayAll;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *arr;

@end

@implementation MessageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"RunTime/RunLoop总结";
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
    HomeDataSupport *ds = [HomeDataSupport new];
    self.arr = [ds getDataSourceWithFileName:@"message.json"];
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
    ///////////////////0.RunTime//////////////////////////
    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{
                    RunTimeViewController00* runtimeVC00 = [RunTimeViewController00 new];
                    [self pushVC:runtimeVC00];
                    break;
                }
                case 1:{
                    RunTimeViewController01* runtimeVC01 = [RunTimeViewController01 new];
                    [self pushVC:runtimeVC01];
                    break;
                }
                case 2:{//Runtime详解
                    RunTimeViewController02* runtimeVC02 = [RunTimeViewController02 new];
                    [self pushVC:runtimeVC02];
                    break;
                }
                case 3:{
                    
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
                    
                    break;
                }
                case 1:{
                    
                    break;
                }
                case 2:{
                    
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
