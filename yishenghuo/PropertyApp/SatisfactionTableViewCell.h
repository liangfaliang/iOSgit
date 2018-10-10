//
//  SatisfactionTableViewCell.h
//  shop
//
//  Created by 梁法亮 on 16/9/12.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SatisfactionTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *iconimage;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet NSLayoutConstraint *labwidth;

@end
