//
//  NIBaseViewController.h
//  NIiOS
//
//  Created by ai-nixs on 2018/11/19.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIEmptyView.h"
#import "Toast.h"

@interface NIBaseViewController : UIViewController
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *arr;
@property (nonatomic, strong)NIEmptyView *emptyView;//空数据页

/**
 基类里-初始化表格添加到self.view
 注意:继承自基类的控制器要遵循表格代理，实现代理方法
 //self.tableView.delegate = self;
 //self.tableView.dataSource = self;
 */
-(void)setupTableView;

/**
 基类里-初始化表格添加到self.view
 注意:继承自基类的控制器要遵循表格代理，实现代理方法
 //self.tableView.delegate = self;
 //self.tableView.dataSource = self;
 @param tableViewStyle 表格样式
 typedef NS_ENUM(NSInteger, UITableViewStyle) {
 UITableViewStylePlain,          // regular table view
 UITableViewStyleGrouped         // preferences style table view
 };
 */
-(void)setupTableViewWithUITableViewStyle:(UITableViewStyle)tableViewStyle;

/**
 自定义空数据页面(View)
 @param desc 空数据页面描述信息
 */
-(void)setupEmptyViewWithDesc:(NSString*)desc;

/**
 是否有网络(外网 可以连接上百度的外网)
 @return YES有外网；NO没有外网
 */
-(BOOL)isConnectionAvailable;

/**
 版本判断
 */
-(void)versionCheck;

/**
 跳转到AppStore
 @param urlStr 目标App在AppStore里地址
 */
-(void)jumpToAppStoreWithURL:(NSString*)urlStr;

/**
 iOS 应用获取最上层全屏 Window 的正确方法
 //自定义网络异常视图放到每个控制器视图-最上层
 UIWindow* mainWindow = [self lastWindow];
 [mainWindow addSubview:self.versionManagerView];
 */
- (UIWindow *)lastWindow;

@end
