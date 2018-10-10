//
//  UIButton+YZExtension.h
//  jiaheyingyuan
//
//  Created by yangzhe on 15/8/24.
//  Copyright (c) 2015年 cn.yingyuan.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (YZExtension)


/**
 *  设置button背景图片
 */
-(void)setButtonBgNorImage:(NSString *)norImage selectedImage:(NSString *)selectedImage;


/**
 *  设置button文字颜色
 */
-(void)setButtonTitleNorColor:(UIColor *)norColor selectedColor:(UIColor *)selectedColor;



@end
