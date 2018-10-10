//
//  PushMessageTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 16/12/27.
//  Copyright © 2016年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLbWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImWidth;
@property (weak, nonatomic) IBOutlet UIView *markView;

@end
