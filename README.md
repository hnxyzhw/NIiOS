# NiiOS
##### (一) 简介 & 规划

>i、「目前主要做iOS客户端开发」一直没有好好沉淀记录下自己学习东西;这里把目前主要做的iOS端常用知识点总结下,便于后续开发拿来直接用；

>ii、(NIiOS)iOS开发整理合集-极力欢迎志同道合小伙伴讨论、贡献代码！！！(不仅限于客户端)

>iii.后续本Demo更新内容会不定时在我的订阅号里更新欢迎关注：
>![](./Res/WechatIMG16.jpeg)

---
##### (二) 后续待整理
```
0.把LeanCloud云储存搞一遍,后续最起码不用部署服务器就能写云储存的App了，如果量级（性能要求）上去了-考虑重新写后端（首选Java-因为Java我这边还能写「微服务、阿里云ECS/RDS/OSS/CDN+SLB」）；
1.拍小视频类似微信视频编辑-ThinkSNS借鉴；
2.腾讯直播方案可以了解下；
3.YYkit 源码Demo撸一遍；
```
---
##### (三) 「NIiOS」Demo开发库整理进行时

```

Flowing:2019年03月18日
62.iOS获取图片的大小（宽高）地址：https://www.jianshu.com/p/5412c1862c8a?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation
61.一行代码实现Badge效果(iOS) BADGE IN ONE LINE(iOS)
60.第三方登陆、分享集成-推荐OpenShare;
59.微信支付开通条件了解下；

Flowing:2019年03月18日
59.LeanCloud数据存储、读取进一步学习；

Flowing:2019年03月16日
58.Swift纯代码项目练手-Snapkit布局「和OC的Masnory同级」基础使用

Flowing:2019年03月15日
57.Swift 最新语法过一遍,比如最新开发中用到的一个折线图上气泡绘制，OC调Swift；推荐Swift学习地址[Swift变成语言](https://www.cnswift.org/a-swift-tour)

Flowing:2019年03月14日
56.关于iOS端推送、推送拓展(NotificationService)、基础推送、VOIP推送及各个证书制作流程、上线流程等相关内容有需要-小伙伴谁想了解私聊小编；
55.YTKNetWorking使用可以参考“推推管家”这个不怎么滴的应用里有用-小伙伴谁想了解私聊小编；
54.LeanCloud在线商品发布朋友圈简单商品发布Demo;

Flowing:2019年03月13日
53.LeanCloud在线商品发布朋友圈简单布局;

Flowing:2019年03月12日
52.UICollectionView简单瀑布流;
51.LeanClouod结合UICollectionView 对象 和 图片文件存储「后续自己搞着玩的应用没有接口的前提下可以先用LeanCloud存储数据」(数据响应的性能考虑，数据异步请求完成回到主线程刷新UI)；
50.不想写后台接口了-LeanCloud引入学习(基础的数据调用还是够的，后续数据量级够了再引入后台接口)（https://leancloud.cn/docs/start.html）

Flowing:2019年03月11日
49.调用系统邮件发送功能 || 或提示框给出要接收邮件人邮箱地址；（/Users/nixs/Documents/NIiOS/NIiOS/Module/Main/C/LeftViewController.m）

Flowing:2019年02月28日
48.RunTime应用实例；

Flowing:2019年02月20日
47.UICollectionView step2:在自定义View上嵌套UICollectionView-item选定 & 全部反选 & 确定提交 & 页面传值封装;

Flowing:2019年02月19日
46.UICollectionView step2:在自定义View上嵌套UICollectionView;


Flowing:2019年02月14日
45.UICollectionView基础&拖动特性 勿忘扩展删除+新增Item;
44.多线程下载基础NSData/NSURLConnection方式（小文件、大文件&进度条展示）；

Flowing:2019年02月12日
43.***iOS多线程（thread/NSThread/GCD/NSOperation/NSOperationQueue）；

Flowing:2019年01月31日
42.加解密基础；
41.KVC键值编码、KVO键值监听；
40.表格cell高度计算5中方案（AutoLayout/CountHeight/Frame/YYKit/ASDK）；
39.二维码图片合成；


Flowing:2018年12月X日
38.iOS多线程整理；

Flowing:2018年12月14日
39.tableViewCell xib布局 和 纯代码布局区别；
38.(AES128+Base64) URLEncode编码

Flowing:2018年12月12日
37.iOS手势解；
    "0.设置手势密码",
    "1.登陆手势密码",
    "2.验证手势密码",
    "3.修改手势密码"

Flowing:2018年12月10日
36.新增全局宏定义 支持iphoneX/iphoneXR/iphoneXS/iphoneXS_Max;

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
#define  kStatusBarHeight      (isFullScreen ? 44.f : 20.f)
// 导航栏高度
#define  kNavigationBarHeight  44.f
// TabBar高度
#define  kTabbarHeight        (isFullScreen ? (49.f+34.f) : 49.f)
// Tabbar底部安全区
#define  kTabbarSafeBottomMargin        (isFullScreen ? 34.f : 0.f)
// 导航栏+状态栏高度
#define  kStatusBarAndNavigationBarHeight  (isFullScreen ? 88.f : 64.f)


35.*** - iOS操作基本Plist文件-待进一步更新理解学习；
34.iMac上代码段更新 和 MacBookPro保持同步；-CodeSnippets 代码段库 在git上

Flowing:2018年12月08日
33.SourceTree iMac上管理代码仓库；
32.证书切换为用鹏哥的个人证书；
31.代码仓库迁移到git 码云里-变成私有仓库；

Flowing:2018年12月07日
30.图片验证码绘制；

29.单例宏定义-快速单例实例化 注:不要忘记遵循两个代理NSCopying ，NSMulCopying；
28.单例的进一步理解使用 & 实例；

Flowing:2018年12月03日
27.加载在线和本地Web页面-cocoapods引入第三方（#2018年12月03日10:52:19-https://github.com/xiubojin/JXBWKWebView
    pod 'JXBWebKit', '~> 1.0.6'）
{   //新增了 X 关闭按钮的资源文件（图片资源）
    //修改了源码里文件 JXBWebViewController.m line:265
    //JXBWebViewController *niWebVC = [[JXBWebViewController alloc] initWithURLString:model1.url];

    注:JXBWebViewController.h/m是可以获取XXX.html里的title的
}

Flowing:2018年11月29日
26.IOS异步获取数据并刷新界面dispatch_async的使用方法 参考链接:https://www.cnblogs.com/wangxiaorui/p/5390088.html

Flowing:2018年11月27日
25.更新头部导航颜色值和头部有轮播图控制器对比比较鲜明；
24.首页-预演 分组展示Demo栏目；

Flowing:2018年11月26日
23.iOS基类表格初始化-能传入表格类型自定义封装；
22.iOS表格布局 表头、表尾、区头、区尾整理封装；

Flowing:2018年11月23日
21.二维码保存相册-屏蔽；
20.二维码保存相册-整理完成；

Flowing:2018年11月22日
19.保存指定区域View作为图片 到系统相册；
18.优化去除头部导航栏下方黑线
    //设置导航栏背景颜色
    UIImage *img = [UIImage getImageWithColor:[UIColor redColor]];
    [self.navigationController.navigationBar setBackgroundImage:img  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];

17.我的/名片自定义View分类引入
16.新增据颜色值生成图片分类

Flowing:2018年11月20日
15.HomeViewController.h/m 表格-轮播图-换成表格的第一个cell里显示
    HomeViewController.h/m 表格头视图-轮播图(本方案也行-是原来写的有BUG-确定实行还是本方案)

Flowing:2018年11月19日
14.HomeViewController.h/m 表格头视图-轮播图
13.加载网页封装里新增获取网页标题 
12.加载网页封装VC；
11.抽屉引入 pod 'CWLateralSlide'使用自定义转场动画实现的0耦合、0侵入、0污染的抽屉框架；
10.启动广告引入：AdvertiseHelper.h/m
9.Pch/NIConstant.h/m常量值抽取-便于做国际化
8.版本检查自定义View引入 NIVersionManagerView.h/m
7. Toast使用 https://github.com/scalessec/Toast
6.网络检测通知引入 + 网络检测自定义View引入 NINetWorkDetectionView.h/m

Flowing:2018年11月19日
5.Base基类补充(自定义nav/tab/BaseViewController/BaseModel)
4.[iOS 找出导航栏下面的黑线(可隐藏,改变样式等)](https://www.jianshu.com/p/effa4a48f1e3)
3.Utils/Catagory/UIView+NIExtension.h 分类整理
2.#import pod 依赖找不到 Build Settings/User Header Search Paths /新增:$(SRCROOT) - recursive
1.PCH引入 Build Settings/Prefix Header/$(SRCROOT)/NIiOS/Pch/GlobalPrefixHeader.pch
0.Xcode后续打包编码问题 #Xcode里配置：项目名->Target->Build Settings->Enable BitCode中设置为NO就可以了.

```
##### 本人联系方式
>手机/微信同号:15001291877