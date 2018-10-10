//
//  GoodsReviewTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/10/20.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "GoodsReviewTableViewCell.h"

@implementation GoodsReviewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.xxBackview.layer.masksToBounds = YES;
    self.iconImage.layer.cornerRadius = 15;
    self.iconImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)imagebtnclick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    if (_block) {
        _block(btn.tag - 1000);
    }
    
}
- (IBAction)likeBtnClick:(id)sender {
    if (self.likeBlock) {
        self.likeBlock();
    }
}

-(void)setBlock:(imageBlock)block{

    _block = block;
}

@end
