//
//  MyAnswerListTableViewCell.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/2.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerListModel.h"
@interface MyAnswerListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *bageLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (retain,nonatomic) AnswerListModel *model;
@end
