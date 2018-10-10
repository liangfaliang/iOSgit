//
//  CustomButton.m
//  shop
//
//  Created by wwzs on 16/5/10.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton
- (NSMutableArray *)imgsArr
{
    if (!_imgsArr) {
        _imgsArr = [[NSMutableArray alloc]init];
    }
    return _imgsArr;
}

+ (UIButton *)btnBgImg:(UIImage *)img title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font backGroundColor:(UIColor *)backGroundColor cornerRadius:(CGFloat)cornerRadius textAlignment:(NSTextAlignment )textAlignment
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.backgroundImage = img;
    [btn setImage:img forState:UIControlStateNormal];
    btn.backgroundColor = backGroundColor;
    [btn setTitle:title forState:UIControlStateNormal];
     [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    btn.titleLabel.textAlignment = textAlignment;
    if (cornerRadius != 0.0) {
        btn.layer.cornerRadius = cornerRadius;
        btn.layer.masksToBounds = YES;
    }
    return  btn;
}
@end
