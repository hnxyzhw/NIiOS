//
//  main.m
//  Category003
//
//  Created by ai-nixs on 2020/7/31.
//  Copyright © 2020 nixs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person+eat.h"
#import "Person+Stu.h"
#import "B.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        Person *person = [Person new];
        person.name = @"加菲猫";
        
        NSLog(@"person.name=%@",person.name);
        [person eat];
        [person NI_eat];
        //person.address = @"北京-丰台";//错误写法
        //[person playWithAddress:person.address];
        
        //字符串操作
        NSMutableString* mulStr = [[NSMutableString alloc] initWithString:@"hello-"];
        NSLog(@"%@",mulStr);
        [mulStr insertString:@"nice day." atIndex:6];
        NSLog(@"%@",mulStr);
        NSString *str = [mulStr capitalizedString];
        NSLog(@"%@",str);
        NSString *str2 = [str stringByAppendingString:@"-倪新生"];
        NSArray *array = [str2 componentsSeparatedByString:@"-"];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"[index,value]=[%lu,%@]",(unsigned long)idx,obj);
        }];
        
        //iOS开发·NSDate日期基本操作方法
        [[B new] sayHello];
        NSLog(@"calculateResult:%lf",[[B new] calculateResult]);
        
        
    }
    return 0;
}
