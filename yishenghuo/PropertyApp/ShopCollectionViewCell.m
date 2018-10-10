//
//  ShopCollectionViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/8.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "ShopCollectionViewCell.h"

@implementation ShopCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)shopBTnClick:(id)sender {
    if (_block) {
        _block(nil);
    }
    
}
- (IBAction)buttonClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (_shopblock) {
        if (btn.tag == 440) {
            _shopblock(0);
        }else if (btn.tag == 441) {
            _shopblock(1);
        }else if (btn.tag == 442) {
            _shopblock(2);
        }
        
    }

    
}

-(void)setShopblock:(shopBlock)shopblock
{
    _shopblock = shopblock;
}
-(void)setBlock:(stroeBlock)block
{
    _block = block;

}

@end
