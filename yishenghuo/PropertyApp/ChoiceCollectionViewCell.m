//
//  ChoiceCollectionViewCell.m
//  shop
//
//  Created by 梁法亮 on 16/8/18.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "ChoiceCollectionViewCell.h"
#import "IndexBtn.h"
@implementation ChoiceCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
//        _imageicon = [[UIImageView alloc]init];
//        
//        [self.contentView addSubview:_imageicon];
        


        
    }

    return self;
}

-(void)setModel:(ChoiceModel *)model{
    _model = model;
    if (_scrollview == nil) {
        _scrollview = [[UIScrollView alloc]initWithFrame:self.bounds];
    }
    [self.contentView addSubview:_scrollview];
    [_scrollview removeAllSubviews];
    [_titleLb removeFromSuperview];
    _titleLb = nil;
    _titleLb = [[YYLabel alloc]init];
    if (_titleLb == nil) {
        
    }
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld.%@",(long)self.item + 1,model.subject_name]];
    text.yy_font = [UIFont boldSystemFontOfSize:13];
    NSString *attstring = @"";
    NSRange range =[[text string]rangeOfString:attstring];
    text.yy_lineSpacing = 10;
    text.yy_color = JHdeepColor;
    
    [text yy_setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16] range:range];
    YYTextBorder *border = [YYTextBorder new];
    border.strokeColor = JHMaincolor;
    border.strokeWidth = 1;
//    border.lineStyle = YYTextLineStylePatternSolid;
    border.cornerRadius = 3;
//    border.insets = UIEdgeInsetsMake(0, -2, 0, -2);
//    [text yy_setTextBorder:border range:range];
//    [text yy_setColor:JHMaincolor range:range];
    _titleLb.attributedText = text;
    _titleLb.numberOfLines = 0;
    [_scrollview addSubview:_titleLb];
    CGSize titlesize = [model.subject_name selfadapUifont:[UIFont fontWithName:@"Helvetica-Bold" size:16] weith:30];
//    [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(30);
//        make.left.offset(15);
//        make.right.offset(-15);
//        make.height.offset(titlesize.height + 15);
//    }];
    _titleLb.frame = CGRectMake(15, 30, SCREEN.size.width - 30, titlesize.height + 15);
    UIImage *im = [UIImage imageNamed:@"A"];
    NSArray *seleArr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N"];
    CGFloat HH = titlesize.height + 50;
    NSString *placeholder = @"请填不满意原因";
    for (int i = 0; i < model.option.count; i ++) {
        OptionModel *opmo = model.option[i];
        if ([model.is_radio isEqualToString:@"1"]) {
            if (opmo.opinion == 1) {
                placeholder = [NSString stringWithFormat:@"请填写%@原因",opmo.name];
            }
        }else{
            if (opmo.opinion == 1) {
                if ([opmo.is_check isEqualToString:@"1"]) {
//                    placeholder = opmo.name;
                }
            }
            
        }
        IndexBtn *allBtn = [[IndexBtn alloc]initWithFrame:CGRectMake(30,  HH, SCREEN.size.width - 45, im.size.height + 20)];
        allBtn.index = i;
        [allBtn addTarget:self action:@selector(btnselectClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollview addSubview:allBtn];
        [allBtn removeAllSubviews];
        UIButton * seleBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,  0, im.size.width, im.size.height)];

        seleBtn.userInteractionEnabled = NO;
        if ([opmo.is_check isEqualToString:@"1"]) {
            [seleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [seleBtn setBackgroundImage:[UIImage imageNamed:@"A"] forState:UIControlStateNormal];
        }else{
            [seleBtn setTitleColor:JHColor(102, 102, 102) forState:UIControlStateNormal];
            [seleBtn setBackgroundImage:[UIImage  imageNamed:@"AA"] forState:UIControlStateNormal];
        }
        [seleBtn setTitle:seleArr[i] forState:UIControlStateNormal];
        seleBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [allBtn addSubview:seleBtn];
        [seleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.centerY.equalTo(allBtn.mas_centerY).offset(0);
            make.width.offset(im.size.width);
            make.height.offset(im.size.height);
        }];
