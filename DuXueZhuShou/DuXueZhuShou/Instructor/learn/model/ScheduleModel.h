//
//  ScheduleModel.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/29.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleModel : NSObject
@property (nonatomic, copy) NSString *type;/**星期n：1=星期一，2=星期二，3=星期三*/
@property (nonatomic, copy) NSString *lesson_start_time;/**上课时间（23:59:59） */
@property (nonatomic, copy) NSString *lesson_end_time;/** 下课时间（23:59:59）*/
@property (nonatomic, copy) NSString *minimum_time;/** 最短学习时间：单位=分钟*/
@property (nonatomic, assign) NSInteger sign_out;/** 是否需要下课签退：1=需要，0=不需要*/
@property (nonatomic, copy) NSString *week;//周
@end
