//
//  UIBarButtonItem+Extension.h
//  Weibo
//
//  Created by lanou3g on 15/5/13.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)


+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName: (NSString *)highImageName target:(id)target action:(SEL)action;


+(UIBarButtonItem *)itemWithTitle: (NSString *)title image:(NSString *)imageName target:(id)target action:(SEL)action;



@end
