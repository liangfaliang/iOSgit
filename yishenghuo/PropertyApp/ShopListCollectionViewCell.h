//
//  ShopListCollectionViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/11/11.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPLabel.h"
typedef void(^blockClick)(NSString *str );
@interface ShopListCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imagePic;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *newpriceLb;

@property (weak, nonatomic) IBOutlet LPLabel *oldPrice;
@property (weak, nonatomic) IBOutlet UIButton *cartBtn;
@property (weak, nonatomic) IBOutlet UIImageView *integralImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PriceLeft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PriceWidth;
@property(nonatomic,copy)blockClick block;
-(void)setBlock:(blockClick)block;
@end