//        UILabel *lb = [self viewWithTag:10000 + i];
//        if (lb == nil) {
        UILabel *lb = [[UILabel alloc]init];
        lb.textColor = JHdeepColor;
        lb.numberOfLines = 0;
        lb.font = [UIFont systemFontOfSize:15];
//        }


        lb.text = opmo.name;

        [allBtn addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(seleBtn.mas_right).offset(10);
            make.centerY.equalTo(seleBtn.mas_centerY).offset(0);
            make.right.offset(15);
            
        }];
        
        CGSize lbsize = [lb.text selfadap:15 weith:55 + im.size.width];
        allBtn.frame = CGRectMake(30,  HH, SCREEN.size.width - 45, im.size.height > lbsize.height ?(im.size.height  + 20): (lbsize.height + 20));
        if (lbsize.height > im.size.height) {
            HH += lbsize.height + 20;
        }else{
            
          HH += im.size.height + 20;
        }
        
        
    }
    if (_opinionView == nil) {
        _opinionView = [[UIView alloc]initWithFrame:CGRectMake(0, HH + 30, SCREEN.size.width, 130)];
        
        _opinionLb = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN.size.width - 20, 30)];
        _opinionLb.text = @"请填写原因（必填项）";
        
        _opinionLb.font = [UIFont systemFontOfSize:15];
        _opinionLb.textColor = JHshopMainColor;
        _opinionText = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(60, 30, SCREEN.size.width - 100, 100)];
//        _opinionText = [[HPGrowingTextView alloc]init];
        _opinionText.backgroundColor = JHbgColor;
        _opinionText.layer.borderWidth = 1;
        _opinionText.layer.borderColor = [JHBorderColor CGColor];
        _opinionText.layer.cornerRadius = 5;
        _opinionText.layer.masksToBounds = YES;
        _opinionText.font = [UIFont systemFontOfSize:15];
//        _opinionText.placeholder = [NSString stringWithFormat:@"%@(必填项)",placeholder];
//        _opinionText.placeholderColor = [UIColor redColor];
        _opinionText.animateHeightChange = NO;
//        _opinionText.isScrollable = NO;
//        _opinionText.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
        _opinionText.minHeight = 100;

        
        _opinionVline = [[UIView alloc]init];
        _opinionVline.backgroundColor = JHbgColor;
    }
    [_scrollview addSubview:_opinionView];
    [_opinionView addSubview:_opinionLb];
    _opinionText.text = model.opinioncontent;
    [_opinionView addSubview:_opinionText];
    [_opinionText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(30);
        make.right.offset(-10);
        make.height.offset(100);
    }];
    [_opinionView addSubview:_opinionVline];
    [_opinionVline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_opinionText.mas_width);
        make.top.equalTo(_opinionText.mas_bottom);
        make.centerX.equalTo(_opinionText.mas_centerX);
        make.height.offset(1);
    }];
    _opinionView.hidden = YES;
    for (int i = 0; i < _model.option.count; i ++) {
        OptionModel *opmo = model.option[i];
        if ([_model.is_radio isEqualToString:@"1"]) {
            if ([opmo.is_check isEqualToString:@"1"]) {
                if (opmo.opinion == 1) {
                    _opinionView.hidden = NO;
                }
            }
            
        }else{
            if ([opmo.is_check isEqualToString:@"1"]) {
                if (opmo.opinion == 1) {
                    _opinionView.hidden = NO;
                }
            }
        }
        
        
    }
    
    _scrollview.contentSize = CGSizeMake(0, HH + 160 > self.height ? HH + 160 :self.height);
    
}

-(void)btnselectClick:(IndexBtn *)btn{

    OptionModel *opmo = _model.option[btn.index];
    if (_selectblock) {
        _selectblock(opmo.id,btn.index,_model.is_radio);
    }

    
    

}

-(void)setSelectblock:(selectBlock)selectblock{

    _selectblock = selectblock;

}

@end
