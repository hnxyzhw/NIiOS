//
//  Person.m
//  runtime002
//
//  Created by nixs on 2020/7/15.
//  Copyright © 2020 nixs. All rights reserved.
//

#import "Person.h"

@implementation Person
+(void)getPersonInfo{
    NSLog(@"get Person <Info>");
}
-(void)getPersonName{
    NSLog(@"get Person <NAME>");
}

-(NSString *)description{
    NSLog(@"---重新实现");
    return @"重新实现打印内容";
}
@end
