//
//  UIImage+Color.h
//  NIiOS
//
//  Created by ai-nixs on 2018/11/22.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

/**
 据颜色值生成图片

 @param color 目标颜色值
 @return 目标颜色值->图片
 */
+ (UIImage *) getImageWithColor:(UIColor*)color;

@end
