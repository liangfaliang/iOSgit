//
//  PaymentAlreadyTableViewCell.m
//  PropertyApp
//
//  Created by admin on 2018/8/13.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "PaymentAlreadyTableViewCell.h"

@implementation PaymentAlreadyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.typeLb.layer.cornerRadius = 25;
    self.typeLb.layer.masksToBounds = YES;
}
-(void)setModel:(PayNewModel *)model{
    _model = model;
    self.priceLb.text = model.fa_total;
    self.timeLb.text = model.fa_date;
    self.typeLb.text = [NSString stringWithFormat:@"%@月",model.fa_month];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
