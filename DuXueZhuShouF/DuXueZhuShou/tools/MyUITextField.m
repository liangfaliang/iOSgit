//
//  MyUITextField.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/31.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "MyUITextField.h"

@implementation MyUITextField


-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil && !self.unEffective) {
        for (UIView *subView in self.subviews) {
            CGPoint myPoint = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, myPoint)) {
                return subView;
                
            }
            
        }
        
    }
    return view;
}

@end
