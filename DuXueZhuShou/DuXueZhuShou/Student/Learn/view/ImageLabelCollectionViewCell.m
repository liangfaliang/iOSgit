//
//  ImageLabelCollectionViewCell.m
//  TsApartment
//
//  Created by admin on 2018/6/15.
//  Copyright © 2018年 PmMaster. All rights reserved.
//

#import "ImageLabelCollectionViewCell.h"

@implementation ImageLabelCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(ImLbModel *)model{
    _model = model;
    if (model.imgurl && ![model.imgurl isValidUrl]) {
        self.iconIm.image = [UIImage imageNamed:model.imgurl];
    }else{
        [self.iconIm sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }
    self.nameLb.text = model.name;
}
@end
