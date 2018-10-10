//
//  StudentGroupViewController.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/10.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "BasicViewController.h"
#import "TextFiledModel.h"
@interface StudentGroupViewController : BasicViewController
@property(nonatomic,assign)BOOL isSignSet;//是否为签到设置
@property(nonatomic,retain)TextFiledModel * model;//分组id
@end
