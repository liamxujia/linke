//
//  XJScrollerHiddenBarViewController.h
//  ScrollingHiddenBarDemo
//
//  Created by JIAAIR on 16/7/2.
//  Copyright © 2016年 JIAAIR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJScrollerHiddenBarViewController : UIViewController

/**-----------------------------------------------------------------------------
 * From AMScrollingNavbarViewController
 * -----------------------------------------------------------------------------
 */

/** Scrolling init method
 *
 * Enables the scrolling on a generic UIView.
 *
 * @param scrollableView The UIView where the scrolling is performed.
 * 
 * 根据AMScrollingNavbarViewController框架修改了部分效果，比如完全隐藏tabbar， 
 * 取消渐变透明效果，添加了隐藏navigationtabBar, 底侧1px的横线
 * 如果想实现原版AMScrolling，请直接下载AMScrollingNavbar
 */
- (void)followScrollView:(UIView*)scrollableView;

/**
 * 使用方法：1.在navigation跟控制器继承XJScrollerHiddenBarViewController
 *         2.在viewDid中添加[self followScrollView:self.collectionView / tableView]
 */
@end
