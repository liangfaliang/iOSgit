//
//  OptionModel.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/24.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OptionModel : NSObject
@property (nonatomic, copy) NSString *name; /** 图片，不超过5张，多张之间以分隔符分割 */
@property (nonatomic, copy) NSString *class_id; /**     班级id  */
@property (nonatomic, copy) NSString *campus_id; /** 校区id */
@property (nonatomic, copy) NSString *school_id; /** 学校id  */
@property (nonatomic, assign) NSInteger isSelect; /** */
@end
