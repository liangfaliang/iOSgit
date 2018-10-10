//
//  ImRightBtn.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/25.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "ImRightBtn.h"

@implementation ImRightBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)layoutSubviews{
    [super layoutSubviews];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.image.size.width, 0, self.imageView.image.size.width )];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width , 0, -self.titleLabel.bounds.size.width)];
}

@end
