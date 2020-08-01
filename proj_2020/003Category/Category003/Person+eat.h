//
//  Person+eat.h
//  Category003
//
//  Created by ai-nixs on 2020/7/31.
//  Copyright © 2020 nixs. All rights reserved.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

/// Category
@interface Person (eat)
@property(nonatomic,strong) NSString *name;

/// 可以添加方法,如果原类里有相同方法名称，这里会覆盖原类方法
-(void)NI_eat;


@end

NS_ASSUME_NONNULL_END
