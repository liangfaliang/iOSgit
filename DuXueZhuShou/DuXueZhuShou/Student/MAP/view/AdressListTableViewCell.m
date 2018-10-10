//
//  AdressListTableViewCell.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/31.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AdressListTableViewCell.h"

@implementation AdressListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(placeModel *)model{
    _model = model;
    self.nameLb.text = model.name;
    self.adressLb.text = model.address;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
