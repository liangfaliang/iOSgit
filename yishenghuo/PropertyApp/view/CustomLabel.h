//
//  CustomLabel.h
//  shop
//
//  Created by wwzs on 16/5/10.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomLabel : UILabel
+ (UILabel *)labBgImg:(UIImage *)img title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font backGroundColor:(UIColor *)backGroundColor cornerRadius:(CGFloat)cornerRadius textAlignment:(NSTextAlignment )textAlignment;
@end
