//
//  UIView+Frame.m
//  百思不得姐
//
//  Created by JIAAIR on 16/6/6.
//  Copyright © 2016年 JIAAIR. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

//宽度
- (CGFloat)xj_width {
    return self.frame.size.width;
}

- (void)setXj_width:(CGFloat)xj_width {
    CGRect frame = self.frame;
    frame.size.width = xj_width;
    self.frame = frame;
}

//高度
- (CGFloat)xj_height {
    return self.frame.size.height;
}

- (void)setXj_height:(CGFloat)xj_height {
    CGRect frame = self.frame;
    frame.size.height = xj_height;
    self.frame = frame;
}

//x值
- (CGFloat)xj_x {
    return self.frame.origin.x;
}

- (void)setXj_x:(CGFloat)xj_x {
    CGRect frame = self.frame;
    frame.origin.x = xj_x;
    self.frame = frame;
}

//y值
- (CGFloat)xj_y {
    return self.frame.origin.y;
}

- (void)setXj_y:(CGFloat)xj_y {
    CGRect frame = self.frame;
    frame.origin.y = xj_y;
    self.frame = frame;
}

//centerX
- (CGFloat)xj_centerX {
    return self.center.x;
}

- (void)setXj_centerX:(CGFloat)xj_centerX {
    CGPoint center = self.center;
    center.x = xj_centerX;
    self.center = center;
}

//centerY
- (CGFloat)xj_centerY {
    return self.center.y;
}

- (void)setXj_centerY:(CGFloat)xj_centerY {
    CGPoint center = self.center;
    center.y = xj_centerY;
    self.center = center;
}





@end
