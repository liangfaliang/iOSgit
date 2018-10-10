//
//  AlertView.h
//  SmarkPark
//
//  Created by SandClock on 2018/5/23.
//  Copyright © 2018年 PmMaster. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertView : NSObject

+ (void)showMsg:(NSString *)msg icon:(NSString *)icon view:(UIView *)view;

+ (void)showMsg:(NSString *)msg;

+ (void)showError:(NSString *)error toView:(UIView *)view;

+ (void)showError:(NSString *)error;

+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

+ (void)showSuccess:(NSString *)success;

+ (void)showProgress;

+ (void)dismiss;

@end
