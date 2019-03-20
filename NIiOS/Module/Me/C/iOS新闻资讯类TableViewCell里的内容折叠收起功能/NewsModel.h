//
//  NewsModel.h
//  NIiOS
//
//  Created by nixs on 2019/3/19.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsModel : NSObject

/**
 新闻内容
 */
@property(nonatomic,strong) NSString *desc;

/**
 修改时间
 */
@property(nonatomic,strong) NSString *pubdate;
@property(nonatomic,strong) NSString *imageName;

/**
 是否展开
 */
@property(nonatomic,assign) BOOL isOpening;
@end

NS_ASSUME_NONNULL_END
