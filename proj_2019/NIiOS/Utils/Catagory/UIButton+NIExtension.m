//
//  UIButton+NIExtension.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/22.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "UIButton+NIExtension.h"

@implementation UIButton (NIExtension)
+ (void)changeImageWithTitle:(UIButton *)button {
    CGFloat labelWidth = button.titleLabel.intrinsicContentSize.width;
    CGFloat imageWidth = button.imageView.frame.size.width;
    CGFloat space = 0.0f;
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, - imageWidth - space,0,imageWidth + space);
    button.imageEdgeInsets = UIEdgeInsetsMake(15, labelWidth + space, 15,  -labelWidth - space);
}

+ (void)setImageRightLeftTitle:(UIButton *)button{
    button.titleLabel.backgroundColor = button.backgroundColor;
    button.imageView.backgroundColor = button.backgroundColor;
    //在使用一次titleLabel和imageView后才能正确获取titleSize
    CGSize titleSize = button.titleLabel.bounds.size;
    CGSize imageSize = button.imageView.bounds.size;
    CGFloat interval = 1.0;
    
    button.imageEdgeInsets = UIEdgeInsetsMake(0,titleSize.width + interval, 0, -(titleSize.width + interval));
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageSize.width + interval), 0, imageSize.width + interval);
}

+ (void)setImageUpDownTitle:(UIButton *)button{
    button.titleLabel.backgroundColor = button.backgroundColor;
    button.imageView.backgroundColor = button.backgroundColor;
    
    CGSize titleSize = button.titleLabel.bounds.size;
    CGSize imageSize = button.imageView.bounds.size;
    CGFloat interval = 1.0;
    
    [button setImageEdgeInsets:UIEdgeInsetsMake(0,0, titleSize.height + interval, -(titleSize.width + interval))];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(imageSize.height + interval, -(imageSize.width + interval), 0, 0)];
}
@end
