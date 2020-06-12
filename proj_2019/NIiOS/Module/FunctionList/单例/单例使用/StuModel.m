//
//  StuModel.m
//  NIiOS
//
//  Created by ai-nixs on 2018/12/6.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "StuModel.h"

@implementation StuModel

-(instancetype)initWithName:(NSString*)name andSex:(NSString*)sex andAge:(NSInteger)age andNo:(NSString*)no{
    if (self = [super init]) {
        _name = name;
        _sex = sex;
        _age = age;
        _no = no;
    }
    return self;
}
@end
