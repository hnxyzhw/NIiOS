//
//  ConstantMacro.h
//  NIiOS
//
//  Created by ai-nixs on 2018/11/19.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#ifndef ConstantMacro_h
#define ConstantMacro_h

//---------------------- ABOUT SYSTYM & VERSION 系统与版本 ----------------------------
//Get the OS version.       判断操作系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion ([[UIDevice currentDevice] systemVersion])
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//judge the simulator or hardware device        判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

//---------------------- 适配相关 ----------------------------
//#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
//#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define kDeviceVersion [[UIDevice currentDevice].systemVersion floatValue]

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

#define kSystemNavHeight 44.0

#define kNavbarHeight (kStatusBarHeight+kSystemNavHeight)

#define kTabBarHeight (iPhoneX?(49.f+34.f):(49.f))

#define IS_IPHONEX (kScreenWidth == 375.0f) && (kScreenHeight == 812.0f) && IS_IPHONE
#define kBottomSafeHeight ((IS_IPHONEX)?(34):(0))

#define TheUserDefaults [NSUserDefaults standardUserDefaults]

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define kSCREEN_MAX_LENGTH (MAX(kScreenWidth, kScreenHeight))
#define kSCREEN_MIN_LENGTH (MIN(kScreenWidth, kScreenHeight))

#define IS_IPHONE4 (IS_IPHONE && kSCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE5 (IS_IPHONE && kSCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE6 (IS_IPHONE && kSCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE6P (IS_IPHONE && kSCREEN_MAX_LENGTH == 736.0)
#define IS_IPhoneX (kScreenWidth == 375.0f) && (kScreenHeight == 812.0f) && IS_IPHONE
//iPhoneX / iPhoneXS
#define  isIphoneX_XS     (kScreenWidth == 375.f && kScreenHeight == 812.f ? YES : NO)
//iPhoneXR / iPhoneXSMax
#define  isIphoneXR_XSMax    (kScreenWidth == 414.f && kScreenHeight == 896.f ? YES : NO)
//异性全面屏
#define   isFullScreen    (isIphoneX_XS || isIphoneXR_XSMax)

// 状态栏高度
//#define  kStatusBarHeight      (isFullScreen ? 44.f : 20.f)
// 导航栏高度
#define  kNavigationBarHeight  44.f
// TabBar高度
#define  kTabbarHeight        (isFullScreen ? (49.f+34.f) : 49.f)
// Tabbar底部安全区
#define  kTabbarSafeBottomMargin        (isFullScreen ? 34.f : 0.f)
// 导航栏+状态栏高度
#define  kStatusBarAndNavigationBarHeight  (isFullScreen ? 88.f : 64.f)

#define intToStr(S)    [NSString stringWithFormat:@"%d",S]
#define kSafeString(__X__)        [__X__ isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@", (__X__)]

/**
 *  属性转字符串
 */
#define NIKeyPath(obj, key) @(((void)obj.key, #key))

// 是否为空对象
#define MHObjectIsNil(__object)  ((nil == __object) || [__object isKindOfClass:[NSNull class]])

//是否是空对象
#define NIIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

//不同屏幕尺寸字体适配
#define kScreenWidthRatio  (UIScreen.mainScreen.bounds.size.width / 375.0)
#define kScreenHeightRatio (UIScreen.mainScreen.bounds.size.height / 667.0)
#define AdaptedWidth(x)  ceilf((x) * kScreenWidthRatio)
#define AdaptedHeight(x) ceilf((x) * kScreenHeightRatio)
#define AdaptedFontSize(R)     [UIFont systemFontOfSize:AdaptedWidth(R)]

//由角度转换弧度
#define kDegreesToRadian(x)      (M_PI * (x) / 180.0)
//由弧度转换角度
#define kRadianToDegrees(radian) (radian * 180.0) / (M_PI)

/** 弱引用 */
#define WEAKSELF __weak typeof(self) weakSelf = self
#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

/** 避免self的提前释放 */
#define STRONGSELF __weak typeof(weakSelf) strongSelf = weakSelf
/** 设置图片 */
#define kGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]

