//
//  UIButton+YZExtension.m
//  jiaheyingyuan
//
//  Created by yangzhe on 15/8/24.
//  Copyright (c) 2015年 cn.yingyuan.www. All rights reserved.
//

#import "UIButton+Extension.h"
#import "UIImage+Extension.h"

@implementation UIButton (YZExtension)

-(void)setButtonBgNorImage:(NSString *)norImage selectedImage:(NSString *)selectedImage
{
    [self setBackgroundImage:[UIImage resizedImage:norImage] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage resizedImage:selectedImage] forState:UIControlStateSelected];
}

-(void)setButtonTitleNorColor:(UIColor *)norColor selectedColor:(UIColor *)selectedColor
{
    [self setTitleColor:norColor forState:UIControlStateNormal];
    [self setTitleColor:selectedColor forState:UIControlStateDisabled];
    [self setTitleColor:selectedColor forState:UIControlStateSelected];

}
@end
