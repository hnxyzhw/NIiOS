//
//  UIButton+NIExtension.h
//  NIiOS
//
//  Created by ai-nixs on 2018/11/22.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (NIExtension)
/**
 交换按钮文字图片位置(文字左 图片右)
 @param button btn
 */
+ (void)changeImageWithTitle:(UIButton *)button;

//参考资料:UIButton按钮图片和文字的自动调整 https://www.cnblogs.com/wangliang2015/p/5569301.html
//1.默认左图 右文字

/**
 2.交换按钮文字图片位置(左文字 & 右图片)
 */
+ (void)setImageRightLeftTitle:(UIButton *)button;

/**
 3.图片在上 文字在下(上图片 & 下文字)
 */
+ (void)setImageUpDownTitle:(UIButton *)button;
@end
