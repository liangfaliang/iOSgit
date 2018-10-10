//
//  ButtonsTableViewCell.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/20.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ButtonsTableViewCell.h"

@implementation ButtonsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)btnClick:(UIButton *)sender {
    if (self.clcikBlock) {
        self.clcikBlock(sender.tag - 1);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
