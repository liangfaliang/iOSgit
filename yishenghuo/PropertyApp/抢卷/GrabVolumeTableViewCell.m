//
//  GrabVolumeTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/1/4.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "GrabVolumeTableViewCell.h"

@implementation GrabVolumeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.picture.layer.masksToBounds = YES;
    self.leftBackview.backgroundImage = [UIImage imageNamed:@"zuobanbian_yhq"];
    self.rightBackview.backgroundImage = [UIImage imageNamed:@"youbanbian_yhq"];
    self.hourLb.layer.borderWidth = 1;
    self.hourLb.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.hourLb.layer.cornerRadius = 3;
    self.hourLb.layer.masksToBounds = YES;
    
    self.minuteLb.layer.borderWidth = 1;
    self.minuteLb.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.minuteLb.layer.cornerRadius = 3;
    self.minuteLb.layer.masksToBounds = YES;
    
    self.secondLb.layer.borderWidth = 1;
    self.secondLb.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.secondLb.layer.cornerRadius = 3;
    self.secondLb.layer.masksToBounds = YES;
    
}
- (IBAction)clickSender:(id)sender {
    if (_block) {
        _block();
    }
}
-(void)setBlock:(rushBlock)block{
    _block = block;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
