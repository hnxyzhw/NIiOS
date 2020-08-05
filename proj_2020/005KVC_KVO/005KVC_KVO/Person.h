//
//  Person.h
//  005KVC_KVO
//
//  Created by nixs on 2020/8/4.
//  Copyright © 2020 nixs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
//{
//    NSString *_name;
//}
//属性
@property(nonatomic,copy) NSString *name;
@property(nonatomic,assign) int age;


@end

NS_ASSUME_NONNULL_END
