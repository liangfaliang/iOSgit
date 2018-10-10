//
//  ShopOtherTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/10/31.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "ShopOtherTableViewCell.h"

@implementation ShopOtherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentLb.textAlignment = NSTextAlignmentRight;
    self.contentLb.font = [UIFont systemFontOfSize:15];
    self.contentLb.textColor = JHdeepColor;
    self.MustImage.hidden = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
