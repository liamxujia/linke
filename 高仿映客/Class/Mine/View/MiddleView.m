//
//  MiddleView.m
//  高仿映客
//
//  Created by JIAAIR on 16/7/3.
//  Copyright © 2016年 JIAAIR. All rights reserved.
//

#import "MiddleView.h"

@implementation MiddleView

+ (instancetype)middleView {
      return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

@end
