//
//  OperateSubmitModel.h
//  DuXueZhuShou
//
//  Created by admin on 2018/9/12.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperateSubmitModel : NSObject
@property (nonatomic, copy) NSString *subject_id;/**    科目id */
@property (nonatomic, copy) NSString *ID;/**   详情id */
@property (nonatomic, copy) NSString *content;/** 作业内容*/
@property (nonatomic, copy) NSString *group_id;/**分组id，发布时必填 */
@property (nonatomic, copy) NSString *start_time;/** 发布时间，10位时间戳，发布时必填*/
@property (nonatomic, copy) NSString *end_time;/**最晚打卡时间，10位时间戳，发布时必填 */
@property (nonatomic, copy) NSString *clock_time;/** 提醒时间，10位时间戳，发布时必填*/
@property (nonatomic, copy) NSString *create_time;/** 作业创建时间，10位时间戳*/
@property (nonatomic, copy) NSString *images;/** */
@property (nonatomic, copy) NSString *type;/** 1发布，2保存*/
@property (nonatomic, copy) NSString * status;/** 状态,1待发布，2已发布，3已送达*/
@property (nonatomic, strong) NSArray *imageArr;/** 图片*/
@property (nonatomic, strong) IDnameModel *subject;/** 科目*/
@property (nonatomic, strong) IDnameModel *group;/**   分组*/

@end

