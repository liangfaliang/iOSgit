//
//  UINavigationBar+ChangeColor.h
//  TsApartment
//
//  Created by Dwt on 2018/6/11.
//  Copyright © 2018年 PmMaster. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (ChangeColor)

/**
 *  隐藏导航栏下的横线，背景色置空
 */
- (void)star;

/**
 *  @param color 最终显示颜色
 *  @param contentOffsetY 当前滑动视图
 *  @param value 滑动临界值，依据需求设置
 */
- (void)changeColor:(UIColor *)color contentOffsetY:(CGFloat)contentOffsetY AndValue:(CGFloat)value;

/**
 *  还原导航栏
 */
- (void)reset;

@end
