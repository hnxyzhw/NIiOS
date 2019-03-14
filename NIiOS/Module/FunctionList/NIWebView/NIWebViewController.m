//
//  NIWebViewController.m
//  NIiOS
//
//  Created by ai-nixs on 2018/12/3.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "NIWebViewController.h"

@implementation NIWebViewController
- (instancetype)init {
    if (self = [super init]) {
        self.allowsBFNavigationGesture = YES;
        self.progressTintColor = [UIColor blackColor];
    }
    return self;
}


@end
