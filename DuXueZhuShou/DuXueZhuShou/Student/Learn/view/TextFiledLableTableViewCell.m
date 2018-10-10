//
//  TextFiledLableTableViewCell.m
//  PropertyApp
//
//  Created by admin on 2018/7/20.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "TextFiledLableTableViewCell.h"
#import "UIButton+WebCache.h"
@implementation TextFiledLableTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    LFLog(@"intrinsicContentSize:%@",NSStringFromCGSize(self.nameBtn.intrinsicContentSize)) ;
    self.textfiled.delegate = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(contentLbClick:)];
    [self.contentLb addGestureRecognizer:tap];
    self.nameBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.textfiled addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
}
-(void)textField1TextChange:(UITextField *)textField{
    if (self.model) {
        self.model.text = textField.text;
        self.model.value = textField.text;
    }
    if (self.TextChangeBlock) {
        self.TextChangeBlock(textField.text);
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (_model && _model.unedit) {
        return NO;
    }
    return YES;
}
-(void)setModel:(TextFiledModel *)model{
    _model = model;
//    self.nameLb.text = model.name;
    
    self.textfiled.placeholder = model.placeholder;
    
    if (model.leftim && ![model.leftim isValidUrl]) {
        [self.nameBtn setTitle:model.name forState:UIControlStateNormal];
        if ([model.leftim isValidUrl]) {
            [self.nameBtn sd_setImageWithURL:[NSURL URLWithString:model.leftim] forState:UIControlStateNormal];
        }else{
            [self.nameBtn setImage:[UIImage imageNamed:model.leftim] forState:UIControlStateNormal];
        }
        [self.nameBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    }else{
        [self.nameBtn setTitleEdgeInsets:UIEdgeInsetsZero];
        [self.nameBtn setTitle:model.name forState:UIControlStateNormal];
        [self.nameBtn setImage:nil forState:UIControlStateNormal];
    }
    self.textfiled.enabled = model.enable ? YES : NO;
    if (model.label) {
        self.contentLb.hidden = NO;

        
        self.contentLb.text = model.text;
        if (model.textcolor) {
            self.contentLb.textColor = [UIColor colorFromHexCode:model.textcolor];
        }else{
            self.contentLb.textColor = JHdeepColor;
        }
        if (model.name.length) {
            self.contentLbLeft.constant = 15;
        }else{
            self.contentLbLeft.constant = 0;
        }
        if (model.rightim) {
            self.contentLbRight.constant = 45;
            self.textfiled.hidden = NO;
            [self setRightim:model.rightim rView:model.image];
        }else{
            self.contentLbRight.constant = 15;
            self.textfiled.hidden = YES;
        }
        [self.contentLb NSParagraphStyleAttributeName:5];
        [self.contentLb setNeedsLayout];
    }else{
        self.contentLb.hidden = YES;
        self.textfiled.hidden = NO;
        self.textfiled.text = model.text;
        [self setRightim:model.rightim rView:model.image];
        if (model.textcolor) {
            self.textfiled.textColor = [UIColor colorFromHexCode:model.textcolor];
        }else{
            self.textfiled.textColor = JHdeepColor;
        }
    }
    if (model.enable && model.unedit) {
        self.textfiled.unEffective = NO;
    }else{
        self.textfiled.unEffective = YES;
    }
}
- (void)setRightim:(NSString *)rightim rView:(id )rView{
    if (rightim) {
        if ([rView isKindOfClass:[UIView class]]) {
            self.textfiled.rightView = rView;
            if (!self.contentLb.hidden) self.contentLbRight.constant = self.textfiled.rightView.width_i + 25;
        }else if ([rView isKindOfClass:[UIImage class]] || [rView isKindOfClass:[NSString class]] || !rView) {
            UIImage * im = rView?([rView isKindOfClass:[UIImage class]] ? rView : [UIImage imageNamed:rView]):[UIImage imageNamed:@"enter"];
            self.rightView.image = im;
            self.rightView.frame = CGRectMake(0, 0, ((UIImage *)im).size.width + 20, ((UIImage *)im).size.height);
            if (!self.contentLb.hidden) self.contentLbRight.constant = self.rightView.width_i + 25;
            self.textfiled.rightView = self.rightView;
        }
        [self.textfiled setNeedsLayout];
        self.textfiled.rightViewMode = UITextFieldViewModeAlways;
    }else{
        self.textfiled.rightViewMode = UITextFieldViewModeNever;
    }
}
-(UIImageView *)rightView{
    if (_rightView == nil) {
        _rightView = [[UIImageView alloc]init];
        _rightView.contentMode = UIViewContentModeCenter;
        _rightView.userInteractionEnabled = YES;
        [_rightView ddy_AddTapTarget:self action:@selector(rightViewTap:)];
    }
    return _rightView;
}
- (IBAction)nameBtnClick:(id)sender {
    if (self.nameBtnBlock) {
        self.nameBtnBlock();
    }
}
- (void)contentLbClick:(UITapGestureRecognizer *)sender {
    LFLog(@"click");
    if (self.contentLbBlock) {
        self.contentLbBlock();
    }
}
-(void)rightViewTap:(UITapGestureRecognizer *)tap{
    if (self.rightViewBlock) {
        self.rightViewBlock();
    }
}
@end
