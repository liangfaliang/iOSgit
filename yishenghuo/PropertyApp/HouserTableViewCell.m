//
//  HouserTableViewCell.m
//  shop
//
//  Created by 梁法亮 on 16/7/19.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "HouserTableViewCell.h"

@implementation HouserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconimage.layer.cornerRadius = 3;
    self.iconimage.clipsToBounds  = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end