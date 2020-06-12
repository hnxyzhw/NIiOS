//
//  Programmer2+Program.h
//  NIiOS
//
//  Created by ai-nixs on 2018/11/21.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

//分类头文件
#import "Programmer2.h"

@interface Programmer2 (Program)
/**
 Programmer2+Program 分类里-声明属性
 */
@property(nonatomic,strong)NSString* motto;
//声明公有方法

/**
 Programmer+Program 分类里的draw方法
 */
-(void)draw;
/**
 Programmer+Program 分类里的sing方法
 */
-(void)sing;

@end
