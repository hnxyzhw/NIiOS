//
//  NSObject+ThreegModel.h
//  runtime002
//
//  Created by ai-nixs on 2020/7/20.
//  Copyright © 2020 nixs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ThreegModel)
+(instancetype)GG_initWithDictionaryForModel:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
