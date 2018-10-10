//
//  TBCycleView.m
//  TBCycleProgress
//
//  Created by qianjianeng on 16/2/22.
//  Copyright © 2016年 SF. All rights reserved.
//

#import "TBCycleView.h"
@interface TBCycleView ()

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end
@implementation TBCycleView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _boderWid = 10;
        _proColor = JHMaincolor;
        _boderColor = JHbgColor;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (UILabel *)label
{
    if (_label == nil) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.width_i - 20, self.height_i - 20)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor grayColor];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
//        label.center = CGPointMake(self.frame.size.width / 2, 50);
        [self addSubview:label];
        _label = label;
    }
    return _label;
}

- (void)drawProgress:(CGFloat )progress
{
    _progress = progress;
    _progressLayer.opacity = 0;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    [self drawCycleProgress];
    
}

- (void)drawCycleProgress
{
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    CGFloat radius = self.frame.size.height / 2 - _boderWid/2;
    CGFloat startA = - M_PI_2;  //设置进度条起点位置
    CGFloat endA = -M_PI_2 + M_PI * 2 * _progress;  //设置进度条终点位置
    
    //获取环形路径（画一个圆形，填充色透明，设置线框宽度为10，这样就获得了一个环形）
    CAShapeLayer *boderLayer = [CAShapeLayer layer];//创建一个track shape layer
    boderLayer.frame = self.bounds;
    boderLayer.fillColor = [[UIColor clearColor] CGColor];  //填充色为无色
    boderLayer.strokeColor = [_boderColor CGColor]; //指定path的渲染颜色,这里可以设置任意不透明颜色
    boderLayer.opacity = 1; //背景颜色的透明度
    boderLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    boderLayer.lineWidth = _boderWid;//线的宽度
    UIBezierPath *boderpath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:-M_PI_2 + M_PI * 2 clockwise:YES];//上面说明过了用来构建圆形
    boderLayer.path =[boderpath CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    [self.layer addSublayer:boderLayer];
    
    
    //获取环形路径（画一个圆形，填充色透明，设置线框宽度为10，这样就获得了一个环形）
    _progressLayer = [CAShapeLayer layer];//创建一个track shape layer
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor = [[UIColor clearColor] CGColor];  //填充色为无色
    _progressLayer.strokeColor = [_proColor CGColor]; //指定path的渲染颜色,这里可以设置任意不透明颜色
    _progressLayer.opacity = 1; //背景颜色的透明度
    _progressLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    _progressLayer.lineWidth = 10;//线的宽度
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];//上面说明过了用来构建圆形
    _progressLayer.path =[path CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    [self.layer addSublayer:_progressLayer];
    //    //生成渐变色
    //    CALayer *gradientLayer = [CALayer layer];
    //
    //    //左侧渐变色
    //    CAGradientLayer *leftLayer = [CAGradientLayer layer];
    //    leftLayer.frame = CGRectMake(0, 0, self.bounds.size.width / 2, self.bounds.size.height);    // 分段设置渐变色
    //    leftLayer.locations = @[@0.3, @0.9, @1];
    //    leftLayer.colors = @[(id)[UIColor yellowColor].CGColor, (id)[UIColor greenColor].CGColor];
    //    [gradientLayer addSublayer:leftLayer];
    //
    //    //右侧渐变色
    //    CAGradientLayer *rightLayer = [CAGradientLayer layer];
    //    rightLayer.frame = CGRectMake(self.bounds.size.width / 2, 0, self.bounds.size.width / 2, self.bounds.size.height);
    //    rightLayer.locations = @[@0.3, @0.9, @1];
    //    rightLayer.colors = @[(id)[UIColor yellowColor].CGColor, (id)[UIColor redColor].CGColor];
    //    [gradientLayer addSublayer:rightLayer];
    //
    //    [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
    //    [self.layer addSublayer:gradientLayer];
    
}


@end
