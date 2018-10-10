//
//  progressView.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/1/4.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "progressView.h"

@implementation progressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 */
-(instancetype)init{
     if (self = [super init]) {
         [self initialization];
     }
     return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self initialization];
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialization];
    }
    return self;
}
-(void)initialization{
    _scale= 0;
    if (self.colorView == nil) {
        self.colorView = [[UIView alloc]init];
    }
    if (self.leftLb == nil) {
        self.leftLb = [[UILabel alloc]init];
    }
    if (self.rightLb == nil) {
        self.rightLb = [[UILabel alloc]init];
    }
    [self addSubview:self.colorView];
    [self addSubview:self.leftLb];
    [self addSubview:self.rightLb];
    self.layer.borderColor = [JHAssistRedColor CGColor];
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = self.height/2;
    self.layer.masksToBounds = YES;
    self.colorView.layer.borderColor = [JHAssistRedColor CGColor];
    self.colorView.layer.borderWidth = 1;
    self.colorView.layer.cornerRadius = self.height/2;
    self.colorView.layer.masksToBounds = YES;
}
-(void)layoutSubviews{
//    [self.colorView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.offset(0);
//        make.top.offset(0);
//        make.bottom.offset(0);
//        make.width.equalTo(self.mas_width).multipliedBy(_scale);
//    }];
    [self.leftLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(0);
        make.bottom.offset(0);
    }];
    [self.rightLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-10);
        make.top.offset(0);
        make.bottom.offset(0);
    }];
}
-(void)setScale:(CGFloat)scale{
    _scale = scale;
    [self.colorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        LFLog(@"scale:%f",scale);
        make.left.offset(0);
        make.top.offset(0);
        make.bottom.offset(0);
        make.width.equalTo(self.mas_width).multipliedBy(scale);
    }];
}
@end
