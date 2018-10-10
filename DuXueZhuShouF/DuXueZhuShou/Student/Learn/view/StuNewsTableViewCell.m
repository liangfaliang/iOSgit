//
//  StuNewsTableViewCell.m
//  DuXueZhuShou
//
//  Created by admin on 2018/7/26.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "StuNewsTableViewCell.h"

@implementation StuNewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLb.font = SYS_FONTBold(16);
    self.clickLb.strikeThroughEnabled = YES;
    self.clickLb.strikePosition = strikeThroughBottom;
    self.clickLb.strikeThroughColor = JHMaincolor;
}

- (void)setModel:(StuNewsModel *)model{
    _model = model;
    self.titleLb.text = model.title;
    self.contentLb.text = model.message;
    self.clickLb.text = [UserUtils getShowDateWithTime:model.create_time dateFormat:@"yyyy.MM.dd"];
    if (model.is_read.integerValue == 0) {
        self.contentView.alpha = 1;
    }else{
        self.contentView.alpha = 0.7;
    }
}

@end
