//
//  MyCouponTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/8/17.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "MyCouponTableViewCell.h"

@implementation MyCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backviewWhite.backgroundImage = [UIImage imageNamed:@"youhuiquanbaise"];
    self.backviewYellow.backgroundImage = [UIImage imageNamed:@"youhuiquanbeijing"];
    self.factorLb.layer.cornerRadius = 3;
    self.factorLb.layer.masksToBounds = YES;
    self.priceLb.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
