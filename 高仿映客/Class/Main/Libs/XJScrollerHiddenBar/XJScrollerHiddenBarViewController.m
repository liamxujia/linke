//
//  XJScrollerHiddenBarViewController.m
//  ScrollingHiddenBarDemo
//
//  Created by JIAAIR on 16/7/2.
//  Copyright © 2016年 JIAAIR. All rights reserved.
//

#import "XJScrollerHiddenBarViewController.h"

#define UIScreen_Height [UIScreen mainScreen].bounds.size.height
#define TabBar_Height self.tabBarController.tabBar.frame.size.height
@interface XJScrollerHiddenBarViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, weak)	UIView* scrollableView;
@property (assign, nonatomic) float lastContentOffset;
@property (strong, nonatomic) UIPanGestureRecognizer* panGesture;
@property (strong, nonatomic) UIView* overlay;
@property (assign, nonatomic) BOOL isCollapsed;
@property (assign, nonatomic) BOOL isExpanded;
@property (strong, nonatomic) UIImageView *navBarHairlineImageView;;

@end

@implementation XJScrollerHiddenBarViewController

#pragma mark ---- <hidden tabbar bottom line>
- (void)viewDidLoad {
    _navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _navBarHairlineImageView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _navBarHairlineImageView.hidden = NO;
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)followScrollView:(UIView*)scrollableView
{
    self.scrollableView = scrollableView;
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.panGesture setMaximumNumberOfTouches:1];
    
    [self.panGesture setDelegate:self];
    [self.scrollableView addGestureRecognizer:self.panGesture];
    
    /* The navbar fadeout is achieved using an overlay view with the same barTintColor.
     this might be improved by adjusting the alpha component of every navbar child */
    CGRect frame = self.navigationController.navigationBar.frame;
    frame.origin = CGPointZero;
    self.overlay = [[UIView alloc] initWithFrame:frame];
    if (!self.navigationController.navigationBar.barTintColor) {
//        NSLog(@"[%s]: %@", __func__, @"Warning: no bar tint color set");
    }
    [self.overlay setBackgroundColor:self.navigationController.navigationBar.barTintColor];
    [self.overlay setUserInteractionEnabled:NO];
    [self.navigationController.navigationBar addSubview:self.overlay];
    [self.overlay setAlpha:0];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handlePan:(UIPanGestureRecognizer*)gesture
{
    CGPoint translation = [gesture translationInView:[self.scrollableView superview]];
    
    float delta = self.lastContentOffset - translation.y;
    self.lastContentOffset = translation.y;
    
    CGRect nframe;
    
    
#pragma mark ---- <手指向上滑动时调用>
    
    if (delta > 0) {
        if (self.isCollapsed) {
            return;
        }
        nframe = self.navigationController.navigationBar.frame;

        if (nframe.origin.y - delta < - (44 + 1)) {
            delta = nframe.origin.y + (44 + 1);
        }
        
        nframe.origin.y = MAX(-(44 + 1), nframe.origin.y - delta);
        self.navigationController.navigationBar.frame = nframe;
        
        if (nframe.origin.y == -(44 + 1)) {
            self.isCollapsed = YES;
            self.isExpanded = NO;
        }
        
        [self updateSizingWithDelta:delta];
    }
    
#pragma mark ---- <手指向下滑动时调用>
    
    if (delta < 0) {
        if (self.isExpanded) {
            return;
        }
        
        nframe = self.navigationController.navigationBar.frame;
        
        if (nframe.origin.y - delta > 20) {
            delta = nframe.origin.y - 20;
        }
        nframe.origin.y = MIN(20, nframe.origin.y - delta);
        self.navigationController.navigationBar.frame = nframe;
        
        if (nframe.origin.y == 20) {
            self.isExpanded = YES;
            self.isCollapsed = NO;
        }
        
        [self updateSizingWithDelta:delta];
    }
    
    if ([gesture state] == UIGestureRecognizerStateEnded) {
        // Reset the nav bar if the scroll is partial
        self.lastContentOffset = 0;
        [self checkForPartialScroll];
    }
}

- (void)checkForPartialScroll
{
    CGFloat npos = self.navigationController.navigationBar.frame.origin.y;
    
    // Get back down
    if (npos >= -2) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect nframe;
            //停止后顶部间距设置
            nframe = self.navigationController.navigationBar.frame;
            CGFloat delta = nframe.origin.y - 20;
            nframe.origin.y = MIN(20, nframe.origin.y - delta);
            self.navigationController.navigationBar.frame = nframe;
            
            self.isExpanded = YES;
            self.isCollapsed = NO;
            
            [self updateSizingWithDelta:delta];
   
        }];
    } else {
        // And back up
        [UIView animateWithDuration:0.2 animations:^{
            CGRect nframe;
            nframe = self.navigationController.navigationBar.frame;
            CGFloat delta = nframe.origin.y + (44 + 1);
            nframe.origin.y = MAX(-(44 + 1), nframe.origin.y - delta);
            self.navigationController.navigationBar.frame = nframe;
            
            self.isExpanded = NO;
            self.isCollapsed = YES;
            
            [self updateSizingWithDelta:delta];
        }];
    }
    
}

- (void)updateSizingWithDelta:(CGFloat)delta
{
    CGRect nframe = self.navigationController.navigationBar.frame;
    
    nframe = self.scrollableView.superview.frame;
    nframe.origin.y = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    nframe.size.height = nframe.size.height + delta;
    self.scrollableView.superview.frame = nframe;
    
    // Changing the layer's frame avoids UIWebView's glitchiness
    nframe = self.scrollableView.layer.frame;
    nframe.size.height += delta;
    self.scrollableView.layer.frame = nframe;
    
}

@end
