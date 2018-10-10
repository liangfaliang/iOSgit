//
//  SupplyFractionApprovalViewController.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/17.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "BasicViewController.h"

@interface SupplyFractionApprovalViewController : BasicViewController
@property (nonatomic,copy)NSString *ID;
@property (nonatomic,copy)void (^successBlock)(void);
@end
