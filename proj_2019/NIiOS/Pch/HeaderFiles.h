//
//  HeaderFiles.h
//  NIiOS
//
//  Created by ai-nixs on 2018/11/17.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#ifndef HeaderFiles_h
#define HeaderFiles_h

#pragma mark - 布局约束
// 1.定义这个常量，就可以不用在开发过程中使用"mas_"前缀。
#define MAS_SHORTHAND
// 2.定义这个常量，就可以让Masonry帮我们自动把基础数据类型的数据，自动装箱为对象类型。
#define MAS_SHORTHAND_GLOBALS
/** 1.尺寸：width、height、size
 2.边界：left、leading、right、trailing、top、bottom
 3.中心点：center、centerX、centerY
 4.边界：edges
 5.偏移量：offset、insets、sizeOffset、centerOffset
 6.priority()约束优先级（0~1000），multipler乘因数, dividedBy除因数 */
#import "Masonry.h"//布局Masonry.h
#import "YYKit.h"
#import "Toast.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "ImageCache.h"
#import "UIView+Frame.h"
#import "AsyncDisplayKit/AsyncDisplayKit.h"

#pragma mark - Catagory
#import "UIView+NIExtension.h"
#import "NSObject+NIDataFromJsonFile.h"
#import "UIImage+Color.h"//据颜色值生成图片
#import "UIButton+NIExtension.h"//btn图片文字位置布局
#import "UILabel+JRLabel.h"
#import "UILabel+ForbadSys.h"
#import "NSString+TextUtils.h"

#pragma mark - LeanCloud云存储 2019年03月12日09:05:47
#import "AVOSCloud/AVOSCloud.h"
#import "SVProgressHUD.h"

#endif /* HeaderFiles_h */
