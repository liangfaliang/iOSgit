//
//  LFLTabBarViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/7/4.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LFLTabBarViewController : UITabBarController
@property (nonatomic, assign) UserRoleStyle type; /**< ：0=学管,1=教师,2=学生 */
-(UIViewController *)topVC:(UIViewController *)rootViewcontroller;

@end
