//
//  DemoTableViewController4.m
//  NIiOS
//
//  Created by nixs on 2018/12/14.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "DemoTableViewController4.h"
#import "XIBTableViewCell.h"

static NSString *cellID = @"XIBCell";

@interface DemoTableViewController4 ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DemoTableViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableViewWithUITableViewStyle:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"XIBTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellID];
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(5);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.top.equalTo(self.mas_topLayoutGuide).offset(5);
            make.bottom.equalTo(self.mas_bottomLayoutGuide);
        }
        make.leading.trailing.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XIBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[XIBTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.labTitle.text = @"QQ邮箱";
    cell.labDesc.text = @"QQ邮箱是腾讯公司2002年推出，向用户提供安全、稳定、快速、便捷电子邮件服务的邮箱产品，已为超过1亿的邮箱用户提供免费和增值邮箱服务。QQ邮件服务以高速电信骨干网为强大后盾，独有独立的境外邮件出口链路，免受境内外网络瓶颈影响，全...";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view makeToast:[NSString stringWithFormat:@"[%ld,%ld]",indexPath.section,indexPath.row] duration:1.0 position:CSToastPositionCenter];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

@end
