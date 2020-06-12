//
//  UIView+NIExtension.m
//  NIiOS
//
//  Created by ai-nixs on 2018/11/17.
//  Copyright © 2018年 nixinsheng. All rights reserved.
//

#import "UIView+NIExtension.h"

@implementation UIView (NIExtension)

- (CGFloat)ni_x {
    return self.frame.origin.x;
}

- (void)setNi_x:(CGFloat)ni_x {
    CGRect frame = self.frame;
    frame.origin.x = ni_x;
    self.frame = frame;
}

- (CGFloat)ni_y {
    return self.frame.origin.y;
}

- (void)setNi_y:(CGFloat)ni_y {
    CGRect frame = self.frame;
    frame.origin.y = ni_y;
    self.frame = frame;
}

- (CGFloat)ni_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setNi_right:(CGFloat)ni_right {
    CGRect frame = self.frame;
    frame.origin.x = ni_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)ni_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setNi_bottom:(CGFloat)ni_bottom {
    
    CGRect frame = self.frame;
    
    frame.origin.y = ni_bottom - frame.size.height;
    
    self.frame = frame;
}

- (CGFloat)ni_width {
    return self.frame.size.width;
}

- (void)setNi_width:(CGFloat)ni_width {
    CGRect frame = self.frame;
    frame.size.width = ni_width;
    self.frame = frame;
}

- (CGFloat)ni_height {
    return self.frame.size.height;
}

- (void)setNi_height:(CGFloat)ni_height {
    CGRect frame = self.frame;
    frame.size.height = ni_height;
    self.frame = frame;
}

- (CGFloat)ni_centerX {
    return self.center.x;
}

- (void)setNi_centerX:(CGFloat)ni_centerX {
    self.center = CGPointMake(ni_centerX, self.center.y);
}

- (CGFloat)ni_centerY {
    return self.center.y;
}

- (void)setNi_centerY:(CGFloat)ni_centerY {
    self.center = CGPointMake(self.center.x, ni_centerY);
}

- (CGPoint)ni_origin {
    return self.frame.origin;
}

- (void)setNi_origin:(CGPoint)ni_origin {
    CGRect frame = self.frame;
    frame.origin = ni_origin;
    self.frame = frame;
}

- (CGSize)ni_size {
    return self.frame.size;
}

- (void)setNi_size:(CGSize)ni_size {
    CGRect frame = self.frame;
    frame.size = ni_size;
    self.frame = frame;
}

@end
