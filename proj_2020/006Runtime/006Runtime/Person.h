//
//  Person.h
//  006Runtime
//
//  Created by nixs on 2020/8/5.
//  Copyright © 2020 nixs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
@property(nonatomic,assign) int age;
+(void)run;
+(void)study;
- (NSArray *)ignoredNames;
- (instancetype)initWithCoder:(NSCoder *)aDecoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end

NS_ASSUME_NONNULL_END
