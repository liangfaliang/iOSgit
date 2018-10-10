//
//  TextFiledLableTableViewCell.m
//  PropertyApp
//
//  Created by admin on 2018/7/20.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "TextFiledLableTableViewCell.h"
#import "ImTopBtn.h"
@implementation TextFiledLableTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
-(void)setModel:(TextFiledModel *)model{
    _model = model;
    self.nameLb.text = model.name;
    self.textfiled.placeholder = model.placeholder;
    if (model.label) {
        self.contentLb.hidden = NO;
        self.textfiled.hidden = YES;
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
        [self.contentLb NSParagraphStyleAttributeName:5];
    }else{
        self.contentLb.hidden = YES;
        self.textfiled.hidden = NO;
        self.textfiled.text = model.text;
        [self setRightim:model.rightim rView:nil];
        self.textfiled.enabled = model.enable ? YES : NO;
        if (model.textcolor) {
            self.textfiled.textColor = [UIColor colorFromHexCode:model.textcolor];
        }else{
            self.textfiled.textColor = JHdeepColor;
        }
    }
}
- (void)setRightim:(NSString *)rightim rView:(id )rView{
    if (rightim) {
        if (_model.selectBtn) {
            self.textfiled.rightView = self.selectTimeView;
            if (!_model.value) _model.value = @"无";
            for (ImTopBtn *sender in self.selectTimeView.subviews) {
                if (sender.index == ([_model.value isEqualToString:@"有"] ? 0 : 1)) {
                    sender.selected = YES;
                }else{
                    sender.selected = NO;
                }
            }
        }else{
            if ([rView isKindOfClass:[UIView class]]) {
                self.textfiled.rightView = rView;
            }else if ([rView isKindOfClass:[UIImage class]] || !rView) {
                rView = rView?rView:[UIImage imageNamed:@"gerenzhongxinjiantou"];
                self.rightView.image = rView;
                self.rightView.frame = CGRectMake(0, 0, ((UIImage *)rView).size.width + 20, ((UIImage *)rView).size.height);
                self.textfiled.rightView = self.rightView;
            }
        }

        self.textfiled.rightViewMode = UITextFieldViewModeAlways;
    }else{
        self.textfiled.rightViewMode = UITextFieldViewModeNever;
    }
}
-(UIImageView *)rightView{
    if (_rightView == nil) {
        _rightView = [[UIImageView alloc]init];
        _rightView.contentMode = UIViewContentModeCenter;
    }
    return _rightView;
}
-(UIView *)selectTimeView{
    if (!_selectTimeView) {
        
        _selectTimeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW - 30 , 40)];
        for (int i = 0; i < 2; i ++) {
            ImTopBtn *btn = [[ImTopBtn alloc]initWithFrame:CGRectMake( _selectTimeView.width - i * 100 -100, 0, 100, _selectTimeView.height)];
            btn.index = i;
            [btn addTarget:self action:@selector(SelectTimeClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:@"xuanze"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
            [btn setTitleColor:JHdeepColor forState:UIControlStateSelected];
            [btn setTitleColor:JHdeepColor forState:UIControlStateNormal];
            [btn setTitle:[NSString stringWithFormat:@"   %@",i ? @"无" : @"有"] forState:UIControlStateNormal];
            [btn setTitle:[NSString stringWithFormat:@"   %@",i ? @"无" : @"有"] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [_selectTimeView addSubview:btn];
        }
    }
    return _selectTimeView;
}
-(void)SelectTimeClick:(ImTopBtn *)btn{
    btn.selected = YES;
    for (UIButton *sender in self.selectTimeView.subviews) {
        if (btn != sender) {
            sender.selected = NO;
        }
    }
    self.model.value = !btn.index ? @"有" : @"无";
    if (self.selectBtnBlock) {
        self.selectBtnBlock(btn.index);
    }
}
@end
