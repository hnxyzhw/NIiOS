//
//  AdvertiseView.h
//  NIiOS
//
//  Created by ai-nixs on 2018/11/19.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const NotificationContants_Advertise_Key;

@interface AdvertiseView : UIView

/** 显示广告页面方法*/
- (void)show;

/** 图片路径*/
@property (nonatomic, copy) NSString *filePath;

@end
