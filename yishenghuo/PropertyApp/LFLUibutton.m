//
//  LFLUibutton.m
//  shop
//
//  Created by 梁法亮 on 16/6/7.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "LFLUibutton.h"

@implementation LFLUibutton

//在这儿去设置图片显示模式和文字的显示模式以及文字的font
-(instancetype)init{

    if (self = [super init]) {

        [self initialize];
    }


    return  self;
}

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
         [self initialize];
    }
    return self;
}
-(void)initialize{
    //图片文字居中
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.Ratio = 0.7;

}
//重新给按钮的图片设置frame
//contentRect:按钮的bounds
-(CGRect)imageRectForContentRect:(CGRect)contentRect{

 
    return CGRectMake(self.frame.size.width* _Ratio, 0, self.frame.size.width * (1-_Ratio), self.frame.size.height);


}


-(CGRect)titleRectForContentRect:(CGRect)contentRect{

    return CGRectMake(0, 0, self.frame.size.width * _Ratio, self.frame.size.height);

}

@end
