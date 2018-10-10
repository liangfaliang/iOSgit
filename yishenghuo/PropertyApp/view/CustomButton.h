//
//  CustomButton.h
//  shop
//
//  Created by wwzs on 16/5/10.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton
@property (nonatomic,assign)NSInteger tag2;
@property (nonatomic,strong)NSMutableArray *imgsArr;
+ (UIButton *)btnBgImg:(UIImage *)img title:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font backGroundColor:(UIColor *)backGroundColor cornerRadius:(CGFloat)cornerRadius textAlignment:(NSTextAlignment )textAlignment;
@end
