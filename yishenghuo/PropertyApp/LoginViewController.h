//
//  LoginViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/7/6.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LoginViewController : BaseViewController
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(LoginViewController);
@property(nonatomic,copy)void(^ loginResultBlock)(id response);
-(void)refresh;
-(void)doLogin;
@end
