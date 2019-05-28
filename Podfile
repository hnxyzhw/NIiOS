source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/Artsy/Specs.git'

platform :ios, '8.0'
# 引用框架
use_frameworks!
# ignore all warnings from all pods(注解)
inhibit_all_warnings!

target 'NIiOS' do    
    # 网络监控
    pod 'Reachability'
    #1、YTKNetWork网络请求(猿题库)
    pod 'YTKNetwork'    
    #3、推送消息提醒https://github.com/GREENBANYAN/PushNotificationManager
    pod 'PushNotificationManager'   
    #4、数据库
    pod 'FMDB'        
    pod 'Masonry'   
    #6、上下拉刷新
    pod 'MJRefresh'
    #7、json/model互转
    pod 'MJExtension'
    #8、YYKIT https://github.com/ibireme/YYKit
    pod 'YYKit', '~> 1.0.7'
    pod 'AsyncDisplayKit', '~> 1.9.90'
    #10、键盘
    pod 'IQKeyboardManager'
    #12、把很多系统的delegate，方法等 翻新成block 了，对与UIKit 类的，还是比较方便使用的。对于喜欢block的可以考虑试试。（注tableView 这样大个的 delegate 还是算了把骚年
    #pod 'BlocksKit'
    #13、指示层
    pod 'SVProgressHUD'
    # toast
    pod 'Toast'
    pod 'SDWebImage'
    pod 'SDCycleScrollView'
    #打破传统侧滑抽屉框架LeftVC，RightVC，CenterVC模式，使用自定义转场动画实现的0耦合、0侵入、0污染的抽屉框架，抽屉控制器拥有完整的生命周期函数调用，关闭抽屉时抽屉不会展示在我们看不见的地方（屏幕外，或者根控制器下边），最重要的是简单：只要一行代码就能拥有一个侧滑抽屉。
    pod 'CWLateralSlide'
    #16、搜索
    pod 'PYSearch' 
    #17、仿新浪微博客户端“加号”按钮弹出动画
    pod 'BHBPopView'                
    #18、多图片浏览地址https://github.com/mwaterfall/MWPhotoBrowser(pod 'SDWebImage','~> 3.7','!= 3.7.2')
    #pod 'MWPhotoBrowser'        
    #19、照片选择、裁剪浏览器
    pod 'TZImagePickerController'
    #iOS仿微信小视频功能开发优化记录
    #pod 'PKShortVideo'
    #A nice ALAssetsLibrary category for saving images & videos into custom photo album.
    #pod 'ALAssetsLibrary-CustomPhotoAlbum', '~> 1.3.4'
    #20、tableView拓展侧滑https://github.com/CEWendel/SWTableViewCell;另外可以借鉴https://github.com/MortimerGoro/MGSwipeTableCell)
    pod 'SWTableViewCell'
    #日期选择器
    #pod 'XHDatePicker'
    #21、TableView数据为空处理(参考资料)
    #pod 'DZNEmptyDataSet'
    #iOS一行代码集成空白页面占位图(基于runtime+MJRefresh思想) 空内容界面占位视图。emptyView-empty set-支持TableView、CollectionView
    #参考链接https://github.com/yangli-dev/LYEmptyView
    #pod 'LYEmptyView'
    #下拉列表-对题库通用下拉菜单DTKDropdownMenu extensionhttps://github.com/jidibingren/DTKDropdownMenu.git)
    #pod 'DTKDropdownMenu-JDBR'
    #22、下拉菜单：Homepagehttps://github.com/chenfanfang/FFDropDownMenu
    #pod 'FFDropDownMenu'
    #DOPDropDownMenu 添加双列表 优化版 新增图片支持（double tableView, The optimization version ，new add image,detailText）
    #pod 'DOPDropDownMenu-Enhanced', '~> 1.0.0'
    #23、个人封装-沙盒内容及时间操作
    pod 'NICopyDBToSandBox', '~> 0.0.2'
    # iOS 使用UICountingLabel实现数字变化的动画效果https://github.com/dataxpress/UICountingLabel
    pod 'UICountingLabel'
    # 友盟统计标准SDK，含IDFA
    pod 'UMengAnalytics'    
    #2、参考https://github.com/zhangao0086/RegexKitLite-NoWarning
    pod 'RegexKitLite-NoWarning'
    #iOS AlertView 超酷效果支持Block
    pod 'SCLAlertView-Objective-C'    
    #阿里云 iOS端Pod依赖
    pod 'AliyunOSSiOS'
    
    #2018年12月03日10:52:19-https://github.com/xiubojin/JXBWKWebView
    pod 'JXBWebKit', '~> 1.0.6'
    
    #LeanCloud引入 2019年03月12日09:02:12
    pod 'AVOSCloud'               # 数据存储、短信、云引擎调用等基础服务模块
    pod 'AVOSCloudIM'             # 即时通讯模块
    
    #七牛云存储 2019年03月12日11:05:53
    pod 'Qiniu', '~> 7.1'
    
    #表格高度自适应
    pod 'UITableView+FDTemplateLayoutCell'
    
    #高德地图引入
    #pod 'AMapLocation'#定位SDK
    pod 'AMapLocation-NO-IDFA'#无IDFA版定位 SDK 
    
end

#Xcode里配置：项目名->Target->Build Settings->Enable BitCode中设置为NO就可以了.
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end
