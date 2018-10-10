//
//  XX_image.m
//  PropertyApp
//
//  Created by 梁法亮 on 2017/11/22.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import "XX_image.h"
@implementation XX_image
-(void)setSelImage:(UIImage *)selImage{
    _selImage = selImage;
    if (self.xxImage == nil) {
        self.contentMode = UIViewContentModeLeft;
        self.xxImage = [[UIImageView alloc]init];
        self.xxImage.layer.masksToBounds = YES;
        self.xxImage.image = selImage;
        self.xxImage.contentMode = UIViewContentModeLeft;
    }
    
    [self layoutSubviews];
}
-(void)layoutSubviews{
    if (self.xxImage) {
        [self addSubview:self.xxImage];
        [self.xxImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.top.offset(0);
            make.bottom.offset(0);
            make.width.offset(_selImage.size.width * self.scale);
        }];
    }
}
@end
