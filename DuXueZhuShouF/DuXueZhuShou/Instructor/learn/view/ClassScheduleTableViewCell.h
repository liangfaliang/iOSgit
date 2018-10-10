//
//  ClassScheduleTableViewCell.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/15.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleModel.h"
@interface ClassScheduleTableViewCell : UITableViewCell <UITextFieldDelegate,TFPickerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *weekLb;
@property (weak, nonatomic) IBOutlet UITextField *tfInClass;
@property (weak, nonatomic) IBOutlet UITextField *tfOutClass;
@property (weak, nonatomic) IBOutlet UITextField *tfMin;
@property (weak, nonatomic) IBOutlet UIButton *PunchBtn;
@property (retain, nonatomic)  ScheduleModel *model;
@property (copy,nonatomic) void (^PunchBtnBlock)(BOOL isSelect);
@end
