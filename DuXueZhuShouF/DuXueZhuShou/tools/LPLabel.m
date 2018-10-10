//
//  LPLabel.m
//  label上画横线
//
//  Created by Li Pan on 14-6-30.
//  Copyright (c) 2014年 Pan Li. All rights reserved.
//

#import "LPLabel.h"

@implementation LPLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.strikeThroughEnabled = YES;
        self.strikePosition = strikeThroughCenter;//
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.strikeThroughEnabled = YES;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
 
}
*/

- (void)drawTextInRect:(CGRect)rect
{
    [super drawTextInRect:rect];
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName,nil];
    CGSize textSize = [self.text boundingRectWithSize:(CGSize){self.width_i, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
//    CGSize textSize = [[self text] sizeWithFont:[self font]];
    
    NSLog(@"______textSize = %@ , ______rect = %@",NSStringFromCGSize(textSize),NSStringFromCGRect(rect));
    
    CGFloat strikeWidth = textSize.width;
    
    CGRect lineRect;
    
    if ([self textAlignment] == NSTextAlignmentRight)
    {
        // 画线居中
        lineRect = CGRectMake(rect.size.width - strikeWidth, rect.size.height/2 , strikeWidth, 1);
        
        // 画线居下
        //lineRect = CGRectMake(rect.size.width - strikeWidth, rect.size.height/2 + textSize.height/2, strikeWidth, 1);
    }
    else if ([self textAlignment] == NSTextAlignmentCenter)
    {
        // 画线居中
        lineRect = CGRectMake(rect.size.width/2 - strikeWidth/2, rect.size.height/2, strikeWidth, 1);
        
        // 画线居下
        //lineRect = CGRectMake(rect.size.width/2 - strikeWidth/2, rect.size.height/2 + textSize.height/2, strikeWidth, 1);
    }
    else
    {
        // 画线居中
        lineRect = CGRectMake(0, rect.size.height/2, strikeWidth, 1);
        
        // 画线居下
        //lineRect = CGRectMake(0, rect.size.height/2 + textSize.height/2, strikeWidth, 1);
    }
    // 画线居下
    if (self.strikePosition == strikeThroughBottom) {
        lineRect.origin.y += textSize.height/2;
    }
    if (self.strikeThroughEnabled)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIColor *cgcolor = JHColor(102, 102, 102);
        if (self.strikeThroughColor) {
            cgcolor = self.strikeThroughColor;
        }
        CGContextSetFillColorWithColor(context, cgcolor.CGColor);
        
        CGContextFillRect(context, lineRect);
    }
}

@end
