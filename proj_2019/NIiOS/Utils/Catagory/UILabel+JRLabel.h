//
//  UILabel+JRLabel.h
//  Pos
//
//  Created by 艾小新 on 2018/5/7.
//  Copyright © 2018年 Shy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (JRLabel)



/**
 无更多数据加载

 @param view label
 @return label
 */
+ (UILabel *)noMoreLabelInView:(UIView*)view;


/**
 UILabel初始化

 @param fontSize 字体
 @param title 名称
 @param color 颜色
 @param alignment 对齐
 @return Label
 */
+ (UILabel *)labelWithFontSize:(CGFloat)fontSize title:(NSString *)title textColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment;

/**
 第一个金钱字符小写

 @param font Label
 */
- (void)smallFirstLabelFont:(int)font;


- (void)changeNum:(NSString *)numString WithColor:(UIColor *)color;


@end
