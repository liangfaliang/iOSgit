//
//  AttendSubmitModel.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/29.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScheduleModel.h"
/** 可签到地点*/
@interface placeModel : NSObject
@property (nonatomic, copy) NSString *name;/** */
@property (nonatomic, copy) NSString *date;/** 签到日期*/
@property (nonatomic, copy) NSString *place;/** 可签到地点ID*/
@property (nonatomic, copy) NSString *photo;/** 可签到地点ID*/
@property (nonatomic, copy) NSString *address;/** */
@property (nonatomic, assign) double lng;/** 备注*/
@property (nonatomic, assign) double lat;/** 备注*/
@end


//课程表信息
@interface courseModel : NSObject
@property (nonatomic, copy) NSString *effective_date;/** 生效日期（YYYY-MM-DD）*/
@property (nonatomic, copy) NSString *expiry_date;/** 失效日期（YYYY-MM-DD）*/
@property (nonatomic, strong) NSArray *timetable;/** 时间表信息*/
@end


@interface AttendSubmitModel : NSObject
@property (nonatomic, copy) NSString *ID;/**ID*/
@property (nonatomic, copy) NSString *name;/** */
@property (nonatomic, copy) NSString *type;/** 类型：-1=早自习，-2=晚自习，科目ID*/
@property (nonatomic, copy) NSString *remark;/** 备注*/
@property (nonatomic, assign) NSInteger mode;/**方式：1=固定，2=自由 */
@property (nonatomic, copy) NSString *allowTimeBeforeSignIn;/**有效签到时间：单位=分钟，考勤方式为固定时必须 */
@property (nonatomic, copy) NSString *allowTimeAfterSignOut;/** 有效签退时间：单位=分钟，考勤方式为固定时必须*/
@property (nonatomic, assign) NSInteger photoProof;/** 照片证明：1=需要，0=不需要*/
@property (nonatomic, strong) NSArray *place;/** 可签到地点*/
@property (nonatomic, strong) NSArray *student;/** 学生ID列表：1=需要，0=不需要*/
@property (nonatomic, strong) NSArray *special_date;/** 特殊日期列表：格式=[‘2018-08-28’,…]*/
@property (nonatomic, strong) courseModel *course;/** 课程表信息*/

@end

//学生考勤组
@interface AttendStuModel : NSObject
@property (nonatomic, copy) NSString *name;/** */
@property (nonatomic, copy) NSString *ID;/**ID*/
@property (nonatomic, copy) NSString *order;/** 上课时间的时间戳（后台排序用的）*/
@property (nonatomic, assign) NSInteger status;/* 考勤状态：0=考勤未开始、1=正常、2=异常、3=缺勤、4=已签到、5=待签 */
@property (nonatomic, copy) NSString *lesson_start_time;/**上课时间 */
@property (nonatomic, copy) NSString *lesson_end_time;/** 下课时间*/

@end
