//
//  customSlider.m
//  PropertyApp
//
//  Created by 梁法亮 on 17/5/10.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "customSlider.h"

@implementation customSlider

-(CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    
    rect.origin.x=rect.origin.x-10;    
    rect.size.width=rect.size.width+20;
    return CGRectInset([super thumbRectForBounds:bounds trackRect:rect value:value],10,10);
}
@end
