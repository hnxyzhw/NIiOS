//
//  NSObject+ZSModel.h
//  NIiOS
//
//  Created by nixs on 2019/2/28.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 创建NSObject的类目NSObject+ZSModel，用于实现字典转模型
 */
@interface NSObject (ZSModel)
+(instancetype)zs_modelWithDictionary:(NSDictionary*)dictionary;
@end

//ZSModel协议，协议方法可以返回一个字典，表明特殊字段的处理规则
@protocol ZSModel <NSObject>
@optional
+(nullable NSDictionary<NSString*,id>*)modelContainerPropertyGenericClass;

@end

NS_ASSUME_NONNULL_END
