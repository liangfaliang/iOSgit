//
//  LeaveListTableViewCell.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/7.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeaveSubModel.h"
@interface LeaveListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *stutasLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLbWidth;
@property (retain, nonatomic)  LeaveSubModel *model;
@end
