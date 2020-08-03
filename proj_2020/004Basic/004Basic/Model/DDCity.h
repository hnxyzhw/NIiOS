//
//  DDCity.h
//  004Basic
//
//  Created by ai-nixs on 2020/8/3.
//  Copyright © 2020 nixs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDCity : NSObject<NSCopying, NSMutableCopying>
/// 属性
@property (nonatomic,copy) NSString * cityName;
@property (nonatomic,copy) NSString * cityLocation;

@end

NS_ASSUME_NONNULL_END
