//
//  LeaveListTableViewCell.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/7.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "LeaveListTableViewCell.h"

@implementation LeaveListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLb.adjustsFontSizeToFitWidth = YES;
    self.typeLb.layer.cornerRadius = 20;
    self.typeLb.layer.masksToBounds = YES;
}
-(void)setModel:(LeaveSubModel *)model{
    _model = model;
    self.typeLb.backgroundColor = [UIColor colorFromHexCode:model.color];
    self.typeLb.text = model.category;
    self.nameLb.text = model.username;
    self.timeLb.text = [NSString stringWithFormat:@"%@-%@",[UserUtils getShowDateWithTime:model.start_time dateFormat:@"MM.dd HH:mm"],[UserUtils getShowDateWithTime:model.end_time dateFormat:@"MM.dd HH:mm"]];
    if (model.is_old.integerValue == 1) {
        self.stutasLb.text = @"已过期";
    }else{
        NSArray *arr = @[@"申请中",@"申请拒绝",@"申请通过"];
        NSArray *colorArr = @[@"666666",@"666666",@"333333"];
        if (model.status > 0 && model.status <= arr.count) {
            self.stutasLb.text = arr[model.status-1];
            self.stutasLb.textColor =[UIColor colorFromHexCode:colorArr[model.status-1]];
            
        }else{
            self.stutasLb.text =@"";
        }
    }
    if (model.is_read && model.is_read.integerValue == 0 ) {
        self.stutasLb.attributedText = [[NSString stringWithFormat:@"%@ ● ",self.stutasLb.text] AttributedString:@"●" backColor:nil uicolor:JHAssistRedColor uifont:[UIFont systemFontOfSize:15]];
    }else{
        self.stutasLb.attributedText =  [[NSMutableAttributedString alloc]initWithString:self.stutasLb.text];
    }
//
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
