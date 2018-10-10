
//
//  ShopSupermarketlCollectionViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/6/15.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "ShopSupermarketlCollectionViewCell.h"

@implementation ShopSupermarketlCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.countLb.minusBtn.hidden = YES;
    self.oldPriceLb.strikeThroughEnabled = YES;
}

@end
