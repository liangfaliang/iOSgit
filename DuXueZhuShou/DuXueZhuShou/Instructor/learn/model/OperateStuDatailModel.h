//
//  OperateStuDatailModel.h
//  DuXueZhuShou
//
//  Created by admin on 2018/9/16.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperateStuDatailModel : NSObject
@property (nonatomic, copy) NSString *ID;/**   详情id */
@property (nonatomic, copy) NSString *content;/** 作业内容*/
@property (nonatomic, copy) NSString *user_content;/** 打卡内容*/
@property (nonatomic, copy) NSString *start_time;/** 发布时间，10位时间戳，发布时必填*/
@property (nonatomic, copy) NSString *end_time;/**最晚打卡时间，10位时间戳，发布时必填 */
@property (nonatomic, copy) NSString *completed_time;/** 打卡时间，为0则不显示，10位时间戳*/
//@property (nonatomic, copy) NSString *create_time;/** 作业创建时间，10位时间戳*/
@property (nonatomic, copy) NSString *type;/** 作业状态，1未打卡，2已完成，3未完成*/
@property (nonatomic, copy) NSString * subject;/** 科目名称*/
@property (nonatomic, copy) NSString * comment;/** 学管员评价，为空则不显示*/
@property (nonatomic, strong) NSArray *images;/** 图片*/
@property (nonatomic, strong) NSArray *user_images;/** 打卡图片图片*/

//学管员查看学生作业详情
@property (nonatomic, copy) NSString * status;/** 作业状态,1未打卡，2已打卡(未评价)，3已评价*/
@end
