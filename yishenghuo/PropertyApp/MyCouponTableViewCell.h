//
//  MyCouponTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 2017/8/17.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCouponTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLb;
@property (weak, nonatomic) IBOutlet UILabel *factorLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *factorLbWidth;
@property (weak, nonatomic) IBOutlet UIView *backviewWhite;
@property (weak, nonatomic) IBOutlet UIView *backviewYellow;
@property (weak, nonatomic) IBOutlet UILabel *EffectiveTimeLb;
@property (weak, nonatomic) IBOutlet UIImageView *layerView;
@property (weak, nonatomic) IBOutlet UIImageView *layerTypeIm;

@end
