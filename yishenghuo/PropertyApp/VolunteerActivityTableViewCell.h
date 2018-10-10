//
//  VolunteerActivityTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/12/2.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VolunteerActivityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pictureIm;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLB;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end
