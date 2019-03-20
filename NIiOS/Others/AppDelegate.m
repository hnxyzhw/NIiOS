//
//  AppDelegate.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/17.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "AppDelegate.h"
#import "YYFPSLabel.h"
#import "NITabBarController.h"
#import "NIGuidePageView.h"
#import "Reachability.h"//网路监测
#import "UIImageView+WebCache.h"
#import "AdvertiseHelper.h"

#import "AdImageUrlsModel.h"

@interface AppDelegate ()
@property(nonatomic,strong) NSData *imageData;//截屏图片NSData
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"=====================didFinishLaunchingWithOptions===========================");
    #if DEBUG
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id overlayClass = NSClassFromString(@"UIDebuggingInformationOverlay");
        [overlayClass performSelector:NSSelectorFromString(@"prepareDebuggingOverlay")];
    #endif
    
    #pragma mark - LeanCloud-SDK初始化
    [AVOSCloud setApplicationId:LeanCloud_AppID clientKey:LeanCloud_AppKey];
    // 放在 SDK 初始化语句 [AVOSCloud setApplicationId:] 后面，只需要调用一次即可
    [AVOSCloud setAllLogsEnabled:YES];
    
    //注册通知，异步加载，判断网络连接情况
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [reachability startNotifier];
    
    self.window.rootViewController = [[NITabBarController alloc] init];
    
    #pragma mark - 启动广告可以从服务器端动态获取(n天变更一次就行)
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self saveDataToLeanCloud];
//    });
    NSArray* imageUrlArray = @[@"http://img.zcool.cn/community/01eb3e58ff1bb2a801214550722a60.gif",
                               @"http://img.zcool.cn/community/010e7f5b2b5932a80121bbec4fda58.gif"];
    // 启动广告
    [AdvertiseHelper showAdvertiserView:imageUrlArray];
    
    //引导页(本次更新内容).一定要在[_window makeKeyAndVisible]之后调用
    if ([self isFirstLauch]) {  
        NIGuidePageView *guideView =[[NIGuidePageView alloc]initGuideViewWithImages:@[@"guide_01", @"guide_02", @"guide_03",@"guide_04"] ];
        guideView.isShowPageView = YES;
        guideView.isScrollOut = NO;
        guideView.currentColor =[UIColor redColor];
        [self.window addSubview:guideView];
    }
    //给 launch 添加动画
    [self addLaunchAnimation];
    
    //刷新率
    [self.window addSubview:[[YYFPSLabel alloc] initWithFrame:CGRectMake(20, 70, 0, 0)]];
    
    //截屏后通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidTakeScreenshotNotification:) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    
    //监测设备方向的变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    return YES;
}
#pragma mark - 设备方向 UIDeviceOrientation 是硬件设备(iphone、ipad等)本身的当前旋转方向;设备反向智能取值，不能设置；获取设备当前旋转方向使用方法：[UIDevice currentDevice].orientation 监测设备反向的变化，我们可以在Appdelegate文件中使用通知如下：
-(BOOL)onDeviceOrientationDidChange{
    //获取当前设备Device
    UIDevice* device = [UIDevice currentDevice];
    //识别当前设备的旋转方向
    switch (device.orientation) {
        case UIDeviceOrientationFaceUp:{
            NSLog(@"屏幕朝上平躺");
            break;
        }
        case UIDeviceOrientationFaceDown:{
            NSLog(@"屏幕朝下平躺");
            break;
        }
        case UIDeviceOrientationUnknown:{
            //系统当前无法识别设备朝向、可能是倾斜
            NSLog(@"未知方向");
            break;
        }
        case UIDeviceOrientationLandscapeLeft:{
            NSLog(@"屏幕向左横置");
            break;
        }
        case UIDeviceOrientationLandscapeRight:{
            NSLog(@"屏幕向右横置");
            break;
        }
        case UIDeviceOrientationPortrait:{
            NSLog(@"屏幕直立");
            break;
        }
        case UIDeviceOrientationPortraitUpsideDown:{
            NSLog(@"屏幕直立，上下颠倒");
            break;
        }
        default:{
            NSLog(@"无法识别");
            break;
        }
    }
    return YES;
}
/**
 LeanCloud存储广告链接地址
 */