//----------------------ABOUT PRINTING LOG 打印日志 ----------------------------
//Using dlog to print while in debug model.        调试状态下打印日志
/**
 只在debug的时候输出, release的时候不输出
 Stack Overflow上很多人推荐的
 介绍:Address:http://www.jianshu.com/p/7f68a342de67
 */
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

/** 修改Log,debug：NILog，执行NSLog，release，自动忽略 */
#ifdef DEBUG
#define NILog(...) NSLog(__VA_ARGS__)
#else
#define NILog(...)
#endif

#ifdef DEBUG
#define NILogFunc NSLog(@"=====Begin==========\n FILE: %@\n FUNC: %s\n LINE: %d\n", [NSString stringWithUTF8String:__FILE__].lastPathComponent, __PRETTY_FUNCTION__, __LINE__)
#else
#define NILogFunc
#endif

/** print 打印rect,size,point */
#ifdef DEBUG
#define NILogPoint(point)    NSLog(@"%s = { x:%.4f, y:%.4f }", #point, point.x, point.y)
#define NILogSize(size)      NSLog(@"%s = { w:%.4f, h:%.4f }", #size, size.width, size.height)
#define NILogRect(rect)      NSLog(@"%s = { x:%.4f, y:%.4f, w:%.4f, h:%.4f }", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#endif

//---------------------- 颜色相关 ----------------------------
//主题色
//#define kThemeColor ([UIColor colorWithRed:252.0/255.0 green:109.0/255.0 blue:9.0/255.0 alpha:1.0])
//#define kThemeColor ([UIColor colorWithRed:23.0/255.0 green:117.0/255.0 blue:87.0/255.0 alpha:1.0])
#define kThemeColor ([UIColor redColor])
#define kTintColor ([UIColor colorWithRed:67.0/255.0 green:194.0/255.0 blue:71.0/255.0 alpha:1.0])

#define COLOR_WITH_HEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0f]

// 暗红
#define kRedColor COLOR_WITH_HEX(0xeb2d3a)
// 暗白红(不可点击的颜色)
#define kRedGrayColor COLOR_WITH_HEX(0xfdcdd0)

//设置随机颜色
#define NIRandomColor [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1];

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

//格式0xdae8a6
#define NICOLOR_FROM_RGB_OxFF_ALPHA(rgbValue, al)                        \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0    \
blue:((float)(rgbValue & 0xFF)) / 255.0             \
alpha:al]

#define kClearColor [UIColor clearColor]

#define COLOR_BLUE_             UIColorFromRGB(0x41CEF2)
#define COLOR_GRAY_             UIColorFromRGB(0xababab) //171
#define COLOR_333               UIColorFromRGB(0x333333) //51
#define COLOR_666               UIColorFromRGB(0x666666) //102
#define COLOR_888               UIColorFromRGB(0x888888) //136
#define COLOR_999               UIColorFromRGB(0x999999) //153
#define COLOR_PLACEHOLD_        UIColorFromRGB(0xc5c5c5) //197
#define COLOR_RED_              UIColorFromRGB(0xff5400) //红色
#define COLOR_GREEN_            UIColorFromRGB(0x31d8ab)//绿色
#define COLOR_YELLOW_           UIColorFromRGB(0xffa200)//黄色
#define COLOR_SEPARATE_LINE     UIColorFromRGB(0xC8C8C8)//200
#define COLOR_LIGHTGRAY         COLOR(200, 200, 200, 0.4)//淡灰色

#define MAX_WIDTH_10        (SCREEN_WIDTH-20)
#define MAX_WIDTH_15        (SCREEN_WIDTH-30)

//----------------------ABOUT IMAGE 图片 ----------------------------

//LOAD LOCAL IMAGE FILE     读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//DEFINE IMAGE      定义UIImage对象//    imgView.image = IMAGE(@"Default.png");

#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

//DEFINE IMAGE      定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]

//BETTER USER THE FIRST TWO WAY, IT PERFORM WELL. 优先使用前两种宏定义,性能高于后面.

