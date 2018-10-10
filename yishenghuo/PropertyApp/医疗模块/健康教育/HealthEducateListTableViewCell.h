//
//  HealthEducateListTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/9.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AritcleNewModel.h"
@interface HealthEducateListTableViewCell : BasicTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UIButton *readBtn;
@property (weak, nonatomic) IBOutlet UIButton *reviewBtn;
@property (nonatomic,retain) AritcleNewModel *model;
@end
