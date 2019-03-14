//
//  AdImageUrlsModel.h
//  NIiOS
//
//  Created by nixs on 2019/3/12.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdImageUrlsModel : NSObject

/**
 存储-启动广告可以从服务器端动态获取(n天变更一次就行)
 */
@property(nonatomic,strong) NSArray <NSString *> *imagesURLS;

@end

NS_ASSUME_NONNULL_END