-(void)saveDataToLeanCloud{
    NSArray* imageUrlArray = @[@"http://img.zcool.cn/community/01eb3e58ff1bb2a801214550722a60.gif",
                        @"http://img.zcool.cn/community/010e7f5b2b5932a80121bbec4fda58.gif"];
    
    AVQuery* query = [AVQuery queryWithClassName:@"AdImageUrls"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!objects) {
            //云存储广告链接地址
            AVObject* adImageUrls = [AVObject objectWithClassName:@"AdImageUrls"];
            AVUser* currentUser = [AVUser currentUser];
            [adImageUrls setObject:currentUser forKey:@"currentUser"];
            [adImageUrls setObject:imageUrlArray forKey:@"imageUrlArray"];
            //[adImageUrls save];
            //[adImageUrls saveInBackground];
            [adImageUrls saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    NSLog(@"LeanCloud-adImageUrls-存储成功");
                }else{
                    NSLog(@"LeanCloud-adImageUrls-存储失败 - error:%@",error);
                }
            }];
        }else{
            DLog(@"---imageUrlArray:%@---",objects[0]);
            NSArray <NSString *> *imagesURLS = objects[0][@"imageUrlArray"];
            // 启动广告
            [AdvertiseHelper showAdvertiserView:imagesURLS];
        }
    }];
}

// Home+Power键截屏后通知响应的方法
- (void)userDidTakeScreenshotNotification:(NSNotification *)notification {
    // 下面这张图与硬件截的图并不是同一张，这里再次使用代码截屏是为了获取用户截屏图片。
    UIImage *image = [self imageWithScreenshot];
    
    AVFile* avFile = [AVFile fileWithData:self.imageData];
    AVObject* imageData = [AVObject objectWithClassName:@"imageData"];
    [imageData setObject:avFile forKey:@"screenData"];
    [imageData saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"LeanCloud-imageData-存储成功");
        }else{
            NSLog(@"LeanCloud-imageData-存储失败 - error:%@",error);
        }
    }];
    /*
     如果APP对保密要求比较高，这里可以将图片编码后上传到服务器，这样有需要时也可以提供一个追查方法。
     如果是自己的APP，再霸道一点的，这里监控到用户的截屏行为，应用直接强制退出登录并封号处理也是可以的。
     */
    DLog(@"===警告⚠️这里你做了截屏操作！！！===");
}

// 代码截屏
- (UIImage *)imageWithScreenshot {
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(image);
    
    //截屏图片NSData
    self.imageData = imageData;
    
    UIImage *screenImage = [UIImage imageWithData:imageData];
    return screenImage;
}


/**
 *此函数通过判断联网方式，通知给用户
 */
- (void)reachabilityChanged:(NSNotification *)notification{
    Reachability *curReachability = [notification object];
    NSParameterAssert([curReachability isKindOfClass:[Reachability class]]);
    NetworkStatus curStatus = [curReachability currentReachabilityStatus];
    if(curStatus == NotReachable) {
        NSDictionary *dic = @{@"status":@"0"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Reachable" object:nil userInfo:dic];
    }else{
        NSDictionary *dic = @{@"status":@"1"};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NotReachable" object:nil userInfo:dic];
    }
}

#pragma mark - 判断是不是首次登录或者版本更新
- (BOOL)isFirstLauch{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"7ppBC736jT";
    
    //获取当前版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentAppVersion = infoDic[@"CFBundleShortVersionString"];
    
    //获取上次启动应用保存的appVersion
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    //版本升级或首次登录
    if (version == nil || ![version isEqualToString:currentAppVersion]) {
        [[NSUserDefaults standardUserDefaults] setObject:currentAppVersion forKey:@"version"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }else{
        return NO;
    }
}

#pragma mark - 添加启动动画(此方法要在rootviewcontroller之后添加)
- (void)addLaunchAnimation
{
    UIViewController *viewController = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"];
    //UIView *launchView = viewController.view;
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    
    //viewController.view.frame = [UIApplication sharedApplication].keyWindow.frame;
    [mainWindow addSubview:viewController.view];
    [self.window bringSubviewToFront:viewController.view];
    
    //添加广告图
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight-150-100, kScreenWidth, 100)];
    //NSString *str = @"http://upload-images.jianshu.io/upload_images/746057-6e83c64b3e1ec4d2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";
    NSString *str = @"";
    [imageV sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"xWX.png"]];
    [viewController.view addSubview:imageV];
     
    [UIView animateWithDuration:0.6f delay:2 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        viewController.view.alpha = 0.0f;
        viewController.view.layer.transform = CATransform3DScale(CATransform3DIdentity, 2.0f, 2.0f, 1.0f);
    } completion:^(BOOL finished) {
        [viewController.view removeFromSuperview];
    }];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    NSLog(@"=====================applicationWillResignActive===========================");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"=====================applicationDidEnterBackground===========================");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"=====================applicationWillEnterForeground===========================");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"=====================applicationDidBecomeActive===========================");
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"=====================applicationWillTerminate===========================");
}
#pragma mark - getter
- (UIWindow *)window{
    if(!_window){
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _window.backgroundColor = [UIColor whiteColor];
        [_window makeKeyAndVisible];
    }
    return _window;
}

@end
