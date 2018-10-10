//
//  UIImageView+EasyInOut.h
//  WTImageEasyInOut
//
//  Created by Dwt on 2017/2/15.
//  Copyright © 2017年 Dwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (EasyInOut)

//淡出效果
- (void)wt_setImageWithURL:(NSString *)ImageURL placeholderImage:(UIImage *)placeholderImage completed:(void(^)(UIImage *image))completed;

//切圆角
- (void)wt_setImageWithCorner:(CGFloat)corner url:(NSString *)url placeholderImage:(UIImage *)placeholderImage completed:(void(^)(UIImage *image))completed;

//切圆
- (void)wt_setCircleImageWithUrl:(NSString *)url placeholderImage:(UIImage *)placeholderImage completed:(void(^)(UIImage *image))completed;

@end
