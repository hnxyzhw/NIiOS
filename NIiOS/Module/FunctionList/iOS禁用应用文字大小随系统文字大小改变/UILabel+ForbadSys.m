//
//  UILabel+ForbadSys.m
//  NIiOS
//
//  Created by nixs on 2018/12/26.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "UILabel+ForbadSys.h"

@implementation UILabel (ForbadSys)
-(instancetype)init{
    if (self = [super init]) {
        self.font =[UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        self.adjustsFontForContentSizeCategory = NO;
        self.font = [UIFont systemFontOfSize:18];
    }
    return self;
}

-(UIFont *)font{
    UIFont* f = [UIFont systemFontOfSize:18];
    return f;
}

@end
