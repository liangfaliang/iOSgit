//
//  IntegralRecordTableViewCell.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/9.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "IntegralRecordTableViewCell.h"

@implementation IntegralRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(IgRecordModel *)model{
    _model = model;
    self.nameLb.text = model.summary;
    self.timeLb.text = [UserUtils getShowDateWithTime:model.create_time dateFormat:@"yyyy.MM.dd"];
    self.integralLb.text = [NSString stringWithFormat:@"+%@积分",model.score];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
