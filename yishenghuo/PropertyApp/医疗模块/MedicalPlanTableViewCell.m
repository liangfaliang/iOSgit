//
//  MedicalPlanTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/11.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "MedicalPlanTableViewCell.h"

@implementation MedicalPlanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.weekLb.layer.cornerRadius = 3;
    self.weekLb.layer.borderColor = [JHMedicalColor CGColor];
    self.weekLb.layer.borderWidth = 1;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.laveTimeBtn.titleLabel.numberOfLines = 0;
    self.laveTimeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.laveTimeBtn setTitleColor:JHsimpleColor forState:UIControlStateNormal];
    self.yuyueBtn.layer.cornerRadius = 12.5;
    self.yuyueBtn.layer.masksToBounds = YES;
    self.vline.layer.cornerRadius = 2;
    self.vline.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
