//
//  GradesRankTableViewCell.h
//  DuXueZhuShou
//
//  Created by admin on 2018/8/2.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankModel.h"
@interface GradesRankTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *temLbWidth;
@property (weak, nonatomic) IBOutlet UILabel *temLb;
@property (weak, nonatomic) IBOutlet UIButton *rankBtn;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labSpace1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labSpace2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labSpace3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labSpace4;
@property (nonatomic,retain) RankModel *model;
-(void)setlabels:(NSArray *)titleArr;
-(CGFloat )getHeight;
@end
