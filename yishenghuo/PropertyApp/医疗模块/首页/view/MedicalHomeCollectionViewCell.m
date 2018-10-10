//
//  MedicalHomeCollectionViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/7/24.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "MedicalHomeCollectionViewCell.h"

@implementation MedicalHomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backview.layer.cornerRadius = 5;
    self.backview.layer.masksToBounds = YES;
    self.backview.backgroundImage = [UIImage imageNamed:@"dangangrbg"];
    self.yuyueBtn.layer.cornerRadius = 12.5;
    self.yuyueBtn.layer.masksToBounds = YES;
    self.yuyueBtn.backgroundColor = JHMedicalColor;

}


@end
