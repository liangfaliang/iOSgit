//
//  UserModel.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/9/19.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
//判断用户是否登录
@property(nonatomic,assign,getter=isLogin)BOOL login;
+(BOOL)online;
+(BOOL)Certification;
+(instancetype)shareUserModel;
//保存用户信息
+(void)saveUserInfo:(NSDictionary *)dict;
//请求业主信息
-(void)sendTobox;
//保存业主信息
-(void)SaveOwnerInfo:(NSDictionary *)dict;
//员工信息
-(void)infosendTobox;
// 清除业主信息
-(void)removeUserInfo;
// 清除员工信息
-(void)removeWorkUserInfo;
// 清除所有信息
-(void)removeAllUserInfo;
-(void)controllerUserInfo;
+ (NSString *)getShowDateWithTime:(NSString *)time dateFormat:(NSString *)dateFormat; //时间戳转成时间
+ (NSString *)getShowDate:(NSDate *)date dateFormat:(NSString *)dateFormat; //nsdte转成时间

#pragma mark 送积分
+(void)OperationToSendPoints:(NSString *)action;
#pragma mark  runtime跳转页面
-(UIViewController *)runtimePushviewController:(NSDictionary *)dict controller:(UIViewController *)vc;
/**
 *  检测对象是否存在该属性
 */
- (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName;
#pragma mark - *************用户信息*************
+(void)UploadDataUserInfo:(void (^)(id response))result error:(void (^)(NSError *error))failerror;
#pragma mark - *************门禁开门*************
+(void)AccessOpenDoor:(NSDictionary *)paramDt result:(void (^)(id response))result error:(void (^)(NSError *error))failerror;
+(void)MakeTelephoneCall:(NSString *)tel;//拨打电话
@end
