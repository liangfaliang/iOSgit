//
//  ArchiveDoctorTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/20.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "ArchiveDoctorTableViewCell.h"

@implementation ArchiveDoctorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.reserveBtn.layer.cornerRadius = 3;
    self.reserveBtn.layer.masksToBounds = YES;
    self.nameLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
