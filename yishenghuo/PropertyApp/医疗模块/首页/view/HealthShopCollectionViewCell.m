//
//  HealthShopCollectionViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/7/25.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "HealthShopCollectionViewCell.h"

@implementation HealthShopCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius =3;
    self.layer.masksToBounds = YES;
}
-(void)setModel:(MeGoodModel *)model{
    _model = model;
    [self.picture sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    self.naneLb.text = model.name;
    self.priceLb.text = [NSString stringWithFormat:@"￥%@",model.shop_price];
}
@end
