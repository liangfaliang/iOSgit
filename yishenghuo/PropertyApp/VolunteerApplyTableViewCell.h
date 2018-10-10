//
//  VolunteerApplyTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/12/6.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VolunteerApplyTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameHeight;


@property (weak, nonatomic) IBOutlet UITextField *contentLb;
@property (weak, nonatomic) IBOutlet UIImageView *rigthtIm;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contenRight;

@end
