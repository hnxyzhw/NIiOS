//
//  CollectionViewCell.m
//  NIiOS
//
//  Created by nixs on 2019/2/13.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        //1.初始化imageView、label(一定记住如下取自定义Cell宽、高方式)
        CGFloat cellWidth = self.bounds.size.width;
        CGFloat cellHeight = self.bounds.size.height;
        
        self.imageViewHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight*4/5)];
        self.imageViewHeader.contentMode = UIViewContentModeScaleAspectFit;
        NIViewBorderRadius(self.imageViewHeader, 1.0, RGBACOLOR(216, 61, 52, 1).CGColor)
        self.labDes = [[UILabel alloc] initWithFrame:CGRectMake(0, cellHeight*4/5, cellWidth, cellHeight*1/5)];
        self.labDes.textAlignment = NSTextAlignmentCenter;
        self.labDes.backgroundColor = RGBACOLOR(35, 47, 60, 0.3);
        
        //Add by:nixs 2019年02月19日09:40:03 item最上层覆盖全部的btn用来响应点击事件
        self.btnItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
        self.backgroundColor = [UIColor clearColor];
        [self.btnItem addTarget:self action:@selector(btnItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        //2.添加imageView、label到cell上
        [self.contentView addSubview:self.imageViewHeader];
        [self.contentView addSubview:self.labDes];
        [self.contentView addSubview:self.btnItem];
    }
    return self;
}

/**
 btnItem按钮的响应事件
 */
-(void)btnItemClicked:(UIButton*)btn{
    if (self.itemClickedBlock) {
        self.itemClickedBlock(self.indexPath);
    }
}
@end
