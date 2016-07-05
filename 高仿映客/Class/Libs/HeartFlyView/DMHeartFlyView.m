//
//  DMHeartFlyView.m
//  DMHeartFlyAnimation
//
//  Created by Rick on 16/3/9.
//  Copyright © 2016年 Rick. All rights reserved.
//

#define DMRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define DMRGBAColor(r, g, b ,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define DMRandColor DMRGBColor(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))

#import "DMHeartFlyView.h"
//@interface DMHeartTheme ()
//
//@end
//
//@implementation DMHeartTheme
//
//@end

@interface DMHeartFlyView ()
@property(nonatomic,strong) UIColor *strokeColor;
@property(nonatomic,strong) UIColor *fillColor;
@end

@implementation DMHeartFlyView

-(instancetype)initWithFrame:(CGRect)frame{
   self = [super initWithFrame:frame];
    if (self) {
        _strokeColor = [UIColor whiteColor];
        _fillColor = DMRandColor;
        self.backgroundColor = [UIColor clearColor];
        self.layer.anchorPoint = CGPointMake(0.5, 1);
    }
    return self;
}

static CGFloat PI = M_PI;
-(void)animateInView:(UIView *)view{
    NSTimeInterval totalAnimationDuration = 6;
    CGFloat heartSize = CGRectGetWidth(self.bounds);
    CGFloat heartCenterX = self.center.x;
    CGFloat viewHeight = CGRectGetHeight(view.bounds);
    
    //Pre-Animation setup
    self.transform = CGAffineTransformMakeScale(0, 0);
    self.alpha = 0;
    
    //Bloom
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 0.9;
    } completion:NULL];

    NSInteger i = arc4random_uniform(2);
    NSInteger rotationDirection = 1- (2*i);// -1 OR 1
    NSInteger rotationFraction = arc4random_uniform(10);
    [UIView animateWithDuration:totalAnimationDuration animations:^{
        self.transform = CGAffineTransformMakeRotation(rotationDirection * PI/(16 + rotationFraction*0.2));
    } completion:NULL];
    
    UIBezierPath *heartTravelPath = [UIBezierPath bezierPath];
    [heartTravelPath moveToPoint:self.center];
    
    //random end point
    CGPoint endPoint = CGPointMake(heartCenterX + (rotationDirection) * arc4random_uniform(2*heartSize), viewHeight/6.0 + arc4random_uniform(viewHeight/4.0));
    
    //random Control Points
    NSInteger j = arc4random_uniform(2);
    NSInteger travelDirection = 1- (2*j);// -1 OR 1
    
    //randomize x and y for control points
    CGFloat xDelta = (heartSize/2.0 + arc4random_uniform(2*heartSize)) * travelDirection;
    CGFloat yDelta = MAX(endPoint.y ,MAX(arc4random_uniform(8*heartSize), heartSize));
    CGPoint controlPoint1 = CGPointMake(heartCenterX + xDelta, viewHeight - yDelta);
    CGPoint controlPoint2 = CGPointMake(heartCenterX - 2*xDelta, yDelta);
    
    [heartTravelPath addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrameAnimation.path = heartTravelPath.CGPath;
    keyFrameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    keyFrameAnimation.duration = totalAnimationDuration + endPoint.y/viewHeight;
    [self.layer addAnimation:keyFrameAnimation forKey:@"positionOnPath"];
    
    //Alpha & remove from superview
    [UIView animateWithDuration:totalAnimationDuration animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}


-(void)drawRect:(CGRect)rect{
//    UIImage *heartImage = [UIImage imageNamed:@"heart"];
//    UIImage *heartImageBorder = [UIImage imageNamed:@"heartBorder"];
//    
//    //Draw background image (mimics border)
//    UIGraphicsBeginImageContextWithOptions(heartImageBorder.size, NO, 0.0f);
//    [_strokeColor setFill];
//    CGRect bounds = CGRectMake(0, 0, heartImageBorder.size.width, heartImageBorder.size.height);
//    UIRectFill(bounds);
//    [heartImageBorder drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
//    heartImageBorder = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    //Draw foreground heart image
//    UIGraphicsBeginImageContextWithOptions(heartImage.size, NO, 0.0f);
//    [_fillColor setFill];
//    CGRect bounds1 = CGRectMake(0, 0, heartImage.size.width, heartImage.size.height);
//    UIRectFill(bounds1);
//    [heartImage drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
//    heartImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();

    [self drawHeartInRect:rect];

}

-(void)drawHeartInRect:(CGRect)rect{
    [_strokeColor setStroke];
    [_fillColor setFill];
    
    CGFloat drawingPadding = 4.0;
    CGFloat curveRadius = floor((CGRectGetWidth(rect) - 2*drawingPadding) / 4.0);
    
    //Creat path
    UIBezierPath *heartPath = [UIBezierPath bezierPath];
    
    //Start at bottom heart tip
    CGPoint tipLocation = CGPointMake(floor(CGRectGetWidth(rect) / 2.0), CGRectGetHeight(rect) - drawingPadding);
    [heartPath moveToPoint:tipLocation];
    
    //Move to top left start of curve
    CGPoint topLeftCurveStart = CGPointMake(drawingPadding, floor(CGRectGetHeight(rect) / 2.4));
    
    [heartPath addQuadCurveToPoint:topLeftCurveStart controlPoint:CGPointMake(topLeftCurveStart.x, topLeftCurveStart.y + curveRadius)];
    
    //Create top left curve
    [heartPath addArcWithCenter:CGPointMake(topLeftCurveStart.x + curveRadius, topLeftCurveStart.y) radius:curveRadius startAngle:PI endAngle:0 clockwise:YES];
    
    //Create top right curve
    CGPoint topRightCurveStart = CGPointMake(topLeftCurveStart.x + 2*curveRadius, topLeftCurveStart.y);
    [heartPath addArcWithCenter:CGPointMake(topRightCurveStart.x + curveRadius, topRightCurveStart.y) radius:curveRadius startAngle:PI endAngle:0 clockwise:YES];
    
    //Final curve to bottom heart tip
    CGPoint topRightCurveEnd = CGPointMake(topLeftCurveStart.x + 4*curveRadius, topRightCurveStart.y);
    [heartPath addQuadCurveToPoint:tipLocation controlPoint:CGPointMake(topRightCurveEnd.x, topRightCurveEnd.y + curveRadius)];
    
    [heartPath fill];
    
    heartPath.lineWidth = 1;
    heartPath.lineCapStyle = kCGLineCapRound;
    heartPath.lineJoinStyle = kCGLineCapRound;
    [heartPath stroke];
}


@end
