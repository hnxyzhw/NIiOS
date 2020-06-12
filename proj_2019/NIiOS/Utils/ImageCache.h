//
//  ImageCache.h
//  NIiOS
//
//  Created by nixs on 2019/1/14.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageCache : NSObject
+ (instancetype)shareInstance;
- (id)getCacheImage: (NSString *)key;
- (id)getCacheYYImage: (NSString *)key;
@end

NS_ASSUME_NONNULL_END
