//
//  DataSupport.h
//  NIiOS
//
//  Created by nixs on 2019/1/14.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UpdateDataSourceBlock)(NSMutableArray *dataSource);
@interface DataSupport : NSObject
- (void)setUpdataDataSourceBlock:(UpdateDataSourceBlock) updateDataBlock;
- (void)addTestData;
@end

