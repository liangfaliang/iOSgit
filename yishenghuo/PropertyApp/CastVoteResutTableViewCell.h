//
//  CastVoteResutTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 17/4/18.
//  Copyright © 2017年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CastVoteResutTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *countLb;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectviewWidth;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end
