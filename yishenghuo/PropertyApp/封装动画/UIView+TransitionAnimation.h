//
//  UIView+TransitionAnimation.h
//  04ModelViewControllerAnimation
//
//  Created by 余婷 on 15/10/8.
//  Copyright (c) 2015年 yuting. All rights reserved.
//

#import <UIKit/UIKit.h>

//动画效果的枚举
typedef enum : NSUInteger {
    TransitionPageCurl,
    TransitionPageUnCurl,
    TransitionRippleEffect,
    TransitionSuckEffect,
    TransitionCube,
    TransitionOglFlip,
    TransitionCurlDown,
    TransitionCurlUp
} TransitionType;

//动画方向的枚举
typedef enum : NSUInteger {
    FROM_LEFT,
    FROM_RIGHT,
    FROM_TOP,
    FROM_BOTTOM
} TransitionToward;


@interface UIView(TransitionAnimation)


- (void)addTransitionAnimationWithDuration:(CGFloat)duration type:(NSInteger)type subType:(NSInteger)subType;

/*
 用法
  [self.view.window addTransitionAnimationWithDuration:3.0f type:TransitionRippleEffect subType:FROM_RIGHT];
 
 */

@end
