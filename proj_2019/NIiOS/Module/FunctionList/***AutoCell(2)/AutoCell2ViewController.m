//
//  AutoCell2ViewController.m
//  NIiOS
//
//  Created by nixs on 2019/1/14.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "AutoCell2ViewController.h"

@interface AutoCell2ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSArray *array;
@end

@implementation AutoCell2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"AutoCell2ViewController";
    self.array = @[@"AutolayoutTableViewController",@"CountHeightTableViewController",@"FrameCountTableViewController",@"YYKitTableViewController",@"AsyncDisplayKitTableViewController"];
    //table init
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushVC:self.array[indexPath.row]];
}
-(void)pushVC:(NSString*)vcName{
    UITableViewController *vc = [[NSClassFromString(vcName) alloc] init];
    vc.navigationItem.title = vcName;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
@end
