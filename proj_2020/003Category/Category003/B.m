//
//  B.m
//  Category003
//
//  Created by ai-nixs on 2020/8/1.
//  Copyright © 2020 nixs. All rights reserved.
//

#import "B.h"
#import "A.h"


@implementation B
-(void)sayHello{
    //extern NSString *const bilibiliStr;
    //NSLog(@"在B类中打印A类里声明的全局变量(本B类里上面有extern声明) bilibiliStr = %@",bilibiliStr);
    NSLog(@"在B类中打印A类里声明的全局变量(本B类里不需要声明，只需要导入A.h即可) APP_LOGIN = %@",APP_LOGIN);
    static float lastNum;
    static float lastNum_2 = 10.0;
    NSLog(@"%lf,%lf",lastNum,lastNum_2);
}
-(float)calculateResult{
    float a = 10.9;
    float b = 20.8;
    return a+b;
}
@end
