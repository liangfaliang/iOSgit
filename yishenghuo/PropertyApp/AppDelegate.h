//
//  AppDelegate.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/7/4.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFLTabBarViewController.h"
static NSString *appKey = @"a0d14836bb4035356c6f13d6";
static NSString *channel = @"Publish channel";
#ifdef DEBUG //测试阶段
static BOOL isProduction = YES;
#else
static BOOL isProduction = YES;

#endif


@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>
@property (strong, nonatomic) LFLTabBarViewController *tabbar;
@property (strong, nonatomic) UIWindow *window;

@end

