//
//  FileIListTableViewCell.h
//  PropertyApp
//
//  Created by admin on 2018/7/23.
//  Copyright © 2018年 wanwuzhishang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFileModel.h"
@interface FileIListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconIm;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconImWidth;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UIImageView *rightIm;
@property (retain, nonatomic) MyFileModel *model;
@end
