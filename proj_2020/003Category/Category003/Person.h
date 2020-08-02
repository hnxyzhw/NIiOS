//
//  Person.h
//  Category003
//
//  Created by ai-nixs on 2020/7/31.
//  Copyright © 2020 nixs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject{
    
}
@property(nonatomic,strong) NSString *sex;
@property(nonatomic,assign) int age;
/// 可以添加方法
-(void)eat;

@end

NS_ASSUME_NONNULL_END
