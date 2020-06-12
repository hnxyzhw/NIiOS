//
//  UIImage+BarOrQRCode.h
//  NIiOS
//
//  Created by ai-nixs on 2018/11/22.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    kCodePatternForBarCode = 0,//条形码，一维码
    kCodePatternForQRCode = 1//二维码
}kCodePattern;

@interface UIImage (BarOrQRCode)
/**
 *  生成二维码
 *
 *  @param string  二维码字符串
 *  @param size    图片宽度 height = width
 *  @param color   二维码颜色
 *  @param pattern code类型
 *
 *  @return self
 */
+ (instancetype)imageForCodeString:(NSString *)string size:(CGFloat)size color:(UIColor *)color pattern:(kCodePattern)pattern;




/**
 生成二维码图片

 @param string 目标待生成字符串或者网址
 @param Imagesize 图片size
 @param waterImagesize 水印图片size
 @return UIImage
 */
+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImageSize:(CGFloat)waterImagesize;
@end
