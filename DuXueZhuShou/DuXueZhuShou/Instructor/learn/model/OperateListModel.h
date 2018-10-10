//
//  OperateListModel.h
//  DuXueZhuShou
//
//  Created by admin on 2018/9/14.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OperateListModel : NSObject
@property (nonatomic, copy) NSString *ID;/**    科目id */
@property (nonatomic, copy) NSString *create_time;/** 作业创建时间*/
@property (nonatomic, copy) NSString *start_time;/**作业发布时间 */
@property (nonatomic, assign) NSInteger status;/** 学管状态,1待发布，2已发布，3已送达  学生状态：1未打卡，2已打卡，3已评价*/
@property (nonatomic, assign) NSInteger is_read;/** 状态,0未读，1已读 */
@property (nonatomic, copy) NSString *name;/**科目名称 */
@property (nonatomic, copy) NSString *subject_images;/**科目图片 */
@property (nonatomic, copy) NSString *content;/** */
@property (nonatomic, strong) NSArray <OperateListModel *>*list;/** */
@end
