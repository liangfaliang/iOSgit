//
//  PregnantHeaderView.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/24.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "PregnantHeaderView.h"

@implementation PregnantHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    [super awakeFromNib];
    self.iconAddbtn.layer.cornerRadius = 30;
    self.iconAddbtn.layer.masksToBounds = YES;
    self.nameBtn.layer.cornerRadius = 5.f;
    self.nameBtn.layer.masksToBounds = YES;
    self.timeTypeLb.layer.cornerRadius = 5.f;
    self.timeTypeLb.layer.masksToBounds = YES;
    
}
-(void)nameBtnBoderIshide:(BOOL)hide{
    if (hide) {
        [self.border removeFromSuperlayer];
        self.self.border = nil;
//        for (CALayer *boder in self.nameBtn.layer.sublayers) {
//            if ([boder isKindOfClass:[CAShapeLayer class]]) {
//                [boder removeFromSuperlayer];
//            }
//        }
    }else{
        if (self.border) {
            [self.border removeFromSuperlayer];
        }
        self.border = [CAShapeLayer layer];
        //虚线的颜色
        self.border.strokeColor = JHMedicalColor.CGColor;
        //填充的颜色
        self.border.fillColor = [UIColor clearColor].CGColor;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.nameBtn.bounds cornerRadius:5];
        //设置路径
        self.border.path = path.CGPath;
        self.border.frame = self.nameBtn.bounds;
        //虚线的宽度
        self.border.lineWidth = 1.f;
        //设置线条的样式
        //    border.lineCap = @"square";
        //虚线的间隔
        self.border.lineDashPattern = @[@4, @2];
        [self.nameBtn.layer addSublayer:self.border];
    }
}
- (IBAction)addBtnClick:(id)sender {
    if (_addblock) {
        _addblock();
    }
}
-(void)setAddblock:(void (^)())addblock{
    _addblock = addblock;
}
@end
