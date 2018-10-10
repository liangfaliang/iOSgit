//
//  SignInTableViewCell.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/1.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "SignInTableViewCell.h"

@implementation SignInTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.typeLb.layer.cornerRadius = 8;
    self.typeLb.layer.masksToBounds = YES;
    [self.picture ddy_AddTapTarget:self action:@selector(pictureClick)];
}
-(void)setModel:(SignModel *)model{
    _model = model;
    self.timeLb.text = (model.time && model.time.integerValue > 0) ? [UserUtils getShowDateWithTime:model.time dateFormat:@"HH:mm"] : @"";
    self.adressLb.text = model.place.address;
    NSArray *statusArr = @[@"不需要签退",@"正常",@"",@"缺勤",@"迟到",@"早退"];
    self.statusLb.text = statusArr[model.status];
    self.statusLb.textColor = [UIColor colorFromHexCode:model.status == 1 ? @"1ec7a1" :@"F13B29"];
    if (model.photo.length) {
        self.pictureHeight.constant = 100;
        [self.picture sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:PlaceholderImage];
    }else{
        self.picture.image = nil;
        self.pictureHeight.constant = 0;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)pictureClick{
    [UserUtils ShowImageView:@[self.picture] imageUrlArr:@[self.model.photo] index:0];
}
@end
