//
//  Programmer.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/21.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "Programmer.h"
#import "Program.h"

@interface Programmer()<Program>
//继承的协议方法自动私有,无须声明接口
@end

//需要自行实现协议方法
@implementation Programmer
-(void)program{
    NILog(@"===I'm writing bugs.===");
}
-(void)draw{
    NILog(@"===I can draw.===");
}
-(void)sing{
    NILog(@"===I can sing.===");
}
@end
