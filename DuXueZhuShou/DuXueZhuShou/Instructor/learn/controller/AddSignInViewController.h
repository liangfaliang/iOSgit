//
//  AddSignInViewController.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/14.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "BasicViewController.h"
#import "AttendSubmitModel.h"
@interface AddSignInViewController : BasicViewController
@property(nonatomic, strong)AttendSubmitModel *model;
@property(nonatomic,assign)BOOL isEdit;//是否为编辑
@property (nonatomic,copy)void (^successBlock)(void);
@end
