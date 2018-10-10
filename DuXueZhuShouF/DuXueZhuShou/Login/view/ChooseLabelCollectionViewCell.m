//
//  ChooseLabelCollectionViewCell.m
//  AppProject
//
//  Created by admin on 2018/5/22.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ChooseLabelCollectionViewCell.h"

@implementation ChooseLabelCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.layer.borderColor = [JHBorderColor CGColor];
    self.contentView.layer.borderWidth = 1;
}

@end
