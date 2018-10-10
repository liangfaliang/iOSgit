//
//  TriangleView.m
//  TsApartment
//
//  Created by 梁法亮 on 2018/7/14.
//  Copyright © 2018年 PmMaster. All rights reserved.
//

#import "TriangleView.h"

@implementation TriangleView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    //定义画图的path
    UIBezierPath *path = [[UIBezierPath alloc] init];
    //path移动到开始画图的位置
    [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height)];
    //从开始位置画一条直线到（rect.origin.x + rect.size.width， rect.origin.y）
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y+ rect.size.height)];
    //再从rect.origin.x + rect.size.width， rect.origin.y））画一条线到(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height)
    
    [path addLineToPoint:CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y)];
    //关闭path
    [path closePath];
    //三角形内填充颜色
    [[UIColor whiteColor] setFill];
    [path fill];
    
    //    //三角形的边框为红色
    
    //    [[UIColor clearColor] setStroke];
    
    //    [path stroke];
    
}


@end
