
//
//  CollectionReusableView.m
//  NIiOS
//
//  Created by nixs on 2019/2/13.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "CollectionReusableView.h"

@implementation CollectionReusableView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        //1.初始化imageView、label(一定记住如下取自定义Cell宽、高方式)
        CGFloat cellWidth = self.bounds.size.width;
        CGFloat cellHeight = self.bounds.size.height;
        //2.左边自定义view标签位置
        self.viewLeft = [[UIView alloc] initWithFrame:CGRectMake(10, cellHeight*1/5, 3, cellHeight*3/5)];
        self.viewLeft.backgroundColor = [UIColor greenColor];
        //3.labSectionHeader位置
        self.labSectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(10+3+10, 0, cellWidth-10-3-10, cellHeight)];
        //4.把自定义view 、lab添加到self上
        [self addSubview:self.viewLeft];
        [self addSubview:self.labSectionHeader];
    }
    return self;
}


@end
