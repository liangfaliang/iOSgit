//
//  StuNewsTableViewCell.h
//  DuXueZhuShou
//
//  Created by admin on 2018/7/26.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPLabel.h"
#import "StuNewsModel.h"
@interface StuNewsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet LPLabel *clickLb;
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (retain,nonatomic)StuNewsModel *model;
@end
