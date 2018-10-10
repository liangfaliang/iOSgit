//
//  LFLLogin.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/7/6.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "LFLLogin.h"
#import "LoginViewController.h"
#import "LFLNavigationController.h"

@implementation LFLLogin

+(void)Login:(id)tag{

    LoginViewController *login = [[LoginViewController alloc]init];
    
    LFLNavigationController *na = [[LFLNavigationController alloc]initWithRootViewController:login];
    
    [tag presentViewController:na animated:YES completion:nil];


}

@end
