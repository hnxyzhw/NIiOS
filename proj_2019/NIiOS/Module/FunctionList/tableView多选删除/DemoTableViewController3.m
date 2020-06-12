//
//  DemoTableViewController3.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/26.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "DemoTableViewController3.h"
#import "MHOperationCell.h"
#import "MHBackButton.h"

@interface DemoTableViewController3 ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIButton* btnRightBarButtonItem;
@property(nonatomic,strong)UIButton* btnLeftBarButtonItem;
@property(nonatomic,strong)MHBackButton* btnBackBarButtonItem;

/** 所有indexPath */
@property(nonatomic,strong)NSMutableArray* dataSource;
/** 选中的数据 */
@property (nonatomic , strong) NSMutableArray *selectedDatas;
/** 删除 */
@property (nonatomic , strong) UIButton *deleteBtn;

@end

@implementation DemoTableViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"tableView多选和删除";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // 初始化假数据
    for (NSInteger i = 0; i < 20; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [self.dataSource addObject:indexPath];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRightBarButtonItem];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnBackBarButtonItem];
    
    //表格布局init
    [self setupTableViewWithUITableViewStyle:UITableViewStylePlain];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    [self.tableView updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    //表格遵循代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    
    //表格分组区尾高度=0
    self.tableView.sectionFooterHeight = 0;//段尾高度设置(这里如果不设置的话，默认会有段尾高度的)
    
    //删除按钮
    [self setupDeleteBtn];
    
}
-(UIButton *)btnRightBarButtonItem{
    if (_btnRightBarButtonItem == nil) {
        _btnRightBarButtonItem = [[UIButton alloc] init];
        [_btnRightBarButtonItem setTitle:@"编辑" forState:UIControlStateNormal];
        [_btnRightBarButtonItem setTitle:@"取消" forState:UIControlStateSelected];
        [_btnRightBarButtonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnRightBarButtonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_btnRightBarButtonItem addTarget:self action:@selector(rightBarButtonItemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _btnRightBarButtonItem.titleLabel.font = NIUIFontSize(14.0);
        _btnRightBarButtonItem.ni_size = CGSizeMake(100, 44);
        _btnRightBarButtonItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _btnRightBarButtonItem;
}
-(UIButton *)btnLeftBarButtonItem{
    if (_btnLeftBarButtonItem == nil) {
        _btnLeftBarButtonItem = [[UIButton alloc] init];
        [_btnLeftBarButtonItem setTitle:@"全选" forState:UIControlStateNormal];
        [_btnLeftBarButtonItem setTitle:@"取消全选" forState:UIControlStateSelected];
        [_btnLeftBarButtonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnLeftBarButtonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [_btnLeftBarButtonItem addTarget:self action:@selector(leftBarButtonItemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _btnLeftBarButtonItem.titleLabel.font = NIUIFontSize(14.0);
        _btnLeftBarButtonItem.ni_size = CGSizeMake(100, 44);
        _btnLeftBarButtonItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _btnLeftBarButtonItem;
}
- (MHBackButton *)btnBackBarButtonItem
{
    if (_btnBackBarButtonItem == nil) {
        _btnBackBarButtonItem = [[MHBackButton alloc] init];
        [_btnBackBarButtonItem setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_btnBackBarButtonItem setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
        _btnBackBarButtonItem.frame = CGRectMake(0, 0, 100, 44);
        // 监听按钮点击
        [_btnBackBarButtonItem addTarget:self action:@selector(backBarButtonItemDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btnBackBarButtonItem;
}
//懒加载时数据源
- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
- (NSMutableArray *)selectedDatas
{
    if (_selectedDatas == nil) {
        _selectedDatas = [[NSMutableArray alloc] init];
    }
    return _selectedDatas;
}
- (UIButton *)deleteBtn
{
    if (_deleteBtn == nil) {
        _deleteBtn = [[UIButton alloc] init];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        _deleteBtn.titleLabel.font = NIUIFontSize(15);
        _deleteBtn.adjustsImageWhenHighlighted = NO;
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"collectionVideo_delete_nor"] forState:UIControlStateNormal];
        [_deleteBtn setBackgroundImage:[UIImage imageNamed:@"collectionVideo_delete_high"] forState:UIControlStateDisabled];
        [_deleteBtn addTarget:self action:@selector(deleteBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.enabled = NO;
        
    }
    return _deleteBtn;
}
//删除按钮布局
-(void)setupDeleteBtn{
    [self.view addSubview:self.deleteBtn];
    [self.deleteBtn makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.tableView.mas_bottom);
        make.height.equalTo(50);
    }];
}
/** 删除 */
- (void)deleteBtnDidClicked:(UIButton *)sender
{
    // 删除
    /**
     *  这里删除操作交给自己处理
     */
    [self deleteSelectIndexPaths:self.tableView.indexPathsForSelectedRows];
    
}
#pragma mark - 点击事件处理
- (void)rightBarButtonItemDidClicked:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        // 这个是fix掉:当你左滑删除的时候，再点击右上角编辑按钮， cell上的删除按钮不会消失掉的bug。且必须放在 设置tableView.editing = YES;的前面。
        [self.tableView reloadData];
        
        // 取消
        [self.tableView setEditing:YES animated:NO];
        
        // 全选
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnLeftBarButtonItem];
        self.btnLeftBarButtonItem.selected = NO;
        
        // show
        [self showDeleteButton];
        
    }else{
        // 清空选中栏
        [self.selectedDatas removeAllObjects];
        
        // 编辑
        [self.tableView setEditing:NO animated:NO];
        
        // 返回
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnBackBarButtonItem];
        
        // hide
        [self hideDeleteButton];
    }
}
#pragma mark - 显示和隐藏 删除按钮
- (void)showDeleteButton
{
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).with.offset(-1*50);
    }];
    
    // 更新约束
    [self updateConstraints];
}

- (void)hideDeleteButton
{
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
    
    // 更新约束
    [self updateConstraints];
}
#pragma mark - 辅助方法
// 更新布局
- (void)updateConstraints
{
    // tell constraints they need updating
    [self.view setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)leftBarButtonItemDidClicked:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    if (sender.isSelected) {
        
        // 全选
        NSInteger count = self.dataSource.count;
        for (NSInteger i = 0 ; i < count; i++)
        {
            NSIndexPath *indexPath = self.dataSource[i];
            if (![self.selectedDatas containsObject:indexPath]) {
                [self.selectedDatas addObject:indexPath];
            }
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
            
        }
        
    }else{
        // 取消全选
        NSInteger count = self.dataSource.count;
        for (NSInteger i = 0 ; i < count; i++)
        {
            NSIndexPath *indexPath = self.dataSource[i];
            if ([self.selectedDatas containsObject:indexPath]) {
                [self.selectedDatas removeObject:indexPath];
                
            }
            [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES];
        }
    }
    
    // 设置状态
    [self indexPathsForSelectedRowsCountDidChange:self.tableView.indexPathsForSelectedRows];
}
- (void)indexPathsForSelectedRowsCountDidChange:(NSArray *)selectedRows
{
    NSInteger currentCount = [selectedRows count];
    NSInteger allCount = self.dataSource.count;
    self.btnLeftBarButtonItem.selected = (currentCount==allCount);
    NSString *title = (currentCount>0)?[NSString stringWithFormat:@"删除(%zd)",currentCount]:@"删除";
    [self.deleteBtn setTitle:title forState:UIControlStateNormal];
    self.deleteBtn.enabled = currentCount>0;
}
/** 返回按钮点击事件 */
- (void)backBarButtonItemDidClicked:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
// delete收藏视频
- (void)deleteSelectIndexPaths:(NSArray *)indexPaths
{
    // 删除数据源
    [self.dataSource removeObjectsInArray:self.selectedDatas];
    [self.selectedDatas removeAllObjects];
    
    // 删除选中项
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    // 验证数据源
    [self indexPathsForSelectedRowsCountDidChange:self.tableView.indexPathsForSelectedRows];
    
    // 验证
    // 没有
    if (self.dataSource.count == 0)
    {
        //没有收藏数据
        
        if(self.btnRightBarButtonItem.selected)
        {
            // 编辑状态 -- 取消编辑状态
            [self rightBarButtonItemDidClicked:self.btnRightBarButtonItem];
        }
        self.btnRightBarButtonItem.enabled = NO;
    }
}
#pragma mark - UITableViewDelegate , UITableViewDataSource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MHOperationCell *cell = [MHOperationCell cellWithTableView:tableView];
    cell.indexPath = self.dataSource[indexPath.row];
    
    // 是否修改系统的选中按钮的样式 默认是NO 即系统样式
    cell.modifySelectionStyle = YES;
    
    return cell;
}
// 选中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.isEditing) {
        // 获取cell编辑状态选中情况下的所有子控件
        // NSArray *subViews = [[tableView cellForRowAtIndexPath:indexPath] subviews];
        
        NSIndexPath *indexPathM = self.dataSource[indexPath.row];
        if (![self.selectedDatas containsObject:indexPathM]) {
            [self.selectedDatas addObject:indexPathM];
        }
        [self indexPathsForSelectedRowsCountDidChange:tableView.indexPathsForSelectedRows];
        return;
    }
    
    // 获取cell编辑状态选中情况下的所有子控件
    //    NSArray *subViews = [[tableView cellForRowAtIndexPath:indexPath] subviews];
    
    //MHOperationController *operation = [[MHOperationController alloc] init];
    //NSIndexPath *indexP = self.dataSource[indexPath.row];
    //operation.title = [NSString stringWithFormat:@"仙剑奇侠传 第%zd集",indexP.row];
    //[self.navigationController pushViewController:operation animated:YES];
    [self.view makeToast:[NSString stringWithFormat:@"仙剑奇侠传 第%ld集",(NSInteger)self.dataSource[indexPath.row]]];
}
// 取消选中
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing)
    {
        NSIndexPath *indexPathM = self.dataSource[indexPath.row];
        if ([self.selectedDatas containsObject:indexPathM]) {
            [self.selectedDatas removeObject:indexPathM];
        }
        
        [self indexPathsForSelectedRowsCountDidChange:tableView.indexPathsForSelectedRows];
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.isEditing) {
        // 多选
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    }else{
        // 删除
        return UITableViewCellEditingStyleDelete;
    }
}

#pragma mark 提交编辑操作
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //只要实现这个方法，就实现了默认滑动删除！！！！！
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSIndexPath *indexPathM = self.dataSource[indexPath.row];
        if (![self.selectedDatas containsObject:indexPathM]) {
            [self.selectedDatas addObject:indexPathM];
        }
        [self deleteSelectIndexPaths:@[indexPath]];
    }
}

#pragma mark 删除按钮中文
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

@end
