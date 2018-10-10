//
//  CastVoteResutTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/18.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "CastVoteResutTableViewCell.h"

@implementation CastVoteResutTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backView.layer.borderColor = [JHBorderColor CGColor];
    self.backView.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
