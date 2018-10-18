//
//  ImageLabelCollectionViewCell.m
//  TsApartment
//
//  Created by admin on 2018/6/15.
//  Copyright © 2018年 PmMaster. All rights reserved.
//

#import "ImageLabelCollectionViewCell.h"
//#import "NSString+YTString.h"
@implementation ImageLabelCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bageLb.layer.cornerRadius = 8;
    self.bageLb.layer.masksToBounds = YES;
    self.bageLb.adjustsFontSizeToFitWidth = YES; self.nameLb.adjustsFontSizeToFitWidth = YES;
}
-(void)setModel:(ImLbModel *)model{
    _model = model;
    if (model.imgurl && ![model.imgurl isValidUrl]) {
        self.iconIm.image = [UIImage imageNamed:model.imgurl];
    }else{
        [self.iconIm sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    }
    if (model.isSelect) {
        self.nameLb.textColor = JHMaincolor;
    }else{
        self.nameLb.textColor = JHmiddleColor;
    }
    self.nameLb.text = model.name;
    if ((model.bage.length && model.bage.integerValue > 0) || [model.bage isEqualToString:@"●"]) {
        self.bageLb.hidden = NO;
        NSString *bageStr = [model.bage copy];
        if (model.bage.integerValue >= 100) {
            bageStr = @"99+";
        }
        CGFloat wid = [bageStr selfadapUifont:self.bageLb.font weith:100].width;
        wid = wid > 16 ? wid + 10 : 16;
        self.bageLbWidth.constant = wid;
        self.bageLb.text = bageStr;
    }else{
        self.bageLb.hidden = YES;
    }
}
@end
