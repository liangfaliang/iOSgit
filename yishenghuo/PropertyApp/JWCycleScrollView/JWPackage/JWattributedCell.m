//
//  JWattributedCell.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/21.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "JWattributedCell.h"

@implementation JWattributedCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lflb0.layer.cornerRadius = 3;
    self.lflb0.layer.borderColor = [JHColor(255, 152, 103) CGColor];
    self.lflb0.layer.borderWidth = 1;
    self.lflb0.layer.masksToBounds = YES;
    
    self.lflb1.layer.cornerRadius = 3;
    self.lflb1.layer.borderColor = [JHColor(255, 152, 103) CGColor];
    self.lflb1.layer.borderWidth = 1;
    self.lflb1.layer.masksToBounds = YES;
}

@end
