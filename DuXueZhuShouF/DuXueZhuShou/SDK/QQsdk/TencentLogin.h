//
//  TencentLogin.h
//  AppProject
//
//  Created by admin on 2018/5/21.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "sdkDef.h"
@interface TencentLogin : NSObject <TencentSessionDelegate, TencentApiInterfaceDelegate, TCAPIRequestDelegate>
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(TencentLogin);
@property (nonatomic, retain)TencentOAuth *oauth;
- (void)login;
@property (nonatomic, copy) void (^Resultsblock) (NSInteger status,APIResponse* user);//0 成功 1 用户点击取消按键,主动退出登录 2其他原因， 导致登录失败 3登陆成功token获取失败
-(void)setResultsblock:(void (^)(NSInteger status, APIResponse *user))Resultsblock;
@end
