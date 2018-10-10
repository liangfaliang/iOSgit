//
//  LookOperationViewController.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/10.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "BasicViewController.h"
#import "OperateSubmitModel.h"
@interface LookOperationViewController : BasicViewController
@property (nonatomic,copy)void (^successBlock)(BOOL isDelete);
@property(nonatomic, strong)OperateSubmitModel *model;
@property(nonatomic, copy)NSString *OperateID;//作业ID
@end
