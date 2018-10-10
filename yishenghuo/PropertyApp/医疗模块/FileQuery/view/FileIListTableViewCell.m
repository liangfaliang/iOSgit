//
//  FileIListTableViewCell.m
//  PropertyApp
//
//  Created by admin on 2018/7/23.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "FileIListTableViewCell.h"

@implementation FileIListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconIm.layer.cornerRadius = 30;
    self.iconIm.layer.masksToBounds = YES;
}
-(void)setModel:(MyFileModel *)model{
    _model = model;
    [self.iconIm sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    self.nameLb.text = model.hp_name;
    self.timeLb.text = model.hp_recodate;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
