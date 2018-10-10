//
//  AddStudentsViewController.h
//  DuXueZhuShou
//
//  Created by admin on 2018/10/8.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "BasicViewController.h"
#import "AddStuModel.h"
@interface AddStudentsViewController : BasicViewController
@property(nonatomic, strong)AddStuModel *model;
@property(nonatomic, assign)BOOL isEdit;//是否为编辑 默认NO
@property (nonatomic,copy)void (^successBlock)(void);
@end
