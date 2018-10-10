//
//  PunchOperationTableViewCell.m
//  DuXueZhuShou
//
//  Created by admin on 2018/7/30.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "PunchOperationTableViewCell.h"

@implementation PunchOperationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconIm.layer.cornerRadius = 25;
    self.iconIm.layer.masksToBounds = YES;
}
-(void)setOmodel:(OperateListModel *)omodel{
    _omodel = omodel;
    [self.iconIm sd_setImageWithURL:[NSURL URLWithString:omodel.subject_images] placeholderImage:PlaceholderImage];
    self.contentLb.text = omodel.content;
    self.timeLb.text = [UserUtils getShowDateWithTime:omodel.create_time dateFormat:@"HH:mm"];

    if ([UserUtils getUserRole] == UserStyleStudent) {
        self.bageLb.hidden = omodel.is_read ;
        if (!omodel.is_read) {
            self.statusLb.text = @"未读";
        }else{
            NSArray *statuArr = @[@"未打卡",@"已打卡",@"已评价"];
            if (omodel.status > 0 && omodel.status < 4) {
                self.statusLb.text = statuArr[omodel.status - 1];
            }else{
                self.statusLb.text = @"";
            }
        }
        if (!omodel.is_read || omodel.status== 1) {
            self.statusLb.textColor = JHMaincolor;
        }else{
            self.statusLb.textColor = JHmiddleColor;
        }
    }else if ([UserUtils getUserRole] == UserStyleInstructor){
        if (omodel.status == 3) {//已送达
            self.statusLb.text = @"已送达";
            self.statusLb.hidden = NO;
        }else{
            self.statusLb.text = @"";
            self.statusLb.hidden = YES;
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
