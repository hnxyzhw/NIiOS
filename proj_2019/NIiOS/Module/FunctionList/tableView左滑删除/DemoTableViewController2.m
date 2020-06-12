//
//  DemoTableViewController2.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/26.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "DemoTableViewController2.h"

@interface DemoTableViewController2 ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIButton* btnRightBarButtonItem;
@property(nonatomic,strong)NSMutableArray* dataSource;
@end

@implementation DemoTableViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"iOS UITableView左滑删除功能";
    self.view.backgroundColor = [UIColor lightGrayColor];
    //头部导航右上角编辑按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRightBarButtonItem];
    
    
    // 初始化假数据
    for (NSInteger i = 0; i < 10; i++) {
        //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.dataSource addObject:@(i)];
    }
    
    
    //表格布局init
    [self setupTableViewWithUITableViewStyle:UITableViewStyleGrouped];
    //表格遵循代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.allowsMultipleSelection = NO;
    self.tableView.allowsSelectionDuringEditing = NO;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    //表格分组区尾高度=0
    self.tableView.sectionFooterHeight = 0;//段尾高度设置(这里如果不设置的话，默认会有段尾高度的)
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* viewForHeader = [UIView new];
    viewForHeader.backgroundColor = [UIColor purpleColor];
    UILabel* labForHeader = [UILabel new];
    labForHeader.text = [NSString stringWithFormat:@"section[%ld]",section];
    [viewForHeader addSubview:labForHeader];
    [labForHeader makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(viewForHeader);
    }];
    return viewForHeader;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* identifier = @"cellIdentifier";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"section-row[%ld,%@]",indexPath.section,self.dataSource[indexPath.row]];
    return cell;
}

/**
 返回编辑模式
 */
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    //删除
    return UITableViewCellEditingStyleDelete;
}

/**
 提交删除操作
 */
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //只要实现这个方法,就是吸纳了默认滑动删除!!!
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        //删除数据
        [self deleteSelectIndexPath:indexPath];
        NILog(@"===调用删除数据方法===");
    }
}

/**
 delete指定行
 */
-(void)deleteSelectIndexPath:(NSIndexPath*)indexPath{
    //删除数据源
    [self.dataSource removeObjectAtIndex:indexPath.row];
    //删除选中项目
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    //验证数据源
    //没有
    if (self.dataSource.count==0) {
        //没有收藏数据
        if (self.btnRightBarButtonItem.selected) {
            //编辑状态--取消编辑状态
            [self rightBarButtonItemDidClicked:self.btnRightBarButtonItem];
        }
        self.btnRightBarButtonItem.enabled = NO;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(UIButton *)btnRightBarButtonItem{
    if (_btnRightBarButtonItem == nil) {
        _btnRightBarButtonItem = [[UIButton alloc] init];
        [_btnRightBarButtonItem setTitle:@"编辑" forState:UIControlStateNormal];
        [_btnRightBarButtonItem setTitle:@"取消" forState:UIControlStateSelected];
        [_btnRightBarButtonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnRightBarButtonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_btnRightBarButtonItem addTarget:self action:@selector(rightBarButtonItemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _btnRightBarButtonItem.titleLabel.font = NIUIFontSize(15.0);
        _btnRightBarButtonItem.ni_size = CGSizeMake(100, 44);
        _btnRightBarButtonItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _btnRightBarButtonItem;
}

/**
 编辑按钮被点击
 */
-(void)rightBarButtonItemDidClicked:(UIButton*)sender{
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        //这个是fix掉:当你左滑删除的时候，再点击右上角编辑按钮， cell上的删除按钮不会消失掉的bug。且必须放在 设置tableView.editing = YES;的前面。
        [self.tableView reloadData];
        //取消
        [self.tableView setEditing:YES animated:YES];
    }else{
        //编辑
        [self.tableView setEditing:NO animated:YES];
    }
}

/**
 数据源懒加载
 */
-(NSMutableArray *)dataSource{
    if (_dataSource==nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}






@end
