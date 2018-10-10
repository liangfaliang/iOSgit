//
//  MBProgressHUD+Extension.h
//  jiaheyingyuan
//
//  Created by yangzhe on 15/8/26.
//  Copyright (c) 2015年 cn.yingyuan.www. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Extension)


+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;

+ (MBProgressHUD *)showMessage:(NSString *)message;

+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;


@end
