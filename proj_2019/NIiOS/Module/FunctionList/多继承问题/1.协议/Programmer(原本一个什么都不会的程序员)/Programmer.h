//
//  Programmer.h
//  NIiOS
//
//  Created by ai-nixs on 2018/11/21.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Draw.h"
#import "Sing.h"
//Programmer-原本一个什么都不会的程序员
//学会了多个技能

@interface Programmer : NSObject<Draw,Sing>
//继承的协议方法自动公有,无须声明接口

@end
