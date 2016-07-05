//
//  UIBarButtonItem+Item.m
//  BuDeJie
//
//  Created by 1 on 16/5/29.
//  Copyright © 2016年 小码哥. All rights reserved.
//

#import "UIBarButtonItem+Item.h"
// 把按钮包装成UIBarButtonItem,系统会把点击范围扩大

@implementation UIBarButtonItem (Item)
+ (instancetype)itemWithImage:(UIImage *)image highImage:(UIImage *)highImage target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:highImage forState:UIControlStateHighlighted];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];
    [containView addSubview:btn];
    
    return  [[UIBarButtonItem alloc] initWithCustomView:containView];
}

+ (instancetype)itemWithImage:(UIImage *)image selImage:(UIImage *)selImage target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selImage forState:UIControlStateSelected];
    [btn sizeToFit];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIView *containView = [[UIView alloc] initWithFrame:btn.bounds];
    [containView addSubview:btn];
    
    return  [[UIBarButtonItem alloc] initWithCustomView:containView];
}
@end
