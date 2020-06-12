//
//  UILabel+JRLabel.m
//  Pos
//
//  Created by 艾小新 on 2018/5/7.
//  Copyright © 2018年 Shy. All rights reserved.
//

#import "UILabel+JRLabel.h"

@implementation UILabel (JRLabel)


+ (UILabel *)noMoreLabelInView:(UIView *)view {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"暂无数据";
    label.textColor = [UIColor darkGrayColor];
    [label sizeToFit];
    [view addSubview:label];
    [label makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
    }];    
    label.hidden = YES;
    return label;
}

+ (UILabel *)labelWithFontSize:(CGFloat)fontSize title:(NSString *)title textColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment {
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.numberOfLines = 1;
    label.text = title;
    label.textAlignment = alignment;
    label.textColor = color;
    [label sizeToFit];
    return label;
}

- (void)smallFirstLabelFont:(int)font {
    //label 需要操作的Label
    //font 该字符的字号
    NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSRange stringRange = NSMakeRange(0, 1);
    //该字符串的位置
    [noteString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:stringRange];
    [self setAttributedText: noteString];
}


- (void)changeNum:(NSString *)numString WithColor:(UIColor *)color {
    
    NSMutableAttributedString *noteString = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSRange stringRange = NSMakeRange([[noteString string] rangeOfString:numString].location, [[noteString string] rangeOfString:numString].length);
    [noteString addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:stringRange];
    [self setAttributedText:noteString];
}

@end
