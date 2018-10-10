//
//  PeripheralBusinessTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/2/23.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "PeripheralBusinessTableViewCell.h"

@implementation PeripheralBusinessTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.xx_image.layer.masksToBounds= YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
