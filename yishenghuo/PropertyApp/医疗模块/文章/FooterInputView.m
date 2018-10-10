//
//  FooterInputView.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/5/2.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "FooterInputView.h"

@implementation FooterInputView

-(UITextField *)tf{
    if (_tf == nil) {
        _tf = [[UITextField alloc]init];
        _tf.delegate = self;
        UIView *leftview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        _tf.leftView = leftview;
        _tf.leftViewMode = UITextFieldViewModeAlways;
    }
    return _tf;
}
-(NSMutableArray *)btnArr{
    if (_btnArr == nil) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}
-(NSMutableArray *)btnSelectArr{
    if (_btnSelectArr == nil) {
        _btnSelectArr = [NSMutableArray array];
    }
    return _btnSelectArr;
}
#pragma mark textfileddelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    for (UIView *subview in self.btnArr) {
        [subview removeFromSuperview];
    }
    [self layoutSubviews];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    for (UIView *subview in self.btnSelectArr) {
        [subview removeFromSuperview];
    }
    textField.text = @"";
    [self layoutSubviews];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    NSMutableArray *temArr = self.btnArr;
    if ([self.tf isFirstResponder]) {
        temArr = self.btnSelectArr;
    }
    CGFloat xx = 10;
    if (temArr.count) {
        int i = 0;
        for (UIView *subview in temArr) {
            [self addSubview:subview];
            subview.frame = CGRectMake(self.width - subview.width - xx, 0, subview.width, self.height);
            xx += subview.width+ 10;
            i ++;
        }
    }
    [self addSubview:self.tf];
    [_tf mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(10);
        make.bottom.offset(-10);
        make.right.offset(-xx);
    }];
}
-(void)removeAllview{
    for (UIView *subview in self.btnArr) {
        [subview removeFromSuperview];
    }
//    [self.btnArr removeAllObjects];
}
@end
