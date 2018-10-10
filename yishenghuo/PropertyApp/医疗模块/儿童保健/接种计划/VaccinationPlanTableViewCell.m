//
//  VaccinationPlanTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/23.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "VaccinationPlanTableViewCell.h"

@implementation VaccinationPlanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameView.layer.cornerRadius = 15;
    self.nameView.layer.masksToBounds = YES;
    self.nameLb.adjustsFontSizeToFitWidth = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
