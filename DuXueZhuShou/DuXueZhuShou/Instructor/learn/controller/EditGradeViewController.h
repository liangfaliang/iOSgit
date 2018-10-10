//
//  EditGradeViewController.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/16.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "BasicViewController.h"
typedef NS_ENUM(NSInteger, EditGradetypeStyle) {
    EditGradeStyleRelease = 0,                  // 测试成绩
    EditGradeStyleSave = 1,        // 保存
    EditGradeStyleEdit = 2,           // 已发布
    EditGradeStyleNone = 3           // 无状态
};
@interface EditGradeViewController : BasicViewController
@property (nonatomic, assign) EditGradetypeStyle typeStyle;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic,copy)void (^successBlock)(void);
@end
