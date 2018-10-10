//
//  PromotionsTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/8/14.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "PromotionsTableViewCell.h"

@implementation PromotionsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCellWithDict:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath{
    self.contentLb.text = dict[@"title"];
    self.nameLb.text = dict[@"shop_name"];
    self.timeLb.text = dict[@"add_time"];
    [self.iconIm sd_setImageWithURL:[NSURL URLWithString:dict[@"imgurl"]] placeholderImage:[UIImage imageNamed:@""]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
