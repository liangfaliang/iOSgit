//
//  SignInHeaderView.m
//  DuXueZhuShou
//
//  Created by admin on 2018/8/1.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "SignInHeaderView.h"

@implementation SignInHeaderView
+ (SignInHeaderView *)view{
    return (SignInHeaderView *)[[[NSBundle mainBundle]loadNibNamed:@"SignInHeaderView" owner:self options:nil]firstObject];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.typeLb.layer.cornerRadius = 15;
    self.typeLb.layer.masksToBounds = YES;
    
}
-(void)setModel:(StuSignInModel *)model{
    _model = model;
    self.nameLb.text = model.name;
    self.timeLb.text = [NSString stringWithFormat:@"%@-%@",model.lesson_start_time,model.lesson_end_time];
    self.typeLb.text = model.mode.integerValue == 2 ? @"自由考勤":@"固定考勤";
    if (model.mode.integerValue == 2) {
        self.typeLb.backgroundColor = [UIColor colorFromHexCode:@"bbeee3"];
        self.typeLb.textColor = [UIColor colorFromHexCode:@"1ec7a1"];
        NSString *timeLong = [NSString stringWithFormat:@"   学习时长：%@",model.minimum_time];
        [self.descBtn setAttributedTitle:[timeLong  AttributedString:@"学习时长：" backColor:nil uicolor:JHmiddleColor uifont:nil] forState:UIControlStateNormal];
    }else{
        self.typeLb.backgroundColor = [UIColor colorFromHexCode:@"c1dffd"];
        self.typeLb.textColor = [UIColor colorFromHexCode:@"3296fa"];
        [self.descBtn setTitle:[NSString stringWithFormat:@"   上课前%@min,下课后%@min",model.allowTimeBeforeSignIn,model.allowTimeAfterSignOut] forState:UIControlStateNormal];
    }

    [self addAdress:model.place];
}
-(void)addAdress:(NSArray *)placeArr{
    [self.adressBackview removeAllSubviews];
    CGFloat yy = 0;
    for (int i = 0 ; i < placeArr.count; i ++) {
        placeModel *mo = placeArr[i];
        UIButton *btn = [[UIButton alloc]init];
        [btn setPropertys:[NSString stringWithFormat:@"   可签到地点%d",i+ 1] font:SYS_FONT(15) textcolor:JHmiddleColor image:[UIImage imageNamed:@"address"] state:UIControlStateNormal];
        [btn sizeToFit];
        UILabel *lb = [UILabel initialization:CGRectZero font:SYS_FONT(15) textcolor:JHdeepColor numberOfLines:0 textAlignment:0];
        lb.text = mo.address;
        CGFloat hh = [mo.address selfadap:15 weith:30 + btn.width_i + 5].height + 10;
        hh = hh > 30 ? hh : 30;
        btn.frame = CGRectMake(15, yy, btn.width_i, hh);
        lb.frame = CGRectMake(20 + btn.width_i, yy, screenW - 35 - btn.width_i, hh);
        [self.adressBackview addSubview:btn];
        [self.adressBackview addSubview:lb];
        yy += hh;
    }
    self.adressBackviewHeight.constant = yy;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
