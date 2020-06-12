//
//  StudentModel.m
//  NIiOS
//
//  Created by nixs on 2019/3/1.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "StudentModel.h"

@implementation StudentModel
+(NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    //需要特别处理的属性
    return @{@"courses":[CourseModel class],@"uid":@"id"};
}
@end
