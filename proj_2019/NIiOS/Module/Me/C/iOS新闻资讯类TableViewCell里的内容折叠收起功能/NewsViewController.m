

//
//  NewsViewController.m
//  NIiOS
//
//  Created by nixs on 2019/3/19.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsModel.h"
#import "NewsCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
static NSString *NewsCellIdentifier = @"newsCellIdentifier";

@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource,NewsCellDelegate>
@property(nonatomic,strong) UITableView *newsTableView;
@property(nonatomic,strong) NSArray* newsDataArray;
@end

@implementation NewsViewController


-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"新闻列表";
    
    [self setSubViews];
    [self loadData];
    
    #ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        self.newsTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    #endif
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsDataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsCell* cell = [tableView dequeueReusableCellWithIdentifier:NewsCellIdentifier];
    if (!cell) {
        cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NewsCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellDelegate = self;
    if (self.newsDataArray.count>0) {
        NewsModel* model = self.newsDataArray[indexPath.row];
        cell.newsModel = model;
    }
    return cell;
}
//折叠按钮代理事件
-(void)clickFoldLabel:(NewsCell *)cell{
    NSIndexPath* indexPath = [self.newsTableView indexPathForCell:cell];
    if (self.newsDataArray.count>0) {
        NewsModel* model = self.newsDataArray[indexPath.row];
        model.isOpening = !model.isOpening;
        [self.newsTableView beginUpdates];
        [self.newsTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.newsTableView endUpdates];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.newsDataArray.count>0) {
        NewsModel* model = [self.newsDataArray objectAtIndex:indexPath.row];
        //动态计算cell高度
        //这里使用了forkingdog的框架
        // https://github.com/forkingdog/UITableView-FDTemplateLayoutCell
        // UITableView+FDTemplateLayoutCell这个分类牛逼的地方就是在于自动计算行高了
        //如果我们在没有缓存的情况下，只要你使用了它其实高度的计算不需要我们来管，我们只需要[self.tableView reloadData]就完全足够了
        //但是如果有缓存的时候，这个问题就来了，你会发现，点击展开布局会乱，有一部分会看不见，这是因为高度并没有变化，一直用的是缓存的高度，所有解决办法如下
        if (model.isOpening) {
            //使用不缓存的方式
            return [self.newsTableView fd_heightForCellWithIdentifier:NewsCellIdentifier configuration:^(id cell) {
                [self handleCellHeightWithNewsCell:cell indexPath:indexPath];
            }];
        }else{
            //使用缓存的方式
            return [self.newsTableView fd_heightForCellWithIdentifier:NewsCellIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
                [self handleCellHeightWithNewsCell:cell indexPath:indexPath];
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
    NewsCell *newsCell = (NewsCell *)cell;
    newsCell.newsModel = self.newsDataArray[indexPath.row];
}
-(void)loadData{
    self.newsDataArray = [NSArray modelArrayWithClass:[NewsModel class] json:[NSArray NIDataFromJsonFileName:@"newsData.json" andDataType:jsonArray]];
}
-(void)setSubViews{
    self.newsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.newsTableView.delegate = self;
    self.newsTableView.dataSource = self;
    self.newsTableView.estimatedRowHeight = 0;
    self.newsTableView.estimatedSectionHeaderHeight = 0;
    self.newsTableView.estimatedSectionFooterHeight = 0;
    [self.newsTableView registerClass:[NewsCell class] forCellReuseIdentifier:NewsCellIdentifier];
    [self.view addSubview:self.newsTableView];
    [self.newsTableView makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-10);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(10);
            make.bottom.equalTo(self.mas_bottomLayoutGuide).offset(-10);
        }
        make.left.right.equalTo(self.view);
    }];
}
@end
