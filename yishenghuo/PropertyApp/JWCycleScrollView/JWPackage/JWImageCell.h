//
//  JWImageCell.h
//  ImageScrollView
//
//  Created by 黄金卫 on 16/4/6.
//  Copyright © 2016年 黄金卫. All rights reserved.
//
//@class JWCycleScrollView;
#import <UIKit/UIKit.h>

@interface JWImageCell : UICollectionViewCell

@property (nonatomic, copy) NSString  * imageName;
@property (nonatomic, strong) NSURL   * imageURL;

@property (nonatomic, copy) NSString  * placeHolderImageName;
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UIImageView * leftImageView;
@property (nonatomic, strong) UIImageView * RightImageView;
@property (nonatomic, strong)  UILabel * label;

@property (nonatomic) UIViewContentMode imageMode;
//@property (nonatomic, assign) ContentType contentType;          //轮播内容样式
@end
