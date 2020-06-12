
//
//  XQTableViewController.m
//  NIiOS
//
//  Created by nixs on 2019/3/19.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "XQTableViewController.h"
#import "XQFeedModel.h"
#import "XQFeedCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
static NSString* cellReuseIdentifier = @"feedCell";

@interface XQTableViewController ()<UITableViewDelegate,UITableViewDataSource>
/**
 *  解析json数据后得到的数据
 */
@property (strong, nonatomic) NSArray *feedsDataFormJSON;
/**
 *  用于给数据源使用的数组
 */
@property (strong, nonatomic) NSMutableArray *feeds;
@end

@implementation XQTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"宠物列表";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    WEAKSELF;
    [self loadJSONData:^{//加载完json数据后要做的操作
        weakSelf.feeds = @[].mutableCopy;
        [weakSelf.feeds addObject:weakSelf.feedsDataFormJSON.mutableCopy];
        [weakSelf.tableView registerClass:[XQFeedCell class] forCellReuseIdentifier:cellReuseIdentifier];
        [weakSelf.tableView reloadData];
    }];
    
}
//加载数据源
-(void)loadJSONData:(void(^)(void))then{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString* dataFilePath = [[NSBundle mainBundle] pathForResource:@"data.json" ofType:nil];
        NSData* data = [NSData dataWithContentsOfFile:dataFilePath];
        NSDictionary* dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray* feedArray = dataDictionary[@"feed"];
        NSMutableArray* feedArrayM = @[].mutableCopy;
        [feedArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [feedArrayM addObject:[XQFeedModel feedWithDictionary:obj]];
        }];
        self.feedsDataFormJSON = feedArrayM;
        dispatch_async(dispatch_get_main_queue(), ^{
            !then?:then();
        });
    });
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.feeds count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.feeds[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XQFeedCell* cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier];
    if (!cell) {
        cell = [[XQFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifier];
    }
    [self setupModelOfCell:cell atIndexPath:indexPath];
    return cell;
}
-(void)setupModelOfCell:(XQFeedCell*)cell atIndexPath:(NSIndexPath*)indexPath{
    //采用计算frame模式还是自动布局模式,默认为NO-自动布局模式
    //cell.fd_enforceFrameLayout = NO;
    cell.feed = self.feeds[indexPath.section][indexPath.row];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF;
    return [self.tableView fd_heightForCellWithIdentifier:cellReuseIdentifier cacheByIndexPath:indexPath configuration:^(id cell) {
        [weakSelf setupModelOfCell:cell atIndexPath:indexPath];
    }];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
