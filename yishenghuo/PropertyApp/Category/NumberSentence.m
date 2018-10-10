//
//  NumberSentence.m
//  jiaheyingyuan
//
//  Created by mayan on 15/9/16.
//  Copyright (c) 2015年 cn.yingyuan.www. All rights reserved.
//

#import "NumberSentence.h"

@implementation NumberSentence




/**
 * 检测是否是手机号码
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
//    /**
//     * 手机号码
//     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     * 联通：130,131,132,152,155,156,185,186
//     * 电信：133,1349,153,180,189
//     */
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
//    /**
//     * 中国移动：China Mobile
//     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
//     */
//    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
//    /**
//     * 中国联通：China Unicom
//     * 130,131,132,152,155,156,185,186
//     */
//    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
//    /**
//     * 中国电信：China Telecom
//     * 133,1349,153,180,189
//     */
//    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
//    /**
//     * 大陆地区固话及小灵通
//     * 区号：010,020,021,022,023,024,025,027,028,029
//     * 号码：七位或八位
//     */
//    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
//    
//    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
//        || ([regextestcm evaluateWithObject:mobileNum] == YES)
//        || ([regextestct evaluateWithObject:mobileNum] == YES)
//        || ([regextestcu evaluateWithObject:mobileNum] == YES))
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//    
//    
    
    
    //^[1][358][0-9]{9}$
    
    
    NSString * MOBILE = @"^[1][3578][0-9]{9}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    return [regextestmobile evaluateWithObject:mobileNum];
    
}



/**
 * 检测是否是邮箱
 */
+ (BOOL)isEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}




/**
 * 用户名
 */
+ (BOOL)isUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];

    return [userNamePredicate evaluateWithObject:name];
}




/**
 * 密码
 */
+ (BOOL)isPassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    
    return [passWordPredicate evaluateWithObject:passWord];
}



/**
  * 昵称
  */
+ (BOOL)isNickname:(NSString *)nickname
{
    //^[a-zA-Z0-9\u4e00-\u9fa5]+$
    //^[\u4e00-\u9fa5]{4,8}$
    NSString *nicknameRegex = @"^[a-zA-Z0-9\u4e00-\u9fa5]+$";
    
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    
    return [passWordPredicate evaluateWithObject:nickname];
}


/**
  * 身份证号
  */
+ (BOOL)isIdentityCard: (NSString *)identityCard
{
    if (identityCard.length <= 0) {
        return NO;
    }
    
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    
    return [identityCardPredicate evaluateWithObject:identityCard];
}


+(BOOL)isNumber:(NSString *)number
{
    //^[0-9]*$
    
    NSString *numberRegex = @"^[0-9]*$";
    
    NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",numberRegex];
    
    return [numberPredicate evaluateWithObject:number];
}


@end











