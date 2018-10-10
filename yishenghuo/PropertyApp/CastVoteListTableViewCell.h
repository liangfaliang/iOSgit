//
//  CastVoteListTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/18.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CastVoteListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconIMage;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidth;

@end
