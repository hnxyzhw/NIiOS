//
//  Person.m
//  Category003
//
//  Created by ai-nixs on 2020/7/31.
//  Copyright © 2020 nixs. All rights reserved.
//

#import "Person.h"

@implementation Person
/// 方法实现
-(void)eat{
    NSLog(@"原类里的 eat方法.");
}

-(void)playWithAddress:(NSString*)address{
    NSLog(@"I want to play the game,Let's go! -Address: %@",address);
}
@end
