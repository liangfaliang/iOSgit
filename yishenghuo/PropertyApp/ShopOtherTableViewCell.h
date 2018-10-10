//
//  ShopOtherTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/10/31.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYLabel.h"
@interface ShopOtherTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameHeight;
@property (weak, nonatomic) IBOutlet UIImageView *MustImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *MustImHeight;
@property (weak, nonatomic) IBOutlet YYLabel *contentLb;
@property (weak, nonatomic) IBOutlet UIImageView *rigthtIm;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLbLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentRight;


@end
