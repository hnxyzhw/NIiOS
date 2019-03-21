//
//  BlogModel.m
//  NIiOS
//
//  Created by nixs on 2019/3/21.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "BlogModel.h"

@implementation BlogModel

-(CGFloat)countTextHeight:(NSString *) text {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 0;
    UIFont *font = [UIFont systemFontOfSize:14];
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(kScreenWidth - 30, CGFLOAT_MAX) options:options context:nil];
    return rect.size.height + 40;
}
@end
