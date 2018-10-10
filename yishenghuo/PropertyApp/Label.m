//
//  Label.m
//  ImagePicker
//
//  Created by 梁法亮 on 16/9/27.
//  Copyright © 2016年 DenJohn. All rights reserved.
//

#import "Label.h"

@implementation Label

- (void)drawTextInRect:(CGRect)rect {
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(c, 2);
    CGContextSetLineJoin(c, kCGLineJoinRound);
    CGContextSetTextDrawingMode(c, kCGTextStroke);
    self.textColor = self.Strokecolor;
    [super drawTextInRect:rect];
    self.textColor = [UIColor whiteColor];
    CGContextSetTextDrawingMode(c, kCGTextFill);
    [super drawTextInRect:rect];
    self.font = [UIFont fontWithName:@"Helvetica-Bold" size:self.BoldFont];
    self.shadowColor  = self.shadowcolor;
    self.shadowOffset = CGSizeMake(1, 1);
}

@end
