//
//  UIView+TransitionAnimation.m
//  04ModelViewControllerAnimation
//
//  Created by 余婷 on 15/10/8.
//  Copyright (c) 2015年 yuting. All rights reserved.
//

#import "UIView+TransitionAnimation.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView(TransitionAnimation)


- (void)addTransitionAnimationWithDuration:(CGFloat)duration type:(NSInteger)type subType:(NSInteger)subType{

    NSArray * types = @[@"pageCurl",@"pageUnCurl",@"rippleEffect",@"suckEffect",@"cube",@"oglFlip",@"CurlDown",@"CurlUp"];
    NSArray * subTypes = @[@"fromLeft",@"fromRight",@"fromTop",@"fromBottom"];
    
    CATransition * transition = [CATransition animation];
    
    transition.duration = duration;
    
    transition.type = types[type];
    
    transition.subtype = subTypes[subType];
    
    [self.layer  addAnimation:transition forKey:nil];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
