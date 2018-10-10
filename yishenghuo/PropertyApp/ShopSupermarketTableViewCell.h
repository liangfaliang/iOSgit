//
//  ShopSupermarketTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 2017/6/14.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectCountControl.h"
#import "LPLabel.h"
@interface ShopSupermarketTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *NewPriceLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *NewPriceWidth;

@property (weak, nonatomic) IBOutlet LPLabel *oldPriceLb;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *oldPriceRight;
@property (weak, nonatomic) IBOutlet SelectCountControl *countLb;

@end
