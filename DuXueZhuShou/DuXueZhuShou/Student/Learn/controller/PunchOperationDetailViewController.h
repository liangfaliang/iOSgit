//
//  PunchOperationDetailViewController.h
//  DuXueZhuShou
//
//  Created by admin on 2018/7/31.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "BasicViewController.h"

@interface PunchOperationDetailViewController : BasicViewController
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)void (^successBlock)(void);
@end
