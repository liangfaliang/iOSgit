//
//  ImageLabelCollectionViewCell.m
//  TsApartment
//
//  Created by admin on 2018/6/15.
//  Copyright © 2018年 PmMaster. All rights reserved.
//

#import "ImageLabelCollectionViewCell.h"
#import "NSString+YTString.h"
@implementation ImageLabelCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.layer.masksToBounds = YES;
    self.nameLb.adjustsFontSizeToFitWidth = YES;
}
-(void)setModel:(ImLbModel *)model{
    if (model.cornerRadius) {
        self.contentView.layer.cornerRadius = [model.cornerRadius floatValue];
    }else{
        self.contentView.layer.cornerRadius = 0;
    }
    if (model.backcolor) {
        self.contentView.backgroundColor = [UIColor colorFromHexCode:model.backcolor];
    }else{
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    if (model.textcolor) {
        self.nameLb.textColor = [UIColor colorFromHexCode:model.textcolor];
    }else{
        self.nameLb.textColor = JHmiddleColor;
    }
    if (model.backimage) {
        self.contentView.backgroundImage = [UIImage imageNamed:model.backimage];
    }else{
        self.contentView.backgroundImage = nil;
    }
    _model = model;
    if (model.imgurl.length && ![model.imgurl isValidUrl]) {
        self.iconIm.image = [UIImage imageNamed:model.imgurl];
    }else if(model.imgurl.length){
        [self.iconIm sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }else{
        self.iconIm.image = nil;
    }
    
    self.nameLb.text = model.name;
}
@end
