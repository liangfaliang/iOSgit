//
//  LoginViewController.h
//  AppProject
//
//  Created by admin on 2018/5/21.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "BasicViewController.h"

@interface LoginViewController : BasicViewController
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(LoginViewController);
@property(nonatomic,copy)void(^ loginResultBlock)(NSInteger code);
-(void)refresh;
-(void)doLogin;
@end
