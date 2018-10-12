//
//  MineHeaderNewView.m
//  PropertyApp
//
//  Created by admin on 2018/10/11.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "MineHeaderNewView.h"

@implementation MineHeaderNewView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.layer.cornerRadius = 10;
    self.backView.layer.shadowColor = JHmiddleColor.CGColor;
    self.backView.layer.shadowOffset = CGSizeMake(0, 2);
    self.backView.layer.shadowOpacity = 0.3;
    self.backView.layer.shadowRadius = 3;
    
    self.icon.layer.cornerRadius = 32;
    self.icon.layer.masksToBounds = YES;
}
+ (MineHeaderNewView *)view{
    return (MineHeaderNewView *)[[[NSBundle mainBundle]loadNibNamed:@"MineHeaderNewView" owner:self options:nil]firstObject];
}

@end
