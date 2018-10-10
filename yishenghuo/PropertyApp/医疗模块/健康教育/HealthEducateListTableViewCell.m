//
//  HealthEducateListTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/9.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "HealthEducateListTableViewCell.h"

@implementation HealthEducateListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setModel:(AritcleNewModel *)model{
    _model = model;
    self.contentLb.text = model.title;
    [self.readBtn setTitle:[NSString stringWithFormat:@"   %@",model.read_count] forState:UIControlStateNormal];
    [self.reviewBtn setTitle:[NSString stringWithFormat:@"   %@",model.comment_count] forState:UIControlStateNormal];
    [self.picture sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
}
-(void)setCellWithDict:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath{
    self.contentLb.text = dict[@"title"];
    [self.readBtn setTitle:[NSString stringWithFormat:@"   %@",dict[@"read_count"]] forState:UIControlStateNormal];
    [self.reviewBtn setTitle:[NSString stringWithFormat:@"   %@",dict[@"comment_count"]] forState:UIControlStateNormal];
    [self.picture sd_setImageWithURL:[NSURL URLWithString:dict[@"imgurl"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
