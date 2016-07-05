//
//  SVPHelper.h
//  YZJG
//
//  Created by MK on 5/28/15.
//  Copyright (c) 2015 FQ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SVPShowTypeNone,
    SVPShowTypeInfo,
    SVPShowTypeSuc,
} SVPShowType;

@interface SVPHelper : NSObject

+ (void)showMsg:(NSString *)msg;

+ (void)showMsg:(NSString *)msg type:(SVPShowType)type;

+ (void)showMsg:(NSString *)msg type:(SVPShowType)type interval:(float)interval;

+ (void)dismiss;

@end
