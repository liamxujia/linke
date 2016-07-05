//
//  UIControl+Extension.m
//  高仿映客
//
//  Created by JIAAIR on 16/7/3.
//  Copyright © 2016年 JIAAIR. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)
+ (UIImage *)imageWithOriginalRenderingMode:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}
@end
