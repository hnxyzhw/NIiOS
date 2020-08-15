//
//  UIView+Frame.h
//  004Basic
//
//  Created by ai-nixs on 2020/8/2.
//  Copyright © 2020 nixs. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Frame)
/** 坐标 origin */
@property (nonatomic, assign) CGPoint origin;
/** 坐标 size */
@property (nonatomic, assign) CGSize size;

/** 坐标 width */
@property (nonatomic, assign) CGFloat width;
/** 坐标 height */
@property (nonatomic, assign) CGFloat height;

/** 坐标 x */
@property (nonatomic, assign) CGFloat x;
/** 坐标 y */
@property (nonatomic, assign) CGFloat y;
/** 坐标 maxX */
@property (nonatomic, assign) CGFloat maxX;
/** 坐标 maxY */
@property (nonatomic, assign) CGFloat maxY;
/** 坐标 centerX */
@property (nonatomic, assign) CGFloat centerX;
/** 坐标 centerY */
@property (nonatomic, assign) CGFloat centerY;

@end

NS_ASSUME_NONNULL_END
