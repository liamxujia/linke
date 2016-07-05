//
//  SVPHelper.m
//  YZJG
//
//  Created by MK on 5/28/15.
//  Copyright (c) 2015 FQ. All rights reserved.
//

#import "SVPHelper.h"
#import "SVProgressHUD.h"

@implementation SVPHelper {
}

+ (void)load
{
    [SVProgressHUD setCornerRadius:2.0f];
    const float c = 0.32f;
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:c green:c blue:c alpha:0.88f]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setErrorImage:nil];
    [SVProgressHUD setInfoImage:nil];
    [SVProgressHUD setSuccessImage:nil];
}

+ (void)showMsg:(NSString *)msg
{
    [self showMsg:msg type:SVPShowTypeNone];
}

+ (void)showMsg:(NSString *)msg type:(SVPShowType)type
{
    [self showMsg:msg type:type interval:-1.f];
}

+ (void)showMsg:(NSString *)msg type:(SVPShowType)type interval:(float)interval
{
    UIImage *infoImg = nil;
    UIImage *sucImg = nil;
    switch (type) {
        case SVPShowTypeInfo:
            infoImg = [UIImage imageNamed:@"svp_img_info"];
            break;
        case SVPShowTypeSuc:
            sucImg = [UIImage imageNamed:@"svp_img_suc"];
            break;
        default:
            break;
    }

    [SVProgressHUD setInfoImage:infoImg];
    [SVProgressHUD setSuccessImage:sucImg];

    dispatch_async(dispatch_get_main_queue(), ^{
        if (type == SVPShowTypeInfo) {
            [SVProgressHUD showInfoWithStatus:msg];
        } else {
            [SVProgressHUD showSuccessWithStatus:msg];
        }
        if (interval > FLT_EPSILON) {
            static uint32_t _count = 0;

            ++_count;
            uint32_t idx = _count;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                               if (idx == _count) {
                                   [SVProgressHUD dismiss];
                               }
                           });
        }
    });
}

+ (void)dismiss
{
    [SVProgressHUD dismiss];
}

@end
