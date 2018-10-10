//
//  OneCellView.m
//  shop
//
//  Created by wwzs on 16/5/24.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import "OneCellView.h"
#import "CustomLabel.h"
#import "CustomButton.h"


@interface OneCellView()

@end

@implementation OneCellView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //HOT
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"remen"]];
        //        image.frame = CGRectMake(15, 5, 25, 20);
        [self addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.offset(10);
        }];
        //热门论坛
        //        UILabel *titleLabel = [CustomLabel labBgImg:nil title:@"热门论坛" titleColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14.0] backGroundColor:nil cornerRadius:0.0 textAlignment:NSTextAlignmentCenter];
        //        titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        ////        titleLabel.frame = CGRectMake(42, 0, 70, 30);
        //        titleLabel.textColor = [UIColor redColor];
        //        [self addSubview:titleLabel];
        //        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.centerY.equalTo(self.mas_centerY);
        //            make.height.offset(30);
        //            make.left.equalTo(image.mas_right).offset(5);
        //        }];
        
        //发帖
//        self.postBtn = [CustomButton btnBgImg:[UIImage imageNamed:@"fatie" ] title:@"" titleColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:14.0] backGroundColor:nil cornerRadius:6.0 textAlignment:NSTextAlignmentCenter];
//        self.postBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
//
//        [self addSubview:self.postBtn];
//        [self.postBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.mas_centerY);
//            make.height.offset(30);
//            make.right.offset(-10);
//        }];
        
    }
    return self;
}


@end
