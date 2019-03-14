//
//  SelCollectionViewCell.m
//  NIiOS
//
//  Created by nixs on 2019/2/19.
//  Copyright © 2019年 nixinsheng. All rights reserved.
//

#import "SelCollectionViewCell.h"

@implementation SelCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        //1.初始化imageView、label(一定记住如下取自定义Cell宽、高方式)
        CGFloat cellWidth = self.bounds.size.width;
        CGFloat cellHeight = self.bounds.size.height;
        self.btnItem = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
        [self.btnItem setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.btnItem setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        NIViewSetRadius(self.btnItem, 3)
        UIColor* borderColor = [UIColor grayColor];
        NIViewBorderRadius(self.btnItem, 1, borderColor.CGColor)
        [self.btnItem addTarget:self action:@selector(btnItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btnItem];               
    }
    return self;
}

/**
 btnItem按钮的响应事件
 */
-(void)btnItemClicked:(UIButton*)btn{
    btn.selected = !btn.isSelected;
    if (btn.selected) {
        [btn setBackgroundColor:[UIColor redColor]];        
    }else{
        [btn setBackgroundColor:[UIColor clearColor]];
    }
    if (self.itemClickedBlock) {
        self.itemClickedBlock(self.indexPath,btn.selected,self.itemTitle);
    }
}


@end
