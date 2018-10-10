//
//  PunchOperationTableViewCell.h
//  DuXueZhuShou
//
//  Created by admin on 2018/7/30.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OperateListModel.h"
@interface PunchOperationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (weak, nonatomic) IBOutlet UILabel *bageLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UIImageView *iconIm;
@property (retain, nonatomic)  OperateListModel *omodel;
@end
