//
//  Product.h
//  NIiOS
//
//  Created by nixs on 2019/3/13.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Product : NSObject
@property (nonatomic,copy) NSString *objectId;
/** 用户名 */
@property (nonatomic,copy) NSString *name;
/** 用户头像 */
@property (nonatomic,copy) NSString * avatarUrl;
/** 商品发布日期 */
@property (nonatomic,copy) NSString *date;
/** 商品价格 */
@property (nonatomic,copy) NSString *price;
/** 商品描述 */
@property (nonatomic,copy) NSString *title;
/** 商品图片 */
@property (nonatomic,copy) NSString *productImageUrl;
/** cell 的高度 */
@property (nonatomic, assign) CGFloat cellHeight;

+(instancetype)initWithObject:(NSDictionary *)obj;

@end

NS_ASSUME_NONNULL_END
