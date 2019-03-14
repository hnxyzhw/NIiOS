//
//  HomeDataSupport.h
//  CBDemo
//
//  Created by nixs on 2019/1/15.
//  Copyright © 2019年 Lin Youwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HomeDataSupport : NSObject
/**
 从文件获取数据源
 
 @param fileName 文件名
 @return NSMutableArray
 */
-(NSMutableArray*)getDataSourceWithFileName:(NSString*)fileName;

@end

