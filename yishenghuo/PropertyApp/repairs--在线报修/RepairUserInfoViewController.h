//
//  RepairUserInfoViewController.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/1/12.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "BaseViewController.h"
#import "repairUserView.h"
@interface RepairUserInfoViewController : BaseViewController
@property(nonatomic,copy)NSString *ws_worker;
@property(nonatomic,copy)NSString *ws_type;
@property(nonatomic,strong)repairUserView *UserView;
@end
