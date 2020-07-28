//
//  Person.h
//  runtime002
//
//  Created by nixs on 2020/7/15.
//  Copyright © 2020 nixs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
@property(nonatomic,strong) NSString *pid;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *sex;
@property(nonatomic,assign) int age;
+(void)getPersonInfo;
-(void)getPersonName;

@end

NS_ASSUME_NONNULL_END
