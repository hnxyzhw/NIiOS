//
//  NITabBarController.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/19.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "NITabBarController.h"
#import "NICustomNavigationController.h"
#import "MainViewController.h"
//#import "HomeViewController.h"
//#import "HomeViewControllerPlus.h"
#import "MainListViewController.h"
#import "MessageViewController.h"
#import "DiscoverViewController.h"
#import "MeViewController.h"

@interface NITabBarController ()
@property(nonatomic,strong) NSMutableArray *items;
@property(nonatomic,retain)MainViewController* main;
//@property(nonatomic,retain)HomeViewController* home;
@property(nonatomic,retain)MainListViewController* home;
@property(nonatomic,retain)MessageViewController* message;
@property(nonatomic,retain)DiscoverViewController* discover;
@property(nonatomic,retain)MeViewController* me;
@end

@implementation NITabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加所有子控制器
    [self setUpAllChildViewController];
    [self setUpTabBar];
}

// 在iOS7 之后，默认会把uitabBar上的系统图片渲染成蓝色,可以在Assets.xcassets中把图片的image set的Render as设置为Original image
#pragma mark - 添加所有的子控制器
- (void)setUpAllChildViewController
{
    self.main = [[MainViewController alloc] init];
    //self.home =[[HomeViewController alloc]init];
    self.home =[[MainListViewController alloc]init];
    self.message =[[MessageViewController alloc]init];
    self.discover =[[DiscoverViewController alloc]init];
    self.me = [[MeViewController alloc]init];
    
    [self setUpOneChildViewController:self.main image:[UIImage imageNamed:@"tabbar_home"]
                        selectedImage:[UIImage imageNamed:@"tabbar_home_selected"]
                                title:@"Main-抽屉"];
    [self setUpOneChildViewController:self.home image:[UIImage imageNamed:@"tabbar_home"]
                        selectedImage:[UIImage imageNamed:@"tabbar_home_selected"]
                                title:@"基础"];
    [self setUpOneChildViewController:self.message image:[UIImage imageNamed:@"tabbar_message_center"]
                        selectedImage:[UIImage imageNamed:@"tabbar_message_center_selected"]
                                title:@"提升"];
    [self setUpOneChildViewController:self.discover image:[UIImage imageNamed:@"tabbar_discover"]
                        selectedImage:[UIImage imageNamed:@"tabbar_discover_selected"]
                                title:@"实例"];
    [self setUpOneChildViewController:self.me image:[UIImage imageNamed:@"tabbar_profile"]
                        selectedImage:[UIImage imageNamed:@"tabbar_profile_selected"]
                                title:@"我的"];    
}

#pragma mark - 添加一个子控制器
- (void)setUpOneChildViewController:(UIViewController *)vc image:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title{
    vc.title = title;
    vc.tabBarItem.image = image;
    vc.tabBarItem.selectedImage = selectedImage;
    
    [vc.tabBarItem setTitleTextAttributes:@{
                                            NSFontAttributeName :            [UIFont systemFontOfSize:10],
                                            NSForegroundColorAttributeName : [UIColor orangeColor]
                                            }
                                 forState:UIControlStateSelected];
    
    //[vc.tabBarItem setTitleTextAttributes:@{} forState:UIControlStateSelected];
    
    // 保存tabBarItem模型到数组
    [self.items addObject:vc.tabBarItem];
    
    NICustomNavigationController *nav = [[NICustomNavigationController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:nav];
    
}

#pragma mark - 设置tabBar
- (void)setUpTabBar
{
    
}

#pragma mark - 承载放到TabBar上所有控制器数组懒加载
- (NSMutableArray *)item
{
    if (!_items) {
        _items =[NSMutableArray array];
    }
    return _items;
}
@end
