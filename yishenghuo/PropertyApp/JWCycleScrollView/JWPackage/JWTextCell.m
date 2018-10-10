//
//  JWTextCell.m
//  应用教程
//
//  Created by 黄金卫 on 16/4/10.
//  Copyright © 2016年 黄金卫. All rights reserved.
//

#import "JWTextCell.h"

@implementation JWTextCell




#pragma mark- 重写

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createSubViews];
    }
    return self;
}


-(void)createSubViews
{
    _labelView=[[YYLabel alloc]initWithFrame:self.bounds];
    _labelView.numberOfLines=0;
    _labelView.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:_labelView];
}


@end
