//
//  AddGroupViewController.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/10.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "BasicViewController.h"

@interface AddGroupViewController : BasicViewController
@property (nonatomic,copy)void (^successBlock)(void);
@property(nonatomic, copy)NSString *ID;//分组id  根据id判断是否为学生组详情
@end
