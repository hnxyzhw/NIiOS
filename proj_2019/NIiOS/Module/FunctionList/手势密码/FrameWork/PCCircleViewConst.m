//
//  PCCircleViewConst.m
//  NIiOS
//
//  Created by nixs on 2018/12/12.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "PCCircleViewConst.h"

@implementation PCCircleViewConst
+ (void)saveGesture:(NSString *)gesture Key:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:gesture forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getGestureWithKey:(NSString *)key
{
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

@end
