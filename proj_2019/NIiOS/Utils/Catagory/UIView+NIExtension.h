//
//  UIView+NIExtension.h
//  NIiOS
//
//  Created by ai-nixs on 2018/11/17.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (NIExtension)

/**
 < Shortcut for frame.origin.x. by:nixs
 */
@property (nonatomic) CGFloat ni_x;

/**
 < Shortcut for frame.origin.y by:nixs
 */
@property (nonatomic) CGFloat ni_y;

/**
 < Shortcut for frame.origin.x + frame.size.width by:nixs
 */
@property (nonatomic) CGFloat ni_right;

/**
 < Shortcut for frame.origin.y + frame.size.height by:nixs
 */
@property (nonatomic) CGFloat ni_bottom;

/**
 < Shortcut for frame.size.width. by:nixs
 */
@property (nonatomic) CGFloat ni_width;
/**
 < Shortcut for frame.size.height. by:nixs
 */
@property (nonatomic) CGFloat ni_height;

/**
 < Shortcut for center.x by:nixs
 */
@property (nonatomic) CGFloat ni_centerX;

/**
 < Shortcut for center.y by:nixs
 */
@property (nonatomic) CGFloat ni_centerY;

/**
 < Shortcut for frame.origin. by:nixs
 */
@property (nonatomic) CGPoint ni_origin;

/**
 < Shortcut for frame.size. by:nixs
 */
@property (nonatomic) CGSize  ni_size;        
@end
