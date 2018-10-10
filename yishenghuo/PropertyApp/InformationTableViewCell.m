//
//  InformationTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/19.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "InformationTableViewCell.h"

@implementation InformationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageView.layer.masksToBounds = YES;
}
-(void)setCellWithDict:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath{
    self.nameLb.text = dict[@"author"];
    self.titleLb.text = dict[@"title"];
    self.timeLb.text = dict[@"add_time"];
    [self.iconimage sd_setImageWithURL:[NSURL URLWithString:dict[@"index_img"]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
