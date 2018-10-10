//
//  ShopCartTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/1.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "ShopCartTableViewCell.h"

@implementation ShopCartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.selectBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
    self.selectBtn.selected = NO;
    self.priceLabel.adjustsFontSizeToFitWidth = YES;
}
-(void)setBmodel:(GNRGoodsModel *)bmodel{
    _bmodel = bmodel;
    self.nameLabel.text = bmodel.goods_name;
    self.styleLabel.text = @"";
    self.priceLabel.text = bmodel.goods_price;
    self.countView.countLabel.text = bmodel.goods_number;
    [self.pictureIm sd_setImageWithURL:[NSURL URLWithString:bmodel.imgurl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)selectClick:(id)sender {
    UIButton *btn = (UIButton *)sender;

    if (btn.selected) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
    if (self.selectblock) {
        _selectblock(btn.selected,@"");
    }


}
-(void)setSelectblock:(selectBlock)selectblock{

    _selectblock = selectblock;
}


-(void)setModel:(ShopCartModel *)model{
    _model = model;
    
    
}

@end
