//
//  UIBarButtonItem+Extension.m
//  Weibo
//
//  Created by lanou3g on 15/5/13.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIImage+Extension.h"





#import "UIView+Extension.h"

@implementation UIBarButtonItem (Extension)


+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc]init];
//    button.backgroundColor = [UIColor redColor];
    [button setBackgroundImage:[UIImage imageWithName:imageName] forState:UIControlStateNormal];
    [button setBackgroundImage: [UIImage imageWithName:highImageName] forState:UIControlStateHighlighted];
    button.size = button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}



+(UIBarButtonItem *)itemWithTitle:(NSString *)title image:(NSString *)imageName target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, 30, 44);
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];

    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc]initWithCustomView:button];
}





@end
