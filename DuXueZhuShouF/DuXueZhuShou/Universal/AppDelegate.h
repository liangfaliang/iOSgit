//
//  AppDelegate.h
//  DuXueZhuShou
//
//  Created by admin on 2018/7/24.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LFLTabBarViewController.h"
static NSString *appKey = @"24acbf48f1d3f7d234fb69ce";
static NSString *channel = @"Publish channel";
#ifdef DEBUG //测试阶段
static BOOL isProduction = YES;
#else
static BOOL isProduction = YES;
#endif
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LFLTabBarViewController *tabbar;
@property (nonatomic, assign) UserRoleStyle type; /**< ：0=学管,1=教师,2=学生 */
@end

