//
//  UIView+XJExtension.h
//  百思不得姐
//
//  Created by JIAAIR on 16/5/18.
//  Copyright © 2016年 徐甲. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (XJExtension)
@property (nonatomic, assign) CGFloat xj_width;
@property (nonatomic, assign) CGFloat xj_height;
@property (nonatomic, assign) CGFloat xj_x;
@property (nonatomic, assign) CGFloat xj_y;
@property (nonatomic, assign) CGFloat xj_centerX;
@property (nonatomic, assign) CGFloat xj_centerY;

@property (nonatomic, assign) CGFloat xj_right;
@property (nonatomic, assign) CGFloat xj_bottom;

+ (instancetype)viewFromXib;

@end
