//
//  StuScoreListModel.h
//  DuXueZhuShou
//
//  Created by admin on 2018/9/27.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StuScoreListModel : NSObject
@property (nonatomic, copy) NSString * ID; /** 开始时间  */
@property (nonatomic, copy) NSString * name; /** 结束时间 */
@property (nonatomic, copy) NSString * subject; /** 考试科目  */
@property (nonatomic, copy) NSString * date; /** 考试日期 */
@property (nonatomic, copy) NSString * explain; /** 考试说明  */
@property (nonatomic, copy) NSString * class_ranking; /** 班级排名 */
@property (nonatomic, copy) NSString * campus_ranking; /** 校区排名  */
@property (nonatomic, copy) NSString * school_ranking; /** 学校排名 */
@property (nonatomic, copy) NSString * score; /** 考试分数  */
@end
