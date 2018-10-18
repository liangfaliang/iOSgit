//
//  LeaveListTableViewCell.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/7.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "LeaveListTableViewCell.h"

@implementation LeaveListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLb.adjustsFontSizeToFitWidth = YES;
    self.typeLb.layer.cornerRadius = 20;
    self.typeLb.layer.masksToBounds = YES;
}
-(void)setModel:(LeaveSubModel *)model{
    _model = model;
    self.typeLb.backgroundColor = [UIColor colorFromHexCode:model.color];
    self.typeLb.text = model.category;
    self.nameLb.text = model.username;
    self.timeLb.text = [NSString stringWithFormat:@"%@-%@",[UserUtils getShowDateWithTime:model.start_time dateFormat:@"MM.dd HH:mm"],[UserUtils getShowDateWithTime:model.end_time dateFormat:@"MM.dd HH:mm"]];
    NSArray *arr = nil;
    if ([UserUtils getUserRole] == UserStyleStudent) {
        arr = @[@"审核中",@"审核拒绝",@"审核通过"];
    }else if ([UserUtils getUserRole] == UserStyleInstructor){
        arr = @[@"未审核",@"拒绝",@"同意"];
    }
    
    NSArray *colorArr = @[@"3995FF",@"FA4041",@"666666"];
    if ( model.status > 0 && model.status <= arr.count) {
        if ([UserUtils getUserRole] == UserStyleInstructor && model.status == 1 &&  model.is_old == 1) {
            self.stutasLb.text = @"已过期";
            self.stutasLb.textColor = JHmiddleColor;
        }else{
            self.stutasLb.text = arr[model.status-1];
            self.stutasLb.textColor =[UIColor colorFromHexCode:colorArr[model.status-1]];
        }
        
    }else{
        self.stutasLb.text =@"";
    }
    if ([UserUtils getUserRole] == UserStyleInstructor && model.is_read && model.is_read.integerValue == 0 ) {
        self.stutasLb.attributedText = [[NSString stringWithFormat:@"%@ ● ",self.stutasLb.text] AttributedString:@"●" backColor:nil uicolor:JHAssistRedColor uifont:[UIFont systemFontOfSize:15]];
    }else{
        self.stutasLb.attributedText =  [[NSMutableAttributedString alloc]initWithString:self.stutasLb.text];
    }
//
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
