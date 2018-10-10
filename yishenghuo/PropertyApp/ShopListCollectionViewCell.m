//
//  ShopListCollectionViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/11.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "ShopListCollectionViewCell.h"

@implementation ShopListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imagePic.layer.masksToBounds = YES;
//    self.oldPrice.adjustsFontSizeToFitWidth = YES;
    self.oldPrice.strikeThroughEnabled = YES;
}
- (IBAction)cartClick:(id)sender {
    if (_block) {
        _block(nil);
    }

}
-(void)setBlock:(blockClick)block{
    
    _block = block;
}
@end
