//
//  InsPunchViewController.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/20.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "BasicViewController.h"

@interface InsPunchViewController : BasicViewController
@property(nonatomic, copy)NSString *OperateID;//作业ID
@property (nonatomic,copy)void (^successBlock)(void);
@end
