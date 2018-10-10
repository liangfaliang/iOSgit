//
//  PeripheralBusinessTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 17/2/23.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeripheralBusinessTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *iconimage;

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageleft;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *locationBtn;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *xx_imWidth;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *locaBtnWidth;
@property (weak, nonatomic) IBOutlet UIImageView *xx_image;

@end
