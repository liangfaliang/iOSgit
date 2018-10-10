//
//  SMS_SDK.h
//  SMS_SDKDemo
//
//  Created by 刘 靖煌 on 14-8-28.
//  Copyright (c) 2014年 掌淘科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h" //快速声明和实现单例的
@interface SMSSDK : NSObject
@property(nonatomic,strong)NSString *send_id;
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(SMSSDK);
#pragma mark - 支持获取验证码和提交验证码 (get the verification code and commit verifacation code)
/**
 *  @from                    v1.1.1
 *  @brief                   获取验证码(Get verification code)
 *
 *  @param method            获取验证码的方法(The method of getting verificationCode)
 *  @param phoneNumber       电话号码(The phone number)
 *  @param zone              区域号，不要加"+"号(Area code)
 *  @param result            请求结果回调(Results of the request)
 */
- (void) getVerificationCodeByMethod:(NSString * )method
                         phoneNumber:(NSString *)phoneNumber
                                zone:(NSString *)zone
                             success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;


/**
 * @from                    v1.1.1
 * @brief                   提交验证码(Commit the verification code)
 *
 * @param code              验证码(Verification code)
 * @param phoneNumber       电话号码(The phone number)
 * @param zone              区域号，不要加"+"号(Area code)
 * @param result            请求结果回调(Results of the request)
 */
- (void) commitVerificationCode:(NSString *)code
                    phoneNumber:(NSString *)phoneNumber
                           zone:(NSString *)zone
                        success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;


@end

