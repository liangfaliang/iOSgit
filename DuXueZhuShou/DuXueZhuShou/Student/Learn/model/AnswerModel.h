//
//  AnswerModel.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/22.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnswerModel : NSObject
@property (nonatomic, copy) NSString *title; /** 姓名  */
@property (nonatomic, copy) NSString *images; /** 图片，不超过5张，多张之间以分隔符分割 */
@property (nonatomic, copy) NSString *url; /** 姓名  */
@property (nonatomic, copy) NSString *content; /** 头像 */
@property (nonatomic, copy) NSString *subject_id; /** 科目id  */
@property (nonatomic, copy) NSString *teachers_id; /** 教师id，1-3个，多个之间以分隔符分割 */
@property (nonatomic, copy) NSString *is_open; /** 是否公开,0否,1是  */
@end
