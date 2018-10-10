//
//  AnswerListModel.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/22.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnswerListModel : NSObject
@property (nonatomic, copy) NSString *title; /** 姓名  */
@property (nonatomic, copy) NSString *ID; /** 图片，不超过5张，多张之间以分隔符分割 */
@property (nonatomic, copy) NSString *create_time; /** 姓名  */
@property (nonatomic, copy) NSString *is_read; /** 头像 */
@end
