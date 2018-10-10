//
//  DottedView.m
//  PropertyApp
//
//  Created by admin on 2018/7/26.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "DottedView.h"
#import <QuartzCore/QuartzCore.h>
@implementation DottedView
-(instancetype)init{
    if (self = [super init]) {
        self.lineColor = [UIColor redColor];
        self.lineLength = 1;
        self.lineSpacing = 10;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)drawRect:(CGRect)rect{
    CGContextRef context=UIGraphicsGetCurrentContext();//获取绘图用的图形上下文
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);//填充色设置成
    CGFloat lengths[] = {4};
    CGContextSetLineDash(context, 4, lengths,1);
    
    CGContextFillRect(context,self.bounds);//把整个空间用刚设置的颜色填充
    //上面是准备工作，下面开始画线了
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);//设置线的颜色
    CGContextMoveToPoint(context,0,0);//画线的起始点位置
    CGContextAddLineToPoint(context,self.frame.size.width,0);//画第一条线的终点位置
    
    CGContextStrokePath(context);//把线在界面上绘制出来
}

@end
