
//
//  AddSignInTableViewCell.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/14.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "AddSignInTableViewCell.h"

@implementation AddSignInTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textview.delegate = self;
    [self.tfBrfore addTarget:self action:@selector(tfBrforeDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.tfAfter addTarget:self action:@selector(tfAfterDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.fixedBtn setImage:[UIImage imageNamed:@"choosed"] forState:UIControlStateSelected];
    [self.freeBtn setImage:[UIImage imageNamed:@"choosed"] forState:UIControlStateSelected];
    self.fixedBtn.selected =YES;
    
}
-(void)setModel:(AttendSubmitModel *)model{
    _model = model;
    self.textview.text = model.remark;
    if (model.mode == 1) {
        self.bottomView.hidden = NO;
        self.bottomviewHeight.constant = 50;
        self.fixedBtn.selected = YES;
        self.freeBtn.selected = NO;
    }else{
        self.bottomView.hidden = YES;
        self.bottomviewHeight.constant = 0;
        self.fixedBtn.selected = NO;
        self.freeBtn.selected = YES;
    }
    self.tfBrfore.text = model.allowTimeBeforeSignIn.integerValue ? model.allowTimeBeforeSignIn :@"";
    self.tfAfter.text = model.allowTimeAfterSignOut.integerValue ? model.allowTimeAfterSignOut :@"";
    if (model.remark.length <= 200) {
        self.numLb.text = [NSString stringWithFormat:@"%d/200",200 - (int)model.remark.length];
    }else{
        self.numLb.text = @"";
    }
    
}
-(void)tfBrforeDidChange :(UITextField *)TextField{
    if (self.model) self.model.allowTimeBeforeSignIn = TextField.text;
}
-(void)tfAfterDidChange :(UITextField *)TextField{
    if (self.model) self.model.allowTimeAfterSignOut = TextField.text;
}
#pragma mark TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    CGFloat length = textView.text.length;
    if (length > 200) {//3行了  两行52 三行70
        while (length > 200) {
            textView.text = [textView.text substringToIndex:[textView.text length]-1];
            length = textView.text.length;
        }
    }
    SYS_FONT(0);
    _model.remark = textView.text;
    self.numLb.text = [NSString stringWithFormat:@"%d/200",200 - (int)length];
}
- (IBAction)btnClick:(UIButton *)sender {
    sender.selected = YES;
    UIButton *btn = [self.contentView viewWithTag:3 - sender.tag];
    btn.selected = NO;
    if (sender == self.fixedBtn) {
        self.model.mode = 1;
        self.bottomView.hidden = NO;
        self.bottomviewHeight.constant = 50;
    }else{
         self.model.mode = 2;
        self.bottomView.hidden = YES;
        self.bottomviewHeight.constant = 0;
    }
    if (self.btnclickBlock) {
        self.btnclickBlock(sender.tag - 1);
    }
}

@end
