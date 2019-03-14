//
//  StuModel.h
//  NIiOS
//
//  Created by ai-nixs on 2018/12/6.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StuModel : NSObject

/**
 名称
 */
@property (nonatomic,strong) NSString *name;

/**
 性别
 */
@property (nonatomic,strong) NSString *sex;

/**
 年龄
 */
@property (nonatomic,assign) NSInteger age;

/**
 学号
 */
@property (nonatomic,strong) NSString *no;


-(instancetype)initWithName:(NSString*)name andSex:(NSString*)sex andAge:(NSInteger)age andNo:(NSString*)no;
@end
