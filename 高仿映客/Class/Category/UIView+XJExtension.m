//
//  UIView+XJExtension.m
//  百思不得姐
//
//  Created by JIAAIR on 16/5/18.
//  Copyright © 2016年 徐甲. All rights reserved.
//

#import "UIView+XJExtension.h"

@implementation UIView (XJExtension)
- (CGFloat)xj_width {
    return self.frame.size.width;
}

- (CGFloat)xj_height {
    return self.frame.size.height;
}

- (void)setXj_width:(CGFloat)xj_width {
    CGRect frame = self.frame;
    frame.size.width = xj_width;
    self.frame = frame;
}

- (void)setXj_height:(CGFloat)xj_height {
    CGRect frame = self.frame;
    frame.size.height = xj_height;
    self.frame = frame;
}

- (CGFloat)xj_x {
    return self.frame.origin.x;
}

- (CGFloat)xj_y {
    return self.frame.origin.y;
}

- (void)setXj_x:(CGFloat)xj_x {
    CGRect frame = self.frame;
    frame.origin.x = xj_x;
    self.frame = frame;
}

- (void)setXj_y:(CGFloat)xj_y {
    CGRect frame = self.frame;
    frame.origin.y = xj_y;
    self.frame = frame;
}

- (CGFloat)xj_centerX {
    return self.center.x;
}

- (CGFloat)xj_centerY {
    return self.center.y;
}

- (void)setXj_centerX:(CGFloat)xj_centerX {
    CGPoint center = self.center;
    center.x = xj_centerX;
    self.center = center;
}

- (void)setXj_centerY:(CGFloat)xj_centerY {
    CGPoint center = self.center;
    center.y = xj_centerY;
    self.center = center;
}

- (CGFloat)xj_right {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)xj_bottom {
    return CGRectGetMaxY(self.frame);
}

- (void)setXj_right:(CGFloat)xj_right {
    self.xj_x = xj_right - self.xj_width;
}

- (void)setXj_bottom:(CGFloat)xj_bottom {
    self.xj_y = xj_bottom - self.xj_height;
}

+ (instancetype)viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}
@end
