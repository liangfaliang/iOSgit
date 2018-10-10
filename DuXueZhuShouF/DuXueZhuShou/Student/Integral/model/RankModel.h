//
//  RankModel.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/24.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankModel : NSObject
@property (nonatomic, copy) NSString *name; /** 图片，不超过5张，多张之间以分隔符分割 */
@property (nonatomic, copy) NSString *rank; /**     班级id  */
@property (nonatomic, copy) NSString *score; /** 校区id */
@property (nonatomic, copy) NSString *className; /** 学校id  */
@property (nonatomic, copy) NSString *campusName; /** 校区id */
@property (nonatomic, copy) NSString *rankName; /** 学校id  */
@property (nonatomic, assign) NSInteger is_classmate; /** 校区id */
@property (nonatomic, assign) BOOL isMy; /** 是否为自己排名 */
@end
