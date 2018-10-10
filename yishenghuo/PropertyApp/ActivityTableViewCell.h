//
//  ActivityTableViewCell.h
//  shop
//
//  Created by 梁法亮 on 16/7/16.
//  Copyright © 2016年 geek-zoo studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityTableViewCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *iconimage;

@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;

@property (retain, nonatomic) IBOutlet UILabel *countLabel;
@property (retain, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLbWidth;
@end
