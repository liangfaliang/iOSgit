//
//  ShopgoodsDecTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/10/31.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "ShopgoodsDecTableViewCell.h"

@implementation ShopgoodsDecTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.appraiseBtn.layer.cornerRadius = 5;
    self.appraiseBtn.layer.masksToBounds = YES;
    self.appraiseBtn.layer.borderColor = [JHshopMainColor CGColor];
    self.appraiseBtn.layer.borderWidth = 1;
    self.appraiseBtn.hidden = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)appraiseBtnClick:(id)sender {
    if (_block) {
        _block(nil);
    }
    
}

-(void)setBlock:(appraiseBlock)block{

    _block = block;
}
@end
