//
//  StuSignInModel.h
//  DuXueZhuShou
//
//  Created by admin on 2018/9/5.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttendSubmitModel.h"
@interface SignModel : NSObject

@property (nonatomic, assign) NSInteger status;/* 1=正常，2=异常，3=缺勤，4=已签到，5=待签*/
@property (nonatomic, copy) NSString *date;/**上课时间 */
@property (nonatomic, copy) NSString *type;/**上课时间 */
@property (nonatomic, copy) NSString *photo;/** 下课时间*/
@property (nonatomic, copy) NSString *time;/**上课时间 */
@property (nonatomic, strong)placeModel *place;/** 可签到地点*/
@end
@interface StuSignInModel : NSObject
@property (nonatomic, copy) NSString *name;/** */
@property (nonatomic, copy) NSString *ID;/**ID*/
@property (nonatomic, copy) NSString *order;/** 上课时间的时间戳（后台排序用的）*/
@property (nonatomic, assign) NSInteger status;/* 1=正常，2=异常，3=缺勤，4=已签到，5=待签*/
@property (nonatomic, copy) NSString *date;/**上课时间 */
@property (nonatomic, copy) NSString *mode;/** 方式：1=固定，2=自由*/
@property (nonatomic, copy) NSString *type;/**类型：-1=早自习，-2=晚自习，科目ID */
@property (nonatomic, copy) NSString *allowTimeBeforeSignIn;/** 有效签到时间*/
@property (nonatomic, copy) NSString *allowTimeAfterSignOut;/**有效签退时间 */
@property (nonatomic, copy) NSString *photoProof;/** 照片证明：1=需要，0=不需要*/
@property (nonatomic, copy) NSString *timetable;/** 下课时间*/
@property (nonatomic, copy) NSString *lesson_start_time;/**上课时间 */
@property (nonatomic, copy) NSString *lesson_end_time;/** 下课时间*/
@property (nonatomic, copy) NSString *minimum_time;/** 学习时长*/

@property (nonatomic, strong) NSArray <placeModel *> *place;/** 可签到地点*/
@property (nonatomic, strong) SignModel *sign_in;/** 可签到地点*/
@property (nonatomic, strong) SignModel *sign_out;/** 可签到地点*/
@end
