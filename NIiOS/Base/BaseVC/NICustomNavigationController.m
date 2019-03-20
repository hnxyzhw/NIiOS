//
//  NICustomNavigationController.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/19.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "NICustomNavigationController.h"
#import <WebKit/WebKit.h>

@interface NICustomNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation NICustomNavigationController
//是否自动旋转
//返回导航控制器的顶层视图控制器的自动旋转属性，因为导航控制器是以栈的原因叠加VC的
//topViewController是其顶层的视图控制器
#pragma mark - 支持旋转 by:nixs 2019年03月20日11:17:56
-(BOOL)shouldAutorotate{
    return [self.topViewController shouldAutorotate];
}
#pragma mark - 支持的方向 by:nixs 2019年03月20日11:20:55
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.topViewController supportedInterfaceOrientations];
}
#pragma mark - 默认方向
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //重写了leftbarItem之后,需要添加如下方法才能重新启用右滑返回
    WEAKSELF;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = nil;
        self.delegate = weakSelf;
    }
    
    // Do any additional setup after loading the view.
}

/* 某个页面导航栏透明,文字不透明
 - (void)viewWillAppear:(BOOL)animated
 {
 [super viewWillAppear:animated];
 //设置导航栏背景图片为一个空的image，这样就透明了
 [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
 //去掉透明后导航栏下边的黑边
 [self.navigationBar setShadowImage:[[UIImage alloc] init]];
 }
 
 - (void)viewWillDisappear:(BOOL)animated{
 
 //如果不想让其他页面的导航栏变为透明 需要重置
 [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
 [self.navigationController.navigationBar setShadowImage:nil];
 }
 */

/**
 https://blog.csdn.net/qq_24702189/article/details/79345396
 */
+ (void)initialize {
    //appearance方法返回一个导航栏的外观对象
    //修改了这个外观对象，相当于修改了整个项目中的外观
    UINavigationBar *navigationBar = [UINavigationBar appearance];
    //设置导航栏背景颜色
    [navigationBar setBarTintColor:kThemeColor];
    //设置NavigationBarItem文字的颜色
    [navigationBar setTintColor:[UIColor whiteColor]];
    //设置标题栏颜色
    navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName : [UIFont systemFontOfSize:15]};
    
    //去掉导航栏下方黑线
    UIImage *img = [UIImage getImageWithColor:kThemeColor];//如此导航栏颜色 和 上面设置导航栏背景颜色是一致的
    //UIImage *img = [[UIImage alloc] init];//如此导航栏是白色的
    [navigationBar setBackgroundImage:img  forBarMetrics:UIBarMetricsDefault];
    navigationBar.shadowImage = [[UIImage alloc] init];
    
    /*
     //设置导航栏文字的主题
     NSShadow *shadow = [[NSShadow alloc]init];
     [shadow setShadowOffset:CGSizeZero];
     [navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSShadowAttributeName : shadow}];
     [navigationBar setBackgroundImage:[UIImage imageNamed:@"ic_cell_bg_selected"] forBarMetrics:UIBarMetricsDefault];
     //修改所有UIBarButtonItem的外观
     UIBarButtonItem *barButtonItem = [UIBarButtonItem appearance];
     
     // 修改item的背景图片
     //[barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
     //[barItem setBackgroundImage:[UIImage imageNamed:@"navigationbar_button_background_pushed.png"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
     //修改item上面的文字样式
     NSDictionary *dict =@{NSForegroundColorAttributeName : [UIColor whiteColor],NSShadowAttributeName : shadow};
     [barButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];
     [barButtonItem setTitleTextAttributes:dict forState:UIControlStateHighlighted];
     //修改返回按钮样式
     [barButtonItem setBackButtonBackgroundImage:[UIImage imageNamed:NAVIGATION_BAR_BACK_ICON_NAME] forState:UIControlStateNormal barMetrics:UIBarMetricsCompact];
     //设置状态栏样式
     [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
     */
}

//重写push后返回按钮的文字,文字可以为空字符串.
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //修改返回文字
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    //全部修改返回按钮,但是会失去右滑返回的手势
    if (viewController.navigationItem.leftBarButtonItem ==nil && self.viewControllers.count >=1) {
        viewController.navigationItem.leftBarButtonItem = [self creatBackButton];
        //隐藏底部TabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    [super pushViewController:viewController animated:animated];
}
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated {
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    return  [super popToRootViewControllerAnimated:animated];
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if( [self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    return [super popToViewController:viewController animated:animated];
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animate {
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}

-(UIBarButtonItem *)creatBackButton{
    return [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]style:UIBarButtonItemStylePlain target:self action:@selector(popSelf)];    
}

-(void)popSelf{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self popViewControllerAnimated:YES];
}

@end
