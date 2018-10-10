
//
//  ServiceHotlineTableViewCell.m
//  PropertyApp
//
//  Created by admin on 2018/9/7.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "ServiceHotlineTableViewCell.h"

@implementation ServiceHotlineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCellWithDict:(NSDictionary *)dict indexPath:(NSIndexPath *)indexPath{
    self.nameLb.text = dict[@"de_name"] ? dict[@"de_name"] :@"";
    self.telLb.text = dict[@"de_tel"] ? dict[@"de_tel"] :@"";
    self.adressLb.text = dict[@"de_addr"] ? dict[@"de_addr"] :@"";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
