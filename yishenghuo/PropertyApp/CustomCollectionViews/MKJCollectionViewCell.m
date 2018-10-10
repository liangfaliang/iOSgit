//
//  MKJCollectionViewCell.m
//  PhotoAnimationScrollDemo
//
//  Created by MKJING on 16/8/9.
//  Copyright © 2016年 MKJING. All rights reserved.
//

#import "MKJCollectionViewCell.h"

@implementation MKJCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backView.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
//    self.backView.layer.shadowColor = [UIColor clearColor].CGColor;
//    self.backView.layer.shadowOpacity = 0.7;
//    self.backView.layer.shadowRadius = 5.0f;
//    self.backView.layer.shadowOffset = CGSizeMake(2, 6);
    self.heroImageVIew.layer.cornerRadius = 25.0;
    self.heroImageVIew.layer.masksToBounds = YES;
    self.nameLb.adjustsFontSizeToFitWidth = YES;
}

@end