//设置 View 边框粗细和颜色
#define NIViewBorderRadius(View, Width, color) \
\
[View.layer setBorderWidth:(Width)];       \
[View.layer setBorderColor:color];          \

//设置圆角
#define NIViewSetRadius(View, Radius)      \
\
[View.layer setCornerRadius:(Radius)]; \
[View.layer setMasksToBounds:YES];     \

#define NIUIFontSize(size) [UIFont systemFontOfSize:size]
#define NIUIFontboldSize(size) [UIFont boldSystemFontOfSize:size];
//---------------------- 沙盒目录文件 -----------
#define kPathTem NSTemporaryDirectory() //获取Temp 目录
//获取沙盒 Document
#define kPathDocument   \
[NSSearchPathForDirectoriesInDomains(NSdocumentDirectory, NSUserDomainMask, YES) firstObject];

//获取沙盒 Cache
#define kPathCache      \
[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];

//---------------------- 快捷操作 -----------
//获取通知中心
#define NINotificationCenter [NSNotificationCenter defaultCenter]


//---------------------- USERDEFAULTS ----------------------------
#define USERDEFAULTS [NSUserDefaults standardUserDefaults]

/**
 *  the saving objects      存储对象
 *
 *  @param __VALUE__ V
 *  @param __KEY__   K
 *
 *  @return
 */
#define UserDefaultSetObjectForKey(__VALUE__,__KEY__) \
{\
[[NSUserDefaults standardUserDefaults] setObject:__VALUE__ forKey:__KEY__];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}
/**
 *  get the saved objects       获得存储的对象
 */
#define UserDefaultObjectForKey(__KEY__)  [[NSUserDefaults standardUserDefaults] objectForKey:__KEY__]
/**
 *  delete objects      删除对象
 */
#define UserDefaultRemoveObjectForKey(__KEY__) \
{\
[[NSUserDefaults standardUserDefaults] removeObjectForKey:__KEY__];\
[[NSUserDefaults standardUserDefaults] synchronize];\
}
#define PLIST_TICKET_INFO_EDIT [NSHomeDirectory() stringByAppendingString:@"/Documents/data.plist"] //edit the plist
#define TableViewCellDequeueInit(__INDETIFIER__) [tableView dequeueReusableCellWithIdentifier:(__INDETIFIER__)];
#define TableViewCellDequeue(__CELL__,__CELLCLASS__,__INDETIFIER__) \
{\
if (__CELL__ == nil) {\
__CELL__ = [[__CELLCLASS__ alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:__INDETIFIER__];\
}\
}
#define KEYWINDOW [UIApplication sharedApplication].keyWindow
//Show Alert, brackets is the parameters.       宏定义一个弹窗方法,括号里面是方法的参数
#define ShowAlert    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning." message:nil delegate:self cancelButtonTitle:@"cancel" otherButtonTitles: @"OK"];[alert show];
#endif
//GCD
#define GCDWithGlobal(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define GCDWithMain(block) dispatch_async(dispatch_get_main_queue(),block)

//为了可以多个类使用单例,可以把单例模式写成宏的模式,直接上代码:
// .h
#define singleton_interface(class) \
+ (instancetype)sharedInstance;

// .m
#define singleton_implementation(class) \
static class *_instance; \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
\
return _instance; \
} \
\
+ (instancetype)sharedInstance \
{ \
if (_instance == nil) { \
_instance = [[class alloc] init]; \
} \
\
return _instance; \
}\
\
-(id)copyWithZone:(NSZone *)zone{\
return _instance;\
}\
\
-(id)mutableCopyWithZone:(NSZone *)zone{\
return _instance;\
}

/** 快速查询一段代码的执行时间 */
/** 用法
 TICK
 do your work here
 TOCK
 */
#define TICK NSDate *startTime = [NSDate date];
#define TOCK NSLog(@"Time:%f", -[startTime timeIntervalSinceNow]);


#define dispatch_sync_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_async_main_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

/* ConstantMacro_h */
