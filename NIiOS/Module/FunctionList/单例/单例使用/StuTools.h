//
//  StuTools.h
//  NIiOS
//
//  Created by ai-nixs on 2018/12/6.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StuModel.h"

@interface StuTools : NSObject
@property (nonatomic,strong) StuModel *stuModel;

/**
 初始化
 */
+(instancetype)sharedInstance;

/**
 清理单例
 */
+(void)clean;

@end
