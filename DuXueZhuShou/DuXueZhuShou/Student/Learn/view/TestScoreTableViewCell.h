//
//  TestScoreTableViewCell.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/1.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StuScoreListModel.h"
@interface TestScoreTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *gradeView;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *contentLb;
@property (retain, nonatomic)  StuScoreListModel *model;
-(void)setBackViewSubviews:(NSArray *)titleArr;
@end
