//
//  PublishedModel.h
//  DuXueZhuShou
//
//  Created by admin on 2018/9/20.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublishedModel : NSObject
@property (nonatomic, copy) NSString *ID;/**   详情id */
@property (nonatomic, copy) NSString *content;/** 作业内容*/
@property (nonatomic, copy) NSString *user_content;/** 打卡内容*/
@property (nonatomic, copy) NSString *start_time;/** 发布时间，10位时间戳，发布时必填*/
@property (nonatomic, copy) NSString *end_time;/**最晚打卡时间，10位时间戳，发布时必填 */
@property (nonatomic, copy) NSString *clock_time;/** 未打卡提醒时间，10位时间戳*/
//@property (nonatomic, copy) NSString *create_time;/** 作业创建时间，10位时间戳*/
@property (nonatomic, copy) NSString *student_completed_number;/** 完成人数*/
@property (nonatomic, copy) NSString *student_uncompleted_number;/** 未完成人数*/
@property (nonatomic, copy) NSString *student_uncard_number;/**     未打卡人数*/
@property (nonatomic, copy) NSString *student_number;/**     打卡学生总数*/
@property (nonatomic, copy) NSString * completed_rate;/** 完成率，单位百分之*/
@property (nonatomic, copy) NSString * uncompleted_rate;/** 未完成率，单位百分之*/
@property (nonatomic, copy) NSString * uncard_rate;/** 未打卡率，单位百分之*/
@property (nonatomic, copy) NSString * subject_name;/** 科目名称*/


@end
