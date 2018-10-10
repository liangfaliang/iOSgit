//
//  CALayer+CALayer_XibCgcolor.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/5/10.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "CALayer+CALayer_XibCgcolor.h"

@implementation CALayer (CALayer_XibCgcolor)
-(void)setBoderColor:(UIColor *)boderColor{
    self.boderColor = boderColor;
}
-(UIColor *)boderColor{
    return [UIColor colorWithCGColor:[self.boderColor CGColor]];
}

@end
