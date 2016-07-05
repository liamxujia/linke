//
//  MineHeadView.m
//  高仿映客
//
//  Created by JIAAIR on 16/7/3.
//  Copyright © 2016年 JIAAIR. All rights reserved.
//

#import "MineHeadView.h"

@interface MineHeadView()
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

@end
@implementation MineHeadView

+ (instancetype)mineHeadView {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
    
}

- (void)awakeFromNib {
    
    //给按钮加一个白色的边框
    _iconBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    _iconBtn.layer.borderWidth = 2.0f;
    
    //给按钮设置弧度
    _iconBtn.layer.cornerRadius = _iconBtn.frame.size.width * 0.5;
    _iconBtn.layer.masksToBounds = YES;
}




@end
