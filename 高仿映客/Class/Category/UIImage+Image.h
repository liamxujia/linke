//
//  UIImage+Image.h
//  BuDeJie
//
//  Created by 1 on 16/5/29.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)

// 加载不要被渲染的图片
+ (UIImage *)imageWithOriginalRenderingMode:(NSString *)imageName;

@end
