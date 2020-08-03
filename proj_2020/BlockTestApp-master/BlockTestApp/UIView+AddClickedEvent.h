//
//  UIView+AddClickedEvent.h
//  BlockTestApp
//
//  Created by ai-nixs on 2020/8/3.
//  Copyright © 2020 cimain. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (AddClickedEvent)
//属性
@property(nonatomic,copy) void(^clickedAction)(id obj);
//方法
-(void)addClickedBlock:(void(^)(id obj))clickedAction;

@end

NS_ASSUME_NONNULL_END
