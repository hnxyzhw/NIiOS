//
//  LeftViewController.m
//  ViewControllerTransition
//
//  Created by 陈旺 on 2017/7/10.
//  Copyright © 2017年 chavez. All rights reserved.
//

#import "LeftViewController.h"
#import "NextViewController.h"
#import "CWTableViewInfo.h"
#import "UIViewController+CWLateralSlide.h"

#import <MessageUI/MessageUI.h>//邮件反馈引入头文件

@interface LeftViewController ()<MFMailComposeViewControllerDelegate>

@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic,strong) NSArray *imageArray;
@property (nonatomic,strong) NSArray *titleArray;

@property(nonatomic,strong)YYAnimatedImageView *imageloadView;//背景图片
@property(nonatomic,strong) UIButton* btnHead;
@property(nonatomic,strong) UILabel* labName;
@property(nonatomic,strong) UILabel* labDesc;
@end

@implementation LeftViewController
{
    CWTableViewInfo *_tableViewInfo;
}

- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupHeader];
    [self setupTableView];
    
}

- (void)setupHeader {
    //BgImageView
    self.imageloadView = [[YYAnimatedImageView alloc]initWithFrame:CGRectMake(0, 0, kCWSCREENWIDTH * 0.75, 300)];
    self.imageloadView.contentMode = UIViewContentModeScaleAspectFill;
    //允许上面的Btn可以点击
    self.imageloadView.userInteractionEnabled = YES;
    //YYImage播放动态图片(gif,YYKit实现),内存占用30M
    YYImage *image = [YYImage imageNamed:@"start.gif"];
    [self.imageloadView setImage:image];
    [self.view addSubview:self.imageloadView];
    
    //btnHead
    self.btnHead = [UIButton new];
    self.btnHead.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.btnHead setBackgroundImage:[UIImage imageNamed:@"coder.png"] forState:UIControlStateNormal];
    [self.btnHead addTarget:self action:@selector(pushSettingVC) forControlEvents:UIControlEventTouchUpInside];
    [self.imageloadView addSubview:self.btnHead];
    [self.btnHead makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(100);
        make.width.equalTo(100);
        make.centerX.equalTo(self.imageloadView);
        make.top.equalTo(self.imageloadView).offset(50);
    }];
    NIViewSetRadius(self.btnHead, 50);
    
    self.labName = [UILabel new];
    self.labName.font = NIUIFontboldSize(20);
    self.labName.textAlignment = NSTextAlignmentCenter;
    self.labName.text = @"加菲猫";
    self.labName.textColor = [UIColor redColor];
    [self.imageloadView addSubview:self.labName];
    [self.labName makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(30);
        make.width.equalTo(kCWSCREENWIDTH*0.75);
        make.centerX.equalTo(self.imageloadView);
        make.top.equalTo(self.btnHead.mas_bottom).offset(10);
    }];
    
    self.labDesc = [UILabel new];
    self.labDesc.font = NIUIFontSize(18);
    self.labDesc.textAlignment = NSTextAlignmentCenter;
    self.labDesc.numberOfLines = 0;
    self.labDesc.text = @"人生就像一场没有尽头的旅行! 👻骚年,你搬砖的路还很长😂😱...";
    self.labDesc.textColor = [UIColor whiteColor];
    [self.imageloadView addSubview:self.labDesc];
    [self.labDesc makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.labName.mas_bottom).offset(10);
        make.leading.equalTo(self.imageloadView).offset(10);
        make.trailing.equalTo(self.imageloadView).offset(-10);
    }];
}

-(void)pushSettingVC{
    //SettingViewController* setVC = [SettingViewController new];
    //[self cw_pushViewController:setVC drewerHiddenDuration:0.01];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setupTableView {
    
    _tableViewInfo = [[CWTableViewInfo alloc] initWithFrame:CGRectMake(0, 300, kCWSCREENWIDTH * 0.75, CGRectGetHeight(self.view.bounds)-300) style:UITableViewStylePlain];
    
    for (int i = 0; i < self.titleArray.count; i++) {
        NSString *title = self.titleArray[i];
        NSString *imageName = self.imageArray[i];
        SEL sel = @selector(didSelectCell:indexPath:);
        CWTableViewCellInfo *cellInfo = [CWTableViewCellInfo cellInfoWithTitle:title imageName:imageName target:self sel:sel];
        [_tableViewInfo addCell:cellInfo];
    }
    
    [self.view addSubview:[_tableViewInfo getTableView]];
    [[_tableViewInfo getTableView] reloadData];
}

#pragma mark - cell点击事件
- (void)didSelectCell:(CWTableViewCellInfo *)cellInfo indexPath:(NSIndexPath *)indexPath {
    /**
     * @Description:邮件反馈
     * @Company: China Citic Bank
     * @Author: nixinsheng
     * @Date:2019年03月11日19:19:53
     */
    if (indexPath.row == self.titleArray.count - 1) { // 点击最后一个邮件反馈
        if (![MFMailComposeViewController canSendMail]) { // 不能发送邮件
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"反馈邮箱\n1911398892@qq.com" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:0 handler:^(UIAlertAction * _Nonnull action) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:alertAction];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
        MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
        if (mailVC == nil) return;
        [mailVC setSubject:@"NIiOS-邮件反馈"]; //邮件主题
        [mailVC setToRecipients:[NSArray arrayWithObjects:@"1911398892@qq.com", nil]]; //设置发送给谁，参数是NSarray
        mailVC.mailComposeDelegate = self;
        [self presentViewController:mailVC animated:YES completion:nil];
        return;
    }
    if (indexPath.row == self.titleArray.count - 2) { // 点击最后一个主动收起抽屉
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    if (indexPath.row == self.titleArray.count - 3) { // 显示alertView
        [self showAlterView];
        return;
    }
    
    NextViewController *vc = [NextViewController new];
    if (indexPath.row == 0) {
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self cw_presentViewController:nav];
    }else {
        [self cw_pushViewController:vc];
    }
}
#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    // 发送完成
    [self.view makeToast:@"邮件发送成功!" duration:1.0 position:CSToastPositionCenter];
    [controller dismissViewControllerAnimated:YES completion:nil];
}
- (void)showAlterView {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"hello world!" message:@"hello world!嘿嘿嘿" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"😂😄" style:UIAlertActionStyleDefault handler:nil];
    [alertC addAction:action];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - Getter
- (NSArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = @[@"personal_member_icons",
                        @"personal_myservice_icons",
                        @"personal_news_icons",
                        @"personal_order_icons",
                        @"personal_preview_icons",
                        @"personal_service_icons",
                        @"personal_service_icons"];
    }
    return _imageArray;
}

- (NSArray *)titleArray{
    if (_titleArray == nil) {
        _titleArray = @[@"present下一个界面",
                        @"Push下一个界面",
                        @"Push下一个界面",
                        @"Push下一个界面",
                        @"显示alertView",
                        @"主动收起抽屉",
                        @"邮件反馈"];
    }
    return _titleArray;
}


@end
