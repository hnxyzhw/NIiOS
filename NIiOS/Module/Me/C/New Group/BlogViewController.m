

//
//  BlogViewController.m
//  NIiOS
//
//  Created by nixs on 2019/3/21.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "BlogViewController.h"
#import "BlogModel.h"
#import "BlogCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

static NSString* blogCellIdentifier = @"blogCellIdentifier";

@interface BlogViewController ()<UITableViewDelegate,UITableViewDataSource,BlogCellDelegate>
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray* dataArray;
@end

@implementation BlogViewController

-(void)loadData{
    self.dataArray = [NSArray modelArrayWithClass:[BlogModel class] json:[NSArray NIDataFromJsonFileName:@"blog.json" andDataType:jsonArray]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"UITableView+FDTemplateLayoutCell(二) BlogViewController";
    [self setupView];
    [self loadData];//请求数据源头
    
    #ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    #endif
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BlogCell* cell = [tableView dequeueReusableCellWithIdentifier:blogCellIdentifier];
    if (!cell) {
        cell = [[BlogCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:blogCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.cellDelegate = self;
    WEAKSELF;
    [cell setFoldClickedBlock:^(BlogCell * _Nonnull cell) {
        NSIndexPath* indexPath = [weakSelf.tableView indexPathForCell:cell];
        if (weakSelf.dataArray.count>0) {
            BlogModel* model = weakSelf.dataArray[indexPath.row];
            model.isOpening = !model.isOpening;
            [weakSelf.tableView beginUpdates];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [weakSelf.tableView endUpdates];
        }
    }];
    if (self.dataArray.count>0) {
        BlogModel* model = self.dataArray[indexPath.row];
        cell.blogModel = model;
    }
    return cell;
}
//折叠按钮代理事件
//-(void)clickFoldLabel:(BlogCell *)cell{
//    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
//    if (self.dataArray.count>0) {
//        BlogModel* model = self.dataArray[indexPath.row];
//        model.isOpening = !model.isOpening;
//        [self.tableView beginUpdates];
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [self.tableView endUpdates];
//    }
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF;
    if (self.dataArray.count>0) {
        BlogModel* model = [self.dataArray objectAtIndex:indexPath.row];
        //动态计算cell高度
        //这里使用了forkingdog的框架
        // https://github.com/forkingdog/UITableView-FDTemplateLayoutCell
        // UITableView+FDTemplateLayoutCell这个分类牛逼的地方就是在于自动计算行高了
        //如果我们在没有缓存的情况下，只要你使用了它其实高度的计算不需要我们来管，我们只需要[self.tableView reloadData]就完全足够了
        //但是如果有缓存的时候，这个问题就来了，你会发现，点击展开布局会乱，有一部分会看不见，这是因为高度并没有变化，一直用的是缓存的高度，所有解决办法如下
        if (model.isOpening) {
            //使用不缓存的方式
            return [weakSelf.tableView fd_heightForCellWithIdentifier:blogCellIdentifier configuration:^(id cell) {
                [weakSelf handleCellHeightWithNewsCell:cell indexPath:indexPath];
            }];
        }else{
            //使用缓存的方式
            return [weakSelf.tableView fd_heightForCellWithIdentifier:blogCellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
                [weakSelf handleCellHeightWithNewsCell:cell indexPath:indexPath];
            }];
        }
    }else{
        return 10;
    }
}
/**
 处理cell高度
 */
-(void)handleCellHeightWithNewsCell:(id)cell indexPath:(NSIndexPath *)indexPath{
    BlogCell *blogCell = (BlogCell *)cell;
    blogCell.blogModel = self.dataArray[indexPath.row];
}

-(void)setupView{
    self.tableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    //注册cell
    [self.tableView registerClass:[BlogCell class] forCellReuseIdentifier:blogCellIdentifier];
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(0);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(0);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(0);
            make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(0);
        }
        make.left.right.equalTo(self.view);
    }];
}

@end
