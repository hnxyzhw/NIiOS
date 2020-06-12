//
//  YSCOperation.m
//  NIiOS
//
//  Created by nixs on 2019/2/11.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "YSCOperation.h"

@implementation YSCOperation
-(void)main{
    if (!self.isCancelled) {
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@", [NSThread currentThread]);
        }
    }
}
@end
