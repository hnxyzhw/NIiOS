//
//  AdvertiseHelper.h
//  NIiOS

//  MobileProject  处理事件在AdvertiseView里面有个NotificationContants_Advertise_Key通知，可以在首页进行获取通知，然后进行处理，比如进行跳转功能
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAd) name:NotificationContants_Advertise_Key object:nil];

//  Created by ai-nixs on 2018/11/19.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdvertiseView.h"

@interface AdvertiseHelper : NSObject
+ (instancetype)sharedInstance;

+ (void)showAdvertiserView:(NSArray<NSString *> *)imageArray;

@end
