//
//  SimpleModel.m
//  NIiOS
//
//  Created by nixs on 2019/2/13.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "SimpleModel.h"

@implementation SimpleModel
-(instancetype)init{
    if (self=[super init]) {
        NSMutableArray* section1 = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",nil];
        NSMutableArray* section2 = [NSMutableArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F",nil];
        NSMutableArray* section3 = [NSMutableArray arrayWithObjects:@"0-1",@"1-1",@"2-1",@"3-1",@"4-1",@"5-1",nil];
        _model = [NSMutableArray arrayWithObjects:section1,section2,section3,nil];
    }
    return self;
}
@end
