//
//  CityNewsTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/2/23.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "CityNewsTableViewCell.h"

@implementation CityNewsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconimage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
