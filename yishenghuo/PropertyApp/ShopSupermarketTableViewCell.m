//
//  ShopSupermarketTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/6/14.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "ShopSupermarketTableViewCell.h"

@implementation ShopSupermarketTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.countLb.minusBtn.hidden = YES;
    self.oldPriceLb.strikeThroughEnabled = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
