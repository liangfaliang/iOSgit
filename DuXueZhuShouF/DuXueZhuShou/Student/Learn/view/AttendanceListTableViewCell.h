//
//  AttendanceListTableViewCell.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/1.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttendSubmitModel.h"
@interface AttendanceListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (retain, nonatomic) AttendStuModel *model;
@end
