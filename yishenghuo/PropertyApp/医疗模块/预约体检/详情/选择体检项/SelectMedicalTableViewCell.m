//
//  SelectMedicalTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/17.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "SelectMedicalTableViewCell.h"

@implementation SelectMedicalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.selectBtn setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];//
    [self.selectBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
