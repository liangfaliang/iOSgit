//
//  CustomLabel.m
//  shop
//
//  Created by wwzs on 16/5/10.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

+ (UILabel *)labBgImg:(UIImage *)img title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font backGroundColor:(UIColor *)backGroundColor cornerRadius:(CGFloat)cornerRadius textAlignment:(NSTextAlignment )textAlignment
{
    UILabel * lab = [[UILabel alloc]init];
    lab.backgroundImage = img;
    lab.backgroundColor = backGroundColor;
    lab.text = title;
    lab.textColor = titleColor;
    lab.font = font;
    
    lab.textAlignment = textAlignment;
    if (cornerRadius != 0.0) {
        lab.layer.cornerRadius = cornerRadius;
        lab.layer.masksToBounds = YES;
    }
    return  lab;
}


@end
