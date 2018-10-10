//
//  LbRightImLeftView.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/8.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "LbRightImLeftView.h"

@implementation LbRightImLeftView
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self configData];
    }
    return self;
}

-(instancetype)init{
    if (self = [super init]) {
        [self configData];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configData];
    }
    return self;
}
-(void)configData{
    self.layer.borderColor = JHBorderColor.CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    self.titleLb = [UILabel initialization:CGRectZero font:[UIFont systemFontOfSize:14] textcolor:JHmiddleColor numberOfLines:0 textAlignment:0];
    self.titleLb.text = @"";
    self.rightIm = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"enter"]];
    [self addSubview:self.titleLb];
    [self addSubview:self.rightIm];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.rightIm.frame = CGRectMake(0, 0, self.rightIm.image.size.width, self.rightIm.image.size.height);
    self.rightIm.center = CGPointMake(CGRectGetWidth(self.frame) - self.rightIm.image.size.width/2 - 10, CGRectGetHeight(self.frame)/2);
    self.titleLb.frame = CGRectMake(10, 0, self.rightIm.x_i - 10, CGRectGetHeight(self.frame));
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
