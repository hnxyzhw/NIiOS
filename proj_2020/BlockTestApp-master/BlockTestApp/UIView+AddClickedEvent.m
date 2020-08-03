//
//  UIView+AddClickedEvent.m
//  BlockTestApp
//
//  Created by ai-nixs on 2020/8/3.
//  Copyright © 2020 cimain. All rights reserved.
//

#import "UIView+AddClickedEvent.h"

@implementation UIView (AddClickedEvent)

-(void)addClickedBlock:(void(^)(id obj))clickedAction{
    self.clickedAction = clickedAction;
    // :先判断当前是否有交互事件，如果没有的话。。。所有gesture的交互事件都会被添加进gestureRecognizers中
    if (![self gestureRecognizers]) {
        self.userInteractionEnabled = YES;
        // :添加单击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
}
-(void)tap{
    if (self.clickedAction) {
        self.clickedAction(self);
    }
}

@end
