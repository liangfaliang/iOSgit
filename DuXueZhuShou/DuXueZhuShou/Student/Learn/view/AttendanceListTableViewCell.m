//
//  AttendanceListTableViewCell.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/1.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AttendanceListTableViewCell.h"

@implementation AttendanceListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(AttendStuModel *)model{
    _model =model;
    self.contentLb.text = model.name;
    self.timeLb.text = [NSString stringWithFormat:@"%@-%@",model.lesson_start_time,model.lesson_end_time];
    NSArray *arr = @[@"考勤未开始",@"正常",@"异常",@"缺勤",@"已签到",@"待签到"];
    if (model.status >= 0 && model.status < arr.count) {
        self.statusLb.text = arr[model.status];
    }else{
        self.statusLb.text = @"";
    }
    self.statusLb.textColor = [UIColor colorFromHexCode:model.status == 1 ? @"1ec7a1" :@"F13B29"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
