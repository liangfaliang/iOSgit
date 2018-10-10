//
//  SelectStudentViewController.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/29.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "BasicViewController.h"
#import "AttendSubmitModel.h"
@interface SelectStudentViewController : BasicViewController
@property(nonatomic,assign)BOOL isEdit;//是否为编辑
@property(nonatomic, retain)AttendSubmitModel *model;
@end
