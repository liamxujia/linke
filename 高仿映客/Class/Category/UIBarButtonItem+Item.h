//
//  UIBarButtonItem+Item.h
//  BuDeJie
//
//  Created by 1 on 16/5/29.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)

// 高亮
+ (instancetype)itemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action;

// 选中
+ (instancetype)itemWithImage:(UIImage *)image selImage:(UIImage *)selImage target:(id)target action:(SEL)action;

@end
