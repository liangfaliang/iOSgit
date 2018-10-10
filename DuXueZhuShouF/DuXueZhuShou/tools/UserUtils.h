//
//  UserUtils.h
//  AppProject
//
//  Created by admin on 2018/5/22.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserUtils : NSObject
+(instancetype)shareUserUtils;
//保存用户信息
+(void)saveUserInfo:(id)dict;
//获取用户信息
+(UserModel *)getUserInfo;
//获取用户角色
+(UserRoleStyle )getUserRole;
//清除用户信息
+(void)RemoveUserInfo;
+(void)saveAppSetInfo:(id)dict;
//+(MAppSetModel *)getAppSetInfo;
//图片上传
+(void)postPicture:(id )body type:(NSString *)type success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;
// 更新用户信息
//+(void)postUserInfo:(UserModel * )model ViewController:(BaseViewController *)vc success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;
//// 获取最新用户信息
+(void)postGetUserInfo:(BasicViewController *)vc success:(void (^)(id response))success failure:(void (^)(NSError *error))failure;

+ (NSString *)getShowDateWithTime:(NSString *)time dateFormat:(NSString *)dateFormat; //时间戳转成时间
+ (NSString *)getShowDate:(NSDate *)date dateFormat:(NSString *)dateFormat; //nsdte转成时间
//字符串转时间戳 如：2017-4-10 17:15:10
+ (NSString *)getTimeStrWithString:(NSString *)str dateFormat:(NSString *)dateFormat;
+ (NSDate *)getDateWithString:(NSString *)str;
+(void)MakeTelephoneCall:(NSString *)tel;//拨打电话

#pragma mark  runtime跳转页面
-(UIViewController *)runtimePushviewController:(NSDictionary *)dict controller:(UIViewController *)vc;
/**
 *  检测对象是否存在该属性
 */
- (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName;
#pragma mark - *************用户信息*************
+(void)UploadDataUserInfo:(void (^)(id response))result error:(void (^)(NSError *error))failerror;
#pragma mark - *************图片展示*************
+(void)ShowImageView:(NSArray <UIImageView  *>*)imageViewArr imageUrlArr:(NSArray *)imageUrlArr index:(NSInteger )index;

#pragma mark - *************消息跳转*************
+(void)MessagePushContriller:(UIViewController *)vc type:(NSString *)type ID:(NSString *)Id push_data:(NSString *)push_data;




@end
