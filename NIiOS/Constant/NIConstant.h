//
//  NIConstant.h
//  NIiOS
//
//  Created by ai-nixs on 2018/11/19.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NIConstant : NSObject
#pragma mark - margin
UIKIT_EXTERN CGFloat const margin;

#pragma mark - 基类里版本更新控制
UIKIT_EXTERN CGFloat const timeOut;
UIKIT_EXTERN NSString *const versionTitle;
UIKIT_EXTERN NSString *const versionDesc;

#pragma mark - AppStore App URL
UIKIT_EXTERN NSString *const appStoreURL;

#pragma mark - 二维码金额DES加密key值
extern NSString * const desKey; //DESKey

#pragma mark - LeanCloud秘钥 2019年03月12日09:14:28
UIKIT_EXTERN NSString *const LeanCloud_AppID;
UIKIT_EXTERN NSString *const LeanCloud_AppKey;

#pragma mark - 高德Key
UIKIT_EXTERN NSString *const Map_APIKey;

@end
