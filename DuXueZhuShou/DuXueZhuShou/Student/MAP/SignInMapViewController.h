//
//  SignInMapViewController.h
//  DuXueZhuShou
//
//  Created by admin on 2018/7/31.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "BasicViewController.h"
#import "AttendSubmitModel.h"
#import "StuSignInModel.h"
@interface SignInMapViewController : BasicViewController
@property(nonatomic, retain)AttendSubmitModel *model;
@property(nonatomic, retain)StuSignInModel *smodel;
@property (assign,nonatomic)BOOL isSetAdress;//是否为设置地点
@property (nonatomic,copy)void (^successBlock)(void);
@end
