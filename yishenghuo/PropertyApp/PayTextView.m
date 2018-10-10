//
//  PayTextView.m
//  PropertyApp
//
//  Created by admin on 2018/8/13.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "PayTextView.h"
#import "UIView+TYAlertView.h"
@implementation PayTextView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    UILabel *lb = [UILabel initialization:CGRectMake(0, 0, 40, 40) font:[UIFont systemFontOfSize:15] textcolor:JHdeepColor numberOfLines:0 textAlignment:0];
    lb.text = @"元";
    self.textF.rightView = lb;
    self.textF.rightViewMode = UITextFieldViewModeAlways;
    self.backview.layer.cornerRadius = 5;
    self.backview.layer.masksToBounds = YES;
    [self.cancelBtn setViewBorderColor:JHBorderColor borderWidth:1];
    [self.sureBtn setViewBorderColor:JHBorderColor borderWidth:1];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)btnclick:(UIButton *)sender {
    [self hideView];
    if (self.btnClickBlock) {
        self.btnClickBlock(sender.tag == 1 ? YES : NO, self.textF.text);
    }
}

@end
