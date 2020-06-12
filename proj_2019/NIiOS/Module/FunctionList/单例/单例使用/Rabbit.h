//
//  Rabbit.h
//  NIiOS
//
//  Created by ai-nixs on 2018/12/7.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Rabbit : NSObject
/**
 兔子的名字
 */
@property (nonatomic,strong) NSString *nameOfRabbit;
singleton_interface(Rabbit)

@end
