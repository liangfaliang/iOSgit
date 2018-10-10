//
//  ArchiveDoctorTableViewCell.h
//  PropertyApp
//
//  Created by 梁法亮 on 2018/4/20.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYText.h"
@interface ArchiveDoctorTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconIm;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *DepartLb;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet YYLabel *descYYLb;
@property (weak, nonatomic) IBOutlet UIButton *reserveBtn;

@end
