//
//  SelectTimeView.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/8.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "SelectTimeView.h"

@implementation SelectTimeView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.leftTopView.titleLb.text = @"请选择";
    self.rightTopView.titleLb.text = @"请选择";
    self.leftBottomView.titleLb.text = @"请选择";
    self.sureBtn.layer.cornerRadius = 3;
    self.sureBtn.layer.masksToBounds = YES;

}
+ (SelectTimeView *)view{
    return (SelectTimeView *)[[[NSBundle mainBundle]loadNibNamed:@"SelectTimeView" owner:self options:nil]firstObject];
}
- (IBAction)tapClick:(UITapGestureRecognizer *)tap {
    LFLog(@"%ld",tap.view.tag);
    if (self.clickBlock) {
        self.clickBlock(tap.view.tag);
    }
}
- (IBAction)queryClick:(UIButton *)sender {
    if (self.clickBlock) {
        self.clickBlock(sender.tag);
    }
}

@end
