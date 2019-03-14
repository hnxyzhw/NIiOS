//
//  HomeDataSupport.m
//  CBDemo
//
//  Created by nixs on 2019/1/15.
//  Copyright © 2019年 Lin Youwei. All rights reserved.
//

#import "HomeDataSupport.h"
#import "HomeModel.h"

@implementation HomeDataSupport

-(NSMutableArray*)getDataSourceWithFileName:(NSString*)fileName{
    NSMutableArray* mulArray = [NSMutableArray array];
    NSArray* array = (NSArray*)[NSObject NIDataFromJsonFileName:fileName andDataType:jsonArray];
    for (int i=0; i<array.count; i++) {
        HomeModel* homeModel = [HomeModel modelWithDictionary:array[i]];
        for (int j=0;j<homeModel.body.count; j++) {
            ItemModel* itemModel = [ItemModel new];
            //itemModel.imageNameItem = @"加菲猫2";
            //iOS中 三种随机数方法详解 https://www.cnblogs.com/xiaohuzi1990/p/4387040.html?utm_source=tuicool&utm_medium=referral
            itemModel.imageNameItem = [NSString stringWithFormat:@"%d.jpg",[self getRandomNumber:0 to:5]];
            itemModel.titleItem = @"知识点总结";
            
            NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
            [dataFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            itemModel.timeItem = [dataFormatter stringFromDate:[NSDate date]];
            itemModel.contentItem = homeModel.body[j];
            
            itemModel.textHeight = [self countTextHeight:homeModel.body[j]];
            itemModel.cellHeight = itemModel.textHeight+ 55;
            
            NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:homeModel.body[j]];
            text.font = [UIFont systemFontOfSize:14.0];
            text.lineSpacing = 3;
            itemModel.attributeContent = text;
            
            itemModel.attributeTitle = [[NSAttributedString alloc] initWithString:itemModel.titleItem];
            itemModel.attributeTime = [[NSAttributedString alloc] initWithString:itemModel.timeItem];
            [homeModel.item addObject:itemModel];
        }
        [mulArray addObject:homeModel];
    }    
    return mulArray;
}
//获取一个随机整数，范围在[from,to），包括from，不包括to
-(int)getRandomNumber:(int)from to:(int)to{
    return (int)(from + (arc4random() % (to - from + 1)));
}
-(CGFloat)countTextHeight:(NSString *) text {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 0;
    UIFont *font = [UIFont systemFontOfSize:14];
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(kScreenWidth - 20, CGFLOAT_MAX) options:options context:nil];
    return rect.size.height + 15;
}
@end
