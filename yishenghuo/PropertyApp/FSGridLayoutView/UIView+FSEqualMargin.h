//
//  UIView+FSEqualMargin.h
//  FSGridLayoutDemo
//
//  Created by 冯顺 on 2017/6/10.
//  Copyright © 2017年 冯顺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FSEqualMargin)

- (void) distributeSpacingHorizontallyWith:(NSArray*)views space:(double )spaceline;

- (void) distributeSpacingVerticallyWith:(NSArray*)views;
@end
