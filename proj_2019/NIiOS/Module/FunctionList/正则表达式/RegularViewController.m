//
//  RegularViewController.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/29.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "RegularViewController.h"

@interface RegularViewController ()

@end

@implementation RegularViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"正则表达式使用";
    NSString* str1 = @"123a";
    NSLog(@"===str1:%d===",[self isNumText:str1]);
    
    NSString* str2 = @"1234";
    NSLog(@"===str2:%d===",[self isNumText:str2]);
    
}

//是否是纯数字
- (BOOL)isNumText:(NSString *)str{
    BOOL result = NO;
    if ([[self trimming:str] stringByTrimmingCharactersInSet: [NSCharacterSet decimalDigitCharacterSet]].length>0) {
        NSLog(@"不是纯数字");
        result = NO;
    }else{
        NSLog(@"纯数字！");
        result = YES;
    }
    return result;
}
- (NSString *)trimming:(NSString*)str {
    return [str stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
}
@end
