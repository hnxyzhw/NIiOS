//
//  NIConstant.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/19.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "NIConstant.h"

@implementation NIConstant
#pragma mark - margin
CGFloat const margin = 10.0f;

#pragma mark - 基类里版本更新控制
CGFloat const timeOut = 30.0;
NSString *const versionTitle=@"敏捷开发模块库";
NSString *const versionDesc=@"敏捷开发模块库有更新内容了\n\n QQ:1911398892 \nWX:wvqusrtg";

#pragma mark - AppStore App URL
NSString *const appStoreURL=@"https://itunes.apple.com/cn/app/%E4%B8%AD%E4%BF%A1%E9%93%B6%E8%A1%8C%E6%89%8B%E6%9C%BA%E9%93%B6%E8%A1%8C/id422844108?mt=8&from=singlemessage&isappinstalled=0";

#pragma mark - 二维码金额DES加密key值
NSString *const desKey = @"NIXS15001291877"; //DESKey 密钥

#pragma mark - LeanCloud秘钥 2019年03月12日09:14:28(接口反馈数据里竟然发现用的七牛的云存储-坑！！！)
NSString *const LeanCloud_AppID = @"w6NEDFXUQURsyW9UXlHmkdN5-gzGzoHsz";
NSString *const LeanCloud_AppKey = @"ncqQExpnCWjQSbaieqyDgM0D";


@end
