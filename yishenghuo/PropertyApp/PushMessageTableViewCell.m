//
//  PushMessageTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/12/27.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "PushMessageTableViewCell.h"

@implementation PushMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.markView.layer.cornerRadius = 5;
    self.markView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
