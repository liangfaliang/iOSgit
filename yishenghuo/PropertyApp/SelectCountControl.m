//
//  SelectCountControl.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/10/18.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "SelectCountControl.h"

@implementation SelectCountControl

-(instancetype)init{

    if (self = [super init]) {
        [self initialize];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }

    return self;
}
-(void)initialize{
    self.isClick = YES;
    self.minusBtn = [[UIButton alloc]init];
    self.addBtn =[[UIButton alloc]init];
    self.countLabel = [[UITextField alloc]init];
    [self.countLabel addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.minusBtn];
    [self addSubview:self.addBtn];
    [self addSubview:self.countLabel];
    self.minusBtn.backgroundImage =[UIImage imageNamed:@"shuliangjian"];
    self.addBtn.backgroundImage =[UIImage imageNamed:@"shuliangjia"];
    self.countLabel.backgroundImage =[UIImage imageNamed:@"shuliangshuzi"];
    self.countLabel.delegate = self;
    self.countLabel.font = [UIFont systemFontOfSize:12];
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.text = @"1";
    self.countLabel.keyboardType = UIKeyboardTypePhonePad;
    [self.minusBtn addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.addBtn addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.bottom.offset(0);
        make.width.offset(self.frame.size.height);
    }];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.top.offset(0);
        make.bottom.offset(0);
        make.width.offset(self.frame.size.height);
    }];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addBtn.mas_left).offset(0);
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.equalTo(self.minusBtn.mas_right).offset(0);
    }];



}
-(void)buttonclick:(UIButton *)btn{
//    if (self.isClick) {
        if (_block) {
            if ([btn isEqual:self.addBtn]) {
                _block(YES);
            }else{
                _block(NO);
            }
        }
//    }


}

-(void)setBlock:(blockClick)block{

    _block = block;
}

-(void)textField1TextChange:(UITextField *)textFiled{
    LFLog(@"加减号：%@",textFiled.text);
}

@end
