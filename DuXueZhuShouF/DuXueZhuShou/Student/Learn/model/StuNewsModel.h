//
//  StuNewsModel.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/27.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StuNewsModel : NSObject
@property (nonatomic, copy) NSString *title; /** 姓名  */
@property (nonatomic, copy) NSString *message; /** 图片，不超过5张，多张之间以分隔符分割 */
@property (nonatomic, copy) NSString *create_time; /** 姓名  */
@property (nonatomic, copy) NSString *is_read; /**0未读，1已读  */
@property (nonatomic, copy) NSString *type; /** 1后台推送,2系统消息,3作业,4成绩,5答疑,6请假申请,7补分申请 */
@property (nonatomic, copy) NSString *push_data; /** 对应数据  */
@property (nonatomic, copy) NSString *ID; /** 对应数据  */
@end
