//
//  LeaveSubModel.h
//  DuXueZhuShou
//
//  Created by admin on 2018/9/3.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeaveSubModel : NSObject
@property (nonatomic, copy) NSString * start_time; /** 开始时间  */
@property (nonatomic, copy) NSString * end_time; /** 结束时间 */
@property (nonatomic, assign) NSInteger status; /** 1申请中，2申请拒绝,3申请通过 */
@property (nonatomic, copy) NSString *name; /** 姓名  */
@property (nonatomic, copy) NSString *username; /** 姓名  */
@property (nonatomic, copy) NSString *color; /**颜色  */
@property (nonatomic, assign) NSInteger is_old; /** 是否过期,0否,1是 */
@property (nonatomic, copy) NSString *user_is_read; /** 是否已读,0否,1是  */
@property (nonatomic, copy) NSString *is_read; /** 是否已读,0否,1是  */
@property (nonatomic, copy) NSString *ID; /** 对应数据  */

@property (nonatomic, copy) NSString *images; /** 图片，不超过5张，多张之间以分隔符分割  */
@property (nonatomic, strong) NSArray *imagesArr; /** 图片，不超过5张，多张之间以分隔符分割  */
@property (nonatomic, copy) NSString *content; /**请假事由  */
@property (nonatomic, copy) NSString *leave_category_id; /** 请假类型id */
@property (nonatomic, copy) NSString *category; /** 请假类型 */


@property (nonatomic, copy) NSString *check_content; /**审核意见  */
@property (nonatomic, copy) NSString *check_images; /**审核意见图片  */
@property (nonatomic, strong) NSArray *check_imagesArr; /**审核意见图片  */
@property (nonatomic, copy) NSString *type; /**1本人是申请人，2本人是学管员 */
@end
