//
//  UIImage+Color.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/22.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)
+ (UIImage *)getImageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
