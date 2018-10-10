//
//  LFLButton.m
//  PropertyApp
//
//  Created by 梁法亮 on 16/7/4.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import "LFLButton.h"


@implementation LFLButton

//在这儿去设置图片显示模式和文字的显示模式以及文字的font
-(instancetype)init{
    
    if (self = [super init]) {
        //图片文字居中
        [self.imageView setContentMode:UIViewContentModeCenter];
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        self.Ratio = 0.7;
        
    }
    
    
    return  self;
}
//重新给按钮的图片设置frame
//contentRect:按钮的bounds
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    
   
    return CGRectMake(0, 0, self.frame.size.width , self.frame.size.height * _Ratio);
    
    
}


-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    
    return CGRectMake(0, self.frame.size.height * _Ratio, self.frame.size.width , self.frame.size.height * (1- _Ratio));
    
}


@end
