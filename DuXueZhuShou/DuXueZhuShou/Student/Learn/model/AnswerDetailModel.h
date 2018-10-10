//
//  AnswerDetailModel.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/22.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ReplyModel : NSObject
@property (nonatomic, copy) NSString *ID; /** 姓名  */
@property (nonatomic, copy) NSString *name; /** 姓名  */
@property (nonatomic, copy) NSString *content; /** 图片，不超过5张，多张之间以分隔符分割 */
@property (nonatomic, copy) NSString *create_time; /** 姓名  */
@property (nonatomic, strong) NSArray *images; /** 头像 */
@property (nonatomic, copy) NSString *level; /** 姓名  */
@property (nonatomic, copy) NSString *url; /** 图片，不超过5张，多张之间以分隔符分割 */
@property (nonatomic, copy) NSString *is_open; /** 姓名  */
@property (nonatomic, strong) NSArray <ReplyModel *> *children; /** 头像 */

@property (nonatomic, copy) NSString *can_answer; /** 能否回复,1可以，0不能*/
@property (nonatomic, copy) NSString *type; /** 0学管，2学生  */
@end


@interface AnswerDetailModel : NSObject
@property (nonatomic, copy) NSString *title; /** 姓名  */
@property (nonatomic, copy) NSString *content; /** 图片，不超过5张，多张之间以分隔符分割 */
@property (nonatomic, copy) NSString *create_time; /** 姓名  */
@property (nonatomic, strong) NSArray *images; /** 头像 */
@property (nonatomic, copy) NSString *url; /** 姓名  */
@property (nonatomic, copy) NSString *type; /** 图片，不超过5张，多张之间以分隔符分割 */
@property (nonatomic, copy) NSString *full_name; /** 姓名  */
@property (nonatomic, strong) NSArray *teachers; /** 头像 */
@property (nonatomic, strong) NSArray <ReplyModel *>*answers; /** 头像 */

@end

//补分审批详情
@interface IgDetailModel : NSObject
@property (nonatomic, copy) NSString *ID; /** 姓名  */
@property (nonatomic, copy) NSString *content; /** 图片，不超过5张，多张之间以分隔符分割 */
@property (nonatomic, copy) NSString *create_time; /** 姓名  */
@property (nonatomic, strong) NSArray *images; /** 头像 */
@property (nonatomic, copy) NSString *status; /**1申请中，2同意，3拒绝  */
@property (nonatomic, copy) NSString *type; /** 图片，0未处理，1已处理 */
@property (nonatomic, copy) NSString *score; /** 补发积分，未处理时为0  */
@property (nonatomic, copy) NSString *name; /** 姓名  */

@end
