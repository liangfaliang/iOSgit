//
//  NumberSentence.h
//  jiaheyingyuan
//
//  Created by mayan on 15/9/16.
//  Copyright (c) 2015年 cn.yingyuan.www. All rights reserved.
//
//  手机号码、邮箱、用户名、密码、昵称、身份证号判则


#import <Foundation/Foundation.h>

@interface NumberSentence : NSObject



/**
 * 检测是否是手机号码
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;



/**
 * 检测是否是邮箱
 */
+ (BOOL)isEmail:(NSString *)email;



/**
 * 用户名
 */
+ (BOOL)isUserName:(NSString *)name;



/**
 * 密码
 */
+ (BOOL)isPassword:(NSString *)passWord;



/**
 * 昵称
 */
+ (BOOL)isNickname:(NSString *)nickname;



/**
 * 身份证号
 */
+ (BOOL)isIdentityCard: (NSString *)identityCard;



//数字
+ (BOOL)isNumber:(NSString *)number;

@end








