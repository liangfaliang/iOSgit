//
//  ManageAddressTableViewCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/10/31.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "ManageAddressTableViewCell.h"

@implementation ManageAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.defaultBtn setImage:[UIImage imageNamed:@"morendizhi"] forState:UIControlStateSelected];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDefaultblock:(myblock)defaultblock{
    _defaultblock  =defaultblock;

}
- (IBAction)defaultClick:(id)sender {
    if (_defaultblock) {
        _defaultblock(0);
    }
}
- (IBAction)editingClick:(id)sender {
    if (_defaultblock) {
        _defaultblock(1);
    }
}
- (IBAction)deleteClick:(id)sender {
    if (_defaultblock) {
        _defaultblock(2);
    }
}

@end
