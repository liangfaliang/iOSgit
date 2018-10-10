//
//  UIButton+control.h
//  PropertyApp
//
//  Created by 梁法亮 on 2017/11/21.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (control)
@property(nonatomic,assign)NSTimeInterval timeInterval;//用这个给重复点击加间隔
@property(nonatomic,assign)BOOL isIgnoreEvent;//YES不允许点击NO允许点击
@property(nonatomic,assign)BOOL isEffective;//timeInterval是否生效 NO生效
-(void)setPropertys:(NSString *)text font:(UIFont *)font textcolor:(UIColor *)textcolor image:(UIImage *)image state:(UIControlState )state;
@end
