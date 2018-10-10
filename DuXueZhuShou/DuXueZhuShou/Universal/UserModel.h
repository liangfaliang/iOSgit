//
//  UserModel.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/9/19.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, UserRoleStyle) {
    UserStyleNone = -1,                  // 无角色
    UserStyleInstructor = 0,                  // 学管
    UserStyleTeacher = 1,        // 教师
    UserStyleStudent = 2           // 学生
};
@interface UserModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *ID; /**< id*/
@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) UserRoleStyle type; /**< ：0=学管,1=教师,2=学生 */
@property (nonatomic, assign) UserRoleStyle user_type; /**< ：0=学管,1=教师,2=学生 */
@property (nonatomic, copy) NSString *userId; /** 用户id，用此id作为极光推送的别名 */
@property (nonatomic, copy) NSString *name; /**< 名字 */
@property (nonatomic, copy) NSString *avatar; /**< 头像 */
@property (nonatomic, copy) NSString *score; /**< 积分 */
@property (nonatomic, copy) NSString *rank; /**< 等级名称 */
@property (nonatomic, copy) NSString *next_rank; /**< 下一等级名称 */
@property (nonatomic, copy) NSString *next_rank_score; /**下一等级所需分数 */
@property (nonatomic, copy) NSString *next_rank_diff; /**目前到达下一等级所差分数 */
@property (nonatomic, copy) NSString *image; /** 目前等级图片*/
@property (nonatomic, copy) NSString *next_image; /**< 下一等级图片 */
@property (nonatomic, copy) NSString *schoolName; /**< 学校名称 */
@property (nonatomic, copy) NSString *campusName; /**< 校区名称 */
@property (nonatomic, copy) NSString *className; /**< 班级名称 */
@end
