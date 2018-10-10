//
//  DoctorInfoHeaderView.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/20.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "DoctorInfoHeaderView.h"

@implementation DoctorInfoHeaderView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.backView.layer.cornerRadius = 10;
    self.backView.layer.masksToBounds = NO;
    self.layer.masksToBounds = YES;
    self.nameLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
    [self.moreBtn setImage:[UIImage imageNamed:@"chakangengduoup"] forState:UIControlStateNormal];
    [self.moreBtn setImage:[UIImage imageNamed:@"chakangengduodown"] forState:UIControlStateSelected];
}

- (IBAction)moreBtnclick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_block) {
        _block(sender);
    }
}
-(void)setBlock:(void (^)(UIButton *))block{
    _block = block;
}
- (IBAction)backClick:(id)sender {
    UIViewController *vc = [self viewController];
    [vc.navigationController popViewControllerAnimated:YES];
}
@end
