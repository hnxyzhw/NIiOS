//
//  StudentModel.h
//  NIiOS
//
//  Created by nixs on 2019/3/1.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+ZSModel.h"
#import "AddressModel.h"
#import "CourseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StudentModel : NSObject<ZSModel>
//普通属性
@property(nonatomic,strong) NSString *uid;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,assign) NSInteger age;
//嵌套属性
@property(nonatomic,strong) AddressModel *address;
//嵌套模型数组
@property(nonatomic,strong) NSArray<CourseModel*> *course;

@end

NS_ASSUME_NONNULL_END
