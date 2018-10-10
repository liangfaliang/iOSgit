//
//  PregnantFileRecordTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/27.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "PregnantFileRecordTableViewCell.h"

@implementation PregnantFileRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentYYlb.numberOfLines = 0;
    [self.nameBtn setBackgroundImage:[UIImage imageNamed:@"chanjianjilu"] forState:UIControlStateNormal];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
