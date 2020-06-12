//
//  Product.m
//  NIiOS
//
//  Created by nixs on 2019/3/13.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "Product.h"
#import <AVOSCloud/AVOSCloud.h>

@implementation Product
+(instancetype)initWithObject:(NSDictionary*)obj{
    Product* product = [[Product alloc] init];
    product.objectId = [obj objectForKey:@"objectId"];
    AVUser* owner = [obj objectForKey:@"owner"];
    product.name = owner.username;
    AVFile* userAvatar = [owner objectForKey:@"avatar"];
    if (userAvatar) {
        product.avatarUrl = userAvatar.url;
    }
    
    NSDate* createAt = [obj objectForKey:@"createdAt"];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    product.date = [dateFormatter stringFromDate:createAt];
    
    product.price = [NSString stringWithFormat:@"%@",[obj objectForKey:@"price"]];
    product.title = [obj objectForKey:@"title"];
    
    AVFile* file = [obj objectForKey:@"image"];
    product.productImageUrl = file.url;
    
    return product;
}
#pragma mark - 自适应cell高「注意：高度的计算计量放到数据模型里去计算这样的话-性能还是能快一点的」
-(CGFloat)cellHeight{
    //如果cell的高度已经计算过，就直接返回
    if (_cellHeight) {
        return _cellHeight;
    }
    
    //cell高度=187+文字高度
    _cellHeight = 50+10+5+5+kScreenWidth/2.5+5-10;
    if (isFullScreen) {
        _cellHeight = 50+10+5+5+kScreenWidth/2.5+5;
    }
    CGSize labSize = [self getSizeWithStr:self.title Width:kScreenWidth-80 Font:12];
    _cellHeight+=labSize.height;
    return _cellHeight;
}

-(CGSize)getSizeWithStr:(NSString*)str Width:(float)width Font:(float)fontSize{
    NSDictionary* attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize tempSize = [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    return tempSize;
}
@end
