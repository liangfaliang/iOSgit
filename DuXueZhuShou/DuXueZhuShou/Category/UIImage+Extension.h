//
//  UIImage+Extension.h
//  Weibo
//
//  Created by lanou3g on 15/5/13.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *      返回一张没有渲染的图片
 */
+ (UIImage *)imageWithName:(NSString *)name;

/**
 *  根据图片名返回一张能够自由拉伸的图片
 */
+ (UIImage *)resizedImage:(NSString *)name;



//+(UIImage *)imageWITHColor:(UIColor *)color;


//修正图片横屏
- (UIImage *)fixOrientation;
@end
