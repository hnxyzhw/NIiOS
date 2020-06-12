//
//  DemoTableViewController.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/26.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "DemoTableViewController.h"
#import "UILabel+JRLabel.h"

@interface DemoTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DemoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    #pragma mark - 参考链接:https://www.cnblogs.com/xianfeng-zhang/p/6394173.html
    self.navigationItem.title = @"TableView之表头、表尾，区头、区尾！";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self setupTableViewWithUITableViewStyle:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headView.backgroundColor = [UIColor purpleColor];
    UILabel* labHead = [UILabel labelWithFontSize:12.0 title:[NSString stringWithFormat:@"表头自定义View"] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    [headView addSubview:labHead];
    [labHead makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headView);
    }];
    self.tableView.tableHeaderView = headView;
    
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    footerView.backgroundColor = [UIColor yellowColor];
    UILabel* labFooter = [UILabel labelWithFontSize:12.0 title:[NSString stringWithFormat:@"表尾自定义View"] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter];
    [footerView addSubview:labFooter];
    [labFooter makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(footerView);
    }];
    self.tableView.tableFooterView = footerView;
    
    WEAKSELF;
    MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //[weakSelf refreshDataArray];
        //数据请求完成调用
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
    }];
    self.tableView.mj_header = header;
    MJRefreshBackNormalFooter* footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        //[weakSelf refreshDataArray];
        //数据请求完成调用
        [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData]; // 无数据刷新样式
        //[weakSelf.tableView.mj_footer endRefreshing]; // 普通
        [weakSelf.tableView reloadData];
    }];
    self.tableView.mj_footer = footer;
    
}

/**
 就是tableView表中Section的头和尾
 设置区头和区尾的高度：
 */
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

/**
 设置区头和区尾的文本(该方法-高度区尾有异常)
 */
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return [NSString stringWithFormat:@"区头 section：%ld",section];
//}
//-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
//    return [NSString stringWithFormat:@"区尾 section：%ld",section];
//}

/**
 自定义区头和区尾的View
 */
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* viewHeader = [UIView new];
    viewHeader.backgroundColor = [UIColor redColor];
    UILabel* labHeader = [UILabel labelWithFontSize:12.0 title:[NSString stringWithFormat:@"区头 section：%ld",section] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [viewHeader addSubview:labHeader];
    [labHeader makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewHeader);
    }];
    return viewHeader;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView* viewFooter = [UIView new];
    viewFooter.backgroundColor = [UIColor greenColor];
    UILabel* labFooter = [UILabel labelWithFontSize:12.0 title:[NSString stringWithFormat:@"区尾 section：%ld",section] textColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [viewFooter addSubview:labFooter];
    [labFooter makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewFooter);
    }];
    return viewFooter;
}
/**
 表格 - cell的行高
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

/**
 表格 - 分组数
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

/**
 表格 - 每个分组有多少cell
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifier = @"cellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"section-row [%ld,%ld]",indexPath.section,indexPath.row];
    return cell;
}


@end
