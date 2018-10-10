//
//  UIView+Extension.h
//  Weibo
//
//  Created by lanou3g on 15/5/13.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic,strong) UIImage *backgroundImage;

@property (nonatomic,assign) CGFloat x;

@property (nonatomic,assign) CGFloat y;

@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat centerX;
@property (nonatomic,assign) CGFloat centerY;
@property (nonatomic,assign) CGSize size;
-(void)setViewBorderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth;
@end
