//
//  MedicalExaminationTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/12.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "MedicalExaminationTableViewCell.h"

@implementation MedicalExaminationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
