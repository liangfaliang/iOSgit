//
//  MyAnswerListTableViewCell.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/2.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "MyAnswerListTableViewCell.h"

@implementation MyAnswerListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(AnswerListModel *)model{
    _model = model;
    self.nameLb.text = model.title;
    self.timeLb.text = [UserUtils getShowDateWithTime:model.create_time dateFormat:@"yyyy.MM.dd"];
    if (model.is_read && model.is_read.integerValue > 0) {
        self.bageLb.hidden = NO;
    }else{
        self.bageLb.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
