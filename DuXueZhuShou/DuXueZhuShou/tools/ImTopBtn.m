//
//  ImTopBtn.m
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/26.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import "ImTopBtn.h"

@implementation ImTopBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)layoutSubviews{
    [super layoutSubviews];
//    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//
//    //文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
//    [self setTitleEdgeInsets:UIEdgeInsetsMake(self.imageView.frame.size.height + 20 ,-self.imageView.frame.size.width, 0.0,0.0)];
//
//    //图片距离右边框距离减少图片的宽度，其它不边
//    [self setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,0, -self.titleLabel.bounds.size.width)];
    if (self.edgeInsetsStyle ) {
        // 1. 得到imageView和titleLabel的宽、高
        CGFloat imageWith = self.imageView.frame.size.width;
        CGFloat imageHeight = self.imageView.frame.size.height;
        
        CGFloat labelWidth = 0.0;
        CGFloat labelHeight = 0.0;
        if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
            // 由于iOS8中titleLabel的size为0，用下面的这种设置
            labelWidth = self.titleLabel.intrinsicContentSize.width;
            labelHeight = self.titleLabel.intrinsicContentSize.height;
        } else {
            labelWidth = self.titleLabel.frame.size.width;
            labelHeight = self.titleLabel.frame.size.height;
        }
        
        // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
        UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
        UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
        CGFloat space = 0;
        if (self.space) {
            space = self.space;
        }
        // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch (self.edgeInsetsStyle) {
            case MKButtonEdgeInsetsStyleTop:
            {
                imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
                labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
            }
                break;
            case MKButtonEdgeInsetsStyleLeft:
            {
                imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
                labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
            }
                break;
            case MKButtonEdgeInsetsStyleBottom:
            {
                imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
                labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
            }
                break;
            case MKButtonEdgeInsetsStyleRight:
            {
                imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
                labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
            }
                break;
            default:
                break;
        }
        
        // 4. 赋值
        self.titleEdgeInsets = labelEdgeInsets;
        self.imageEdgeInsets = imageEdgeInsets;
    }
}
@end
